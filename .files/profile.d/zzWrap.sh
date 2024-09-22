# shellcheck shell=bash

# fzf tweaks
which fzf > /dev/null 2>&1 && {
  fv()  { print -z "$EDITOR $(eval grep -ilr $1 $GROK 2> /dev/null | fzf -m --preview 'head -200 {}'; )";  }
  hhh() { fc -ln 1 | grep -ih "$1" | fzf; }
  pw()  { lpass show -c --password $(lpass ls  | fzf | awk '{print $(NF)}' | sed 's/\]//g'); }
}

