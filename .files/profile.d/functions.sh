# print horizontal line (variable length)
# accepts arg and uses first char to build line (default: "-"
hl() {
  local cols="${COLUMNS:-$(tput cols)}"; cols="${cols:-80}"
  local char="${1:--}"; char=${char:0:1}
  printf -v line '%*s' "$cols" ''; printf '%s\n' "${line// /${char}}"
}
