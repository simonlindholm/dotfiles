# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Move the gnome-terminal window to the top-left corner. Sadly done for each
# tab, but I can't find a way around that.
# if [ $gnterm = y ]; then
	# wmctrl -e 0,0,0,-1,-1 -r ':ACTIVE:'
	# unset gnterm
# fi

# don't put duplicate lines in the history, and skip lines starting with space
export HISTCONTROL=ignoreboth

HISTIGNORE='sudo poweroff '

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=5000

# Reverse search on up/down (in inputrc)
# bind '"\e[A": history-search-backward'
# bind '"\e[B": history-search-forward'

# ALSO, to not break ctrl+left etc.:
# "\e[C": forward-char
# "\e[D": backward-char
# "[1;5C": forward-word
# "[1;5D": backward-word

# append to the history file, don't overwrite it
shopt -s histappend

# Recursive globbing with **
shopt -s globstar

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac


# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

#if [ -f ~/.bash_aliases ]; then
#    . ~/.bash_aliases
#fi

# enable color support of ls
if [ -x /usr/bin/dircolors ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto -B'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

function mkcd() {
	[ -n "$1" ] && mkdir -p "$@" && cd "$1"
}

function apc() {
	apt-cache "$@" | less
}

function z() {
	LSA=`mktemp`
	LSB=`mktemp`
	/bin/ls >$LSA
	/usr/bin/file-roller --extract-here "$@" || (rm $LSA && exit 1)
	/bin/ls >$LSB
	D=`diff $LSA $LSB --unchanged-line-format=`
	if [[ $D != '' ]]; then cd "$D" 2>/dev/null; rm "../$1"; fi
	rm $LSA $LSB
}

function zk() {
	# z, keep
	local LSA=`mktemp`
	local LSB=`mktemp`
	/bin/ls >$LSA
	/usr/bin/file-roller --extract-here "$@" || (rm $LSA && exit 1)
	/bin/ls >$LSB
	local D=`diff $LSA $LSB --unchanged-line-format=`
	if [[ $D != '' ]]; then cd "$D" 2>/dev/null; fi
	rm $LSA $LSB
}

function printpathvar() {
	eval value=\"\$$1\"
	echo "$value" | tr ':' '\n'
	unset value
}

function editpathvar() {
	local tmp=`mktemp`
	echo "Outputting to $tmp..."
	printpathvar $1 > $tmp
	$EDITOR $tmp
	export $1=`cat $tmp | tr '\n' ':'`
	rm $tmp
}

function ff() {
	find . -iname "*$1*"
}

# Colored man
man() {
	env \
		LESS_TERMCAP_mb=$(printf "\e[1;31m") \
		LESS_TERMCAP_md=$(printf "\e[1;31m") \
		LESS_TERMCAP_me=$(printf "\e[0m") \
		LESS_TERMCAP_se=$(printf "\e[0m") \
		LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
		LESS_TERMCAP_ue=$(printf "\e[0m") \
		LESS_TERMCAP_us=$(printf "\e[1;32m") \
		man "$@"
}

# read GNU Info pages as man pages. Depends on info2man being installed
mani() {
	info_page="$1"
	first_page=$(info -w "$info_page")
	# pick up info-1.gz etc. info2man supports this but not when gzipped.
	glob="$(basename $first_page | sed 's/.gz$//')-*"
	rest_page=$(find $(dirname $first_page) -name "$glob" | sort -n)
	info2man <(zcat $first_page $rest_page) | groff -man -Tutf8 | less
}

# Whoo git!
GIT_PS1_SHOWDIRTYSTATE=1
PS1='\u@\h:\w`__git_ps1`\$ '

export GREP_OPTIONS='--exclude=*.swp --exclude=*.svn-base'
export LANGUAGE=en
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LESS="-i"

# Allow Ctrl+S, Ctrl+Q
stty start undef
stty stop undef

alias pg='pgrep -fl'
alias h="history | grep"
alias ll='ls -l'
alias la='ls -A'
alias l='ls'
alias g='git'
alias n='nice -n'
alias rmb='/bin/rm *~'
alias open='xdg-open'
alias c='g++ -Wall -g -ftrapv -Wconversion -D_GLIBCXX_DEBUG -D_GLIBC_DEBUG -std=c++0x'
alias make='make -j2'
alias waf='./waf'
alias svnd='svn diff | dless'

# ulimit -v 700000

# no idea why this seems to be needed in 20% of cases
if [[ `pwd` == / ]]; then cd; fi


# http://jeroenjanssens.com/2013/08/16/quickly-navigate-your-filesystem-from-the-command-line.html
export MARKPATH=$HOME/.marks
function j {
    cd -P $MARKPATH/$1 2>/dev/null || echo "No such mark: $1"
}
function mark {
    mkdir -p $MARKPATH; ln -s $(pwd) $MARKPATH/$1
}
function unmark {
    rm -i $MARKPATH/$1
}
function marks {
    ls -l $MARKPATH | sed 's/  / /g' | cut -d' ' -f9- | sed 's/ -/\t-/g' && echo
}
function _jump {
	local cur=${COMP_WORDS[COMP_CWORD]}
	local marks=$(find $MARKPATH -type l -printf "%f\n")
	COMPREPLY=($(compgen -W '${marks[@]}' -- "$cur"))
	return 0
}
complete -o default -o nospace -F _jump j

