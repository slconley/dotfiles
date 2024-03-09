# shellcheck shell=bash

# capture current PATH for cygwin/msys before making any changes
[ "$OSTYPE" = "cygwin" ] && export CYGPATH=${CYGPATH:=$PATH}
[ "$OSTYPE" = "msys" ] && export MSYSPATH=${MSYSPATH:=$PATH}
PATH=$HOME/.local/bin:$HOME/.files/bin:/usr/local/bin:/usr/local/opt/bin:/usr/bin:/bin:/usr/sbin:/sbin:

export LSCOLORS=exfxcxdxcxegedabagacad   # macOS only?
export LS_COLORS=$(tr -d '\n' << END
no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:
*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:
*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;34:*.jpeg=01;34:*.gif=01;34:*.bmp=01;34:*.pbm=01;34:
*.pgm=01;34:*.ppm=01;34:*.tga=01;34:*.xbm=01;34:*.xpm=01;34:*.tif=01;34:*.tiff=01;34:*.png=01;34:
*.mov=01;34:*.mpg=01;34:*.mpeg=01;34:*.avi=01;34:*.fli=01;34:*.gl=01;34:*.dl=01;34:*.xcf=01;34:
*.xwd=01;34:*.ogg=01;34:*.mp3=01;34:*.wav=01;34:
END
)


# ------------------------------------------------------------
# any non-interactive stuff should go above this line
# ------------------------------------------------------------
[ -z "$PS1" ] || [ ! $TERM ] && return

# ------------------------------------------------------------
# preferred shell defaults to zsh if available
# ------------------------------------------------------------
export PREFSHELL=${PREFSHELL:=zsh}
[ "$PREFSHELL" = "bash" ] && [ -z "$BASH" ] && which bash >/dev/null 2>&1 && exec bash
[ "$PREFSHELL" = "zsh"  ] && [ -z "$ZSH_NAME" ] && which zsh >/dev/null 2>&1 && exec zsh

# uh, what was this for again?
# [ "$ZSH_REEXEC" ] || { export ZSH_REEXEC=done; exec zsh; }


# ----------------------------------------
# generic stuff
# ----------------------------------------
umask 77
me="$(command id -un)"
for d in \
  $HOME/.local/profile.d/default  $HOME/.var/$HOST  $HOME/.var/.global \
  $HOME/.terraform.d/plugin-cache  $TMPDIR/ssh/auth $TMPDIR/ssh/cp; \
do
    [ -d $d ] || mkdir -p $d 2> /dev/null
done
umask 22

# ----------------------------------------
# keep ssh init above screen
# ----------------------------------------
authfile=$TMPDIR/ssh/auth/ssh_auth_sock.${HOST}.${OSTYPE}
[ -h $authfile ] && [ ! -e $authfile ] && rm $authfile
[ -h $authfile ] && export SSH_AUTH_SOCK=$authfile
ssh-add -l > /dev/null 2>&1 || { [ $? -eq 2 ] && rm -f $authfile 2> /dev/null && SSH_AUTH_SOCK=""; }
[ -z "$SSH_AUTH_SOCK" ] && eval $(ssh-agent)
[ -S "$SSH_AUTH_SOCK" ] && [ ! -h "$SSH_AUTH_SOCK" ] && [ ! -e $authfile ] && ln -sf "$SSH_AUTH_SOCK" $authfile
[ -f ~/.ssh/config ] && alias scp='scp -F ~/.ssh/config'

# ----------------------------------------
# attempt to use tmux if it is available
# ----------------------------------------
if which tmux >/dev/null 2>&1 && [[ "$TERM" != *screen* ]] && [[ ! "$TERMCAP" =~ .*screen.* ]] && [[ ! -f ~/.notmux || "$TERM_PROGRAM" = "vscode" ]];  then
  tmux -l
fi

# ----------------------------------------
# attempt to use screen if it is available
# note: tmux above trumps screen
# ----------------------------------------
export SCREENDIR=$TMPDIR/.screen.$USER
SCREEN_OPTS=''; [ "$TERM_PROGRAM" = "vscode" ] && SCREEN_OPTS='-m'
if which screen >/dev/null 2>&1 && [[ "$TERM" != *screen* ]] && [[ ! "$TERMCAP" =~ .*screen.* ]] && [[ ! -f ~/.noscreen || "$TERM_PROGRAM" = "vscode" ]];  then
  screen $SCREEN_OPTS -RR
fi

PATH="$PATH:/usr/local/sbin:/opt/local/bin:/opt/local/sbin:/usr/proc/bin"
PATH=$(echo "$PATH" | sed  -E 's/[[:space:]]*:[[:space:]]*/:/g')


export BASH_SILENCE_DEPRECATION_WARNING=1
export CC=gcc
export COLOR_GRC="--colour=on"
export COLOR_GREP="--color=always"
export COLOR_LS="--color=always"
export EDITOR=vi
export ES_NETWORK_HOST=localhost
export FUNCNEST=25
export FZF_DEFAULT_OPTS='-e --ansi --no-mouse'
export GPG_TTY=$(tty)
export GNUPGHOME=${GNUPGHOME:-$HOME/.gnupg}
export GREP_COLOR='01;32'
export GREP_COLORS='ms=01;32:mc=01;32:sl=:cx=:fn=36:ln=33:bn=33:se=36'
export GROK="$HOME/{,xcloud/}opt/share/grok $HOME/.local/grok"
export HISTCONTROL=ignoreboth
export HISTSIZE=4999
export HISTSIZE_GLOBAL=999999
export HISTTIMEFORMAT='%F %T '
export HISTFILESIZE=$HISTSIZE
export LANG=C
export LDAPTLS_REQCERT=require    # change to "allow" to relax this
export LESS="aiej10RSsMPM?f?mfile %i/%m. %f. ?lbline %lb?L/%L. :byte %bB?s/%s. .?e(END) ?x- Next\: %x.:?pB%pB\%..%t"
export LESSOPEN="|$HOME/.files/bin/see %s"
export INDICES="$HOME/.local/indices/* $HOME/*/.index.gz /Volumes/Vault/.index.gz"
export PAGER=more
export PKG_CONFIG_PATH=/usr/share/pkgconfig
export SYSLOG=/var/log/messages
export TOP="-s3"
export TTY=$(who am i|awk '{print $2}'|sed 's./._.')

export esEndpoint=${ES_NETWORK_HOST}:9200

export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
export LESS_TERMCAP_me=$'\E[0m'           # end mode
export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
export LESS_TERMCAP_ue=$'\E[0m'           # end underline
export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline

# conditional stuff
[ -d ~/.local/profile.d/$HOST ] && SUBENV=$HOST
[ "$SUBENV" ] || SUBENV=default; export SUBENV
which less >/dev/null 2>&1 && PAGER=less
which vim  >/dev/null 2>&1 && EDITOR=vim

# --------------------------------------------------------------------------------
# these get redifined later, or I just don't like other config interfering
# --------------------------------------------------------------------------------
unalias cp >/dev/null 2>&1
unalias l  >/dev/null 2>&1
unalias ll >/dev/null 2>&1
unalias ls >/dev/null 2>&1
unalias rm >/dev/null 2>&1

# --------------------------------------------------
# no thanks
# --------------------------------------------------
unset SSH_ASKPASS
unset TMOUT

# ----------------------------------------------------------------------
# aliases
# ----------------------------------------------------------------------
alias @='curl http://ipinfo.io/'
alias \#=:    # allows comments to be pasted into command buffer along with commands
alias compinit='compinit -C -d ~/.zsh/$HOST/.zcompdump'
alias df='df -h'
alias du='du -h'
alias fixauth='screen -X setenv SSH_AUTH_SOCK "$SSH_AUTH_SOCK"'
alias grep="grep -Ed skip --exclude-dir '*git'"
alias gs='git status -s'
alias l.='$GRC ls -Fd $COLOR_LS .* 2> /dev/null'
alias mkdir='mkdir -p'
alias now="date -u '+%Y%m%dT%H%M%SZ'"
# alias pkill='pkill -U $EUID'
alias pssh='pssh -x \"-tt\"'
alias script='script ~/.local/var/$HOST/log/script.$(now)'
alias serial='screen /dev/ttyS0 9600'
alias sha='openssl sha256'
alias sls='screen -ls'
alias sops='TERM=xterm sops'
alias t='$GRC traceroute -I'
alias ta='tmux attach -dxt'
alias tf='terraform'
alias tlog='tail -50f $SYSLOG'
alias today="date -u '+%Y%m%d'"
alias vi='$EDITOR'
alias vless='/usr/share/vim/vim70/macros/less.sh'
alias vm='VBoxManage'
alias which='which -a'

# conditional aliases
[[ "$TTY" =~ "tty[0-9]" ]] && alias tmux='tmux -L$(basename $TTY)'

# ----------------------------------------------------------------------
# functions
# ----------------------------------------------------------------------
a()        { apropos $* 2> /dev/null; }
c()        { clear; }
color-()   { unset CLICOLOR COLOR_GREP COLOR_LS COLORFGBG COLORTERM GRC LSCOLORS LS_COLORS ZLS_COLORS ; COLOR_GRC='--colour=off'; }
bak()      { cp -rp "$1" "${1}.$(/bin/date -u '+%Y%m%dT%H%MZ'~)"; }
defpass()  { gzip -dc ~/share/etc/passwords/* | grep -i $*; }
dx()       { docker run -ith dx --rm -e HOME=$HOME -v ~:$HOME $* $PREFSHELL; }
e()        { (set;command env)| grep -va '^[_	 ]' | cut -c1-120 | sort -u | grep -ai $COLOR_GREP $*; }
eb()       { savehist; export PREFSHELL=bash; exec bash -l;}
ec()       { savehist; export PREFSHELL=csh; exec csh;}
errno()    { less -p $1 $errfile; }
es()       { savehist; screen $SCREEN_OPTS -RR; }
ez()       { savehist; export PREFSHELL=zsh; exec zsh -l;}
fgrok()    { eval grep -ilr $* $GROK; }
getenv()   { [ "$SUBENV" = "$1" ] && return; SUBENV=$1; exec $PREFSHELL; }
gr()       { grep -i $COLOR_GREP $*;}
grok()     { less -j10 +/$1 $(eval grep -ilr $* $GROK 2>/dev/null) 2> /dev/null ;}
h()        { history | grep -i "$*"|tail -30; }
header()   { echo -ne "\e]0;$me@${HOST}\a"; }
hh()       { grep -ih $1 $HOME/.local/var/$HOST/history/* $HOME/cloud/*/var/$HOST/history/* 2>/dev/null| cut -d ';' -f2- | sort -u | grep -i $COLOR_GREP $1; }
hhh()      { grep -ih $1 $HOME/.local/var/*/history/* $HOME/cloud/*/home/var/*/history/* | cut -d ';' -f2- | sort -u | grep -i $COLOR_GREP $1; }
io()       { iostat -xnmz $* 3; }
l()        { command ls -F $COLOR_LS $*; }
loc()      { ( locate -i $1; eval gzip -dc $INDICES 2> /dev/null) | grep -i $COLOR_GREP $1; }
lt()       { $GRC ls -lrtF $COLOR_LS $*; }
otr()      { savehist; unset HISTFILE HISTFILE_GLOBAL; }
p()        { $PAGER $*;}
passgen()  { local l=${1:=24}; head -${l} /dev/urandom | base64 | rev | cut -c${l}- | base64 | cut -c1-${l};}
pod()      { pod2text --code $* | $PAGER; }
pscpu()    { ps -eo user,pid,ppid,pcpu,vsz,rss,pmem,args | grep -i $COLOR_GREP "COMMAND|$*."|grep -v grep|sort -k4; }
psg()      { $GRC ps -ef | grep -v grep | grep -i $COLOR_GREP $*; }
psmem()    { ps -eo user,pid,ppid,pcpu,vsz,rss,pmem,args | grep -i $COLOR_GREP "COMMAND|$*."|grep -v grep|sort -k6; }
pss()      { ps -ef | grep -i $COLOR_GREP $*. | grep -v grep | sort -k2; }
pstime()   { ps -ef | grep -i $COLOR_GREP $*. | grep -v grep | sort -k5; }
restart()  { service $1 restart; }
s()        { sudo -sE HOME=$HOME; }
savehist() { history -a; }
showcerts() { openssl s_client -connect $1 -servername ${1%:*} -showcerts < /dev/null; }
sslconn()  { openssl s_client -connect $1 -servername ${1%:*} < /dev/null; }
sockets()  { netstat -anp | grep -ai "list|idle|tcp|udp" | grep -i $COLOR_GREP "$*"; }
sourcevault() { source <(ansible-vault view $*); }
start()    { service $1 start; }
status()   { service $1 status; }
stop()     { service $1 stop; }
tcp()      { lsof -i tcp | grep -i $* ; }
tgz()      { tar cvzf ${1}.tgz $1; }
zipit()    { zip -ry ${1}.zip $1; }
