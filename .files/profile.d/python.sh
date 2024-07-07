# bail if "python" is already a thing
[ -x $XDG_RUNTIME_DIR/bin/python ] || which python >/dev/null 2>&1 && return

# locate python and create symlink
[ -d $XDG_RUNTIME_DIR/bin ] || mkdir -p $XDG_RUNTIME_DIR/bin
p=$(command which python3 || command which python2)
[ "$p" ] && ln -s $p $XDG_RUNTIME_DIR/bin/python

