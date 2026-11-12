#!/usr/bin/env bash
# effort-recorder.sh — Claude Code の statusLine から呼ぶ
#
# セッションごとの effort.level を ~/.cache/claude-effort/<session_id> に、
# モデル（model.id）を ~/.cache/claude-model/<session_id> に記録する。
# 記録した値は claude shim（~/.claude-shim/bin/claude）が `claude --resume <id>` のときに
# --effort / --model として付け足す（herdr のペイン復元と agent-resume の再開で effort とモデルを戻すため）。
#
# 使い方（~/.claude/settings.json）:
#   単体で使う:            "command": "~/.claude/effort-recorder.sh"
#   既存のステータスラインと併用: "command": "~/.claude/effort-recorder.sh ~/.claude/statusline.sh"
#   （引数に渡したコマンドへ、Claude Code から受け取った JSON をそのまま渡す）

input=$(cat)
EFFORT_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/claude-effort"
MODEL_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/claude-model"
UUID_RE='^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$'
# --model に渡せる形の ID（claude-opus-5-5、claude-opus-5-5[1m]、Bedrock の ID など）
MODEL_RE='^[A-Za-z0-9][]A-Za-z0-9._:/@[-]*$'

IFS='|' read -r sid level model_id model < <(
  printf '%s' "$input" |
    jq -r '"\(.session_id // "")|\(.effort.level // "")|\(.model.id // "")|\(.model.display_name // "")"' 2>/dev/null
)

# $1 のフォルダーの <session_id> に $2 を書く。
# refreshInterval で何度も呼ばれるので、値が変わったときだけ書く。
# 書きかけを shim に読ませないよう、一時ファイルに書いてから rename する
save() {
  local file="$1/$sid" tmp="$1/.$sid.$$" current=
  [ -r "$file" ] && IFS= read -r current <"$file"
  [ "$current" = "$2" ] && return 0
  mkdir -p "$1" &&
    printf '%s\n' "$2" >"$tmp" &&
    mv -f "$tmp" "$file"
}

if [[ $sid =~ $UUID_RE ]]; then
  case "$level" in
    low | medium | high | xhigh | max) save "$EFFORT_DIR" "$level" ;;
  esac
  [[ $model_id =~ $MODEL_RE ]] && save "$MODEL_DIR" "$model_id"
fi

if [ "$#" -gt 0 ]; then
  printf '%s' "$input" | "$@"
else
  printf '[%s] effort: %s\n' "${model:-?}" "${level:-n/a}"
fi
