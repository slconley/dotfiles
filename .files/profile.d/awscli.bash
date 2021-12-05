completer=$(command -v aws); completer="${completer%/*}/aws_completer"
[ -f "$completer" ] && complete -C "$completer" aws
unset completer
