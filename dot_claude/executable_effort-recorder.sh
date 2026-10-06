#!/usr/bin/env bash
# effort-recorder.sh — Claude Code の statusLine から呼ぶ
#
# セッションごとの effort.level を ~/.cache/claude-effort/<session_id> に記録する。
# 記録した値は claude shim（~/.claude-shim/bin/claude）が `claude --resume <id>` のときに
# --effort として付け足す（herdr のペイン復元で effort を戻すため）。
#
# 使い方（~/.claude/settings.json）:
#   単体で使う:            "command": "~/.claude/effort-recorder.sh"
#   既存のステータスラインと併用: "command": "~/.claude/effort-recorder.sh ~/.claude/statusline.sh"
#   （引数に渡したコマンドへ、Claude Code から受け取った JSON をそのまま渡す）

input=$(cat)
EFFORT_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/claude-effort"
UUID_RE='^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$'

IFS='|' read -r sid level model < <(
  printf '%s' "$input" |
    jq -r '"\(.session_id // "")|\(.effort.level // "")|\(.model.display_name // "")"' 2>/dev/null
)

if [[ $sid =~ $UUID_RE ]]; then
  case "$level" in
    low | medium | high | xhigh | max)
      file="$EFFORT_DIR/$sid"
      current=
      [ -r "$file" ] && IFS= read -r current <"$file"
      # refreshInterval で何度も呼ばれるので、値が変わったときだけ書く。
      # 書きかけを shim に読ませないよう、一時ファイルに書いてから rename する
      if [ "$current" != "$level" ]; then
        tmp="$EFFORT_DIR/.$sid.$$"
        mkdir -p "$EFFORT_DIR" &&
          printf '%s\n' "$level" >"$tmp" &&
          mv -f "$tmp" "$file"
      fi
      ;;
  esac
fi

if [ "$#" -gt 0 ]; then
  printf '%s' "$input" | "$@"
else
  printf '[%s] effort: %s\n' "${model:-?}" "${level:-n/a}"
fi
