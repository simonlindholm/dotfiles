# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
	*i*) ;;
	  *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

HISTIGNORE='sudo poweroff '

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

# save to file continuously, not just when exiting
PROMPT_COMMAND="history -a;$PROMPT_COMMAND"

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=200000
HISTFILESIZE=400000

# Recursive globbing with **
shopt -s globstar

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# case-sensitive []-globbing
shopt -s globasciiranges

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
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

# Enable color support of ls and grep
if [ -x /usr/bin/dircolors ]; then
	test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
	alias ls='ls --color=auto'
	alias grep='grep --color=auto'
	alias fgrep='fgrep --color=auto'
	alias egrep='egrep --color=auto'
fi

# Enable programmable completion features
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
	. /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
	. /etc/bash_completion
  fi
fi

function mkcd() {
	[ -n "$1" ] && mkdir -p "$@" && cd "$1"
}

function z() {
	LSA=`mktemp`
	/bin/ls >$LSA
	/usr/bin/file-roller --extract-here "$@" || (rm $LSA && exit 1)
	LSB=`mktemp`
	/bin/ls >$LSB
	D=`diff $LSA $LSB --unchanged-line-format=`
	if [[ $D != '' ]]; then cd "$D" 2>/dev/null && rm "../$1"; fi
	rm $LSA $LSB
}

function zk() { # z, keep
	/usr/bin/file-roller --extract-here "$@"
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

# Uncolored prompt, with a git status indicator.
GIT_PS1_SHOWDIRTYSTATE=1
function __git_ps1_local() {
	p=$(pwd)/
	if [[ $p == /home/simon/code/* && $p != /home/simon/code/servo/* ]]
	then
		__git_ps1
	fi
}
PS1='\[\e]0;\w\a\]\u@\h:\w`__git_ps1_local`\$ '

export GIT_COMPLETION_CHECKOUT_NO_GUESS=1

export LANGUAGE=en
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LESS="-Ric"

# Colorize gcc output with 4.9 or later
export GCC_COLORS="error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01"

# Allow Ctrl+S, Ctrl+Q
stty start undef
stty stop undef

# Alias definitions.
if [ -f ~/.bash_aliases ]; then
	. ~/.bash_aliases
fi
alias pg='pgrep -fl'
alias h="history | grep"
alias rg='rg -M 300 --no-ignore-global'
alias ll='ls -l'
alias la='ls -A'
alias n='nice -n'
alias rmb='/bin/rm *~'
alias open='xdg-open'
alias c='g++-6 -Wall -Wfatal-errors -g -fsanitize=undefined,address -Wconversion -std=c++11 -DLOCAL -fconcepts' # -fno-sanitize-recover=all
# alias c='clang++-6.0 -Wall -Wconversion -Wno-sign-conversion -Wfatal-errors -g -fsanitize=address,undefined -stdlib=libc++ -std=c++14 -include /usr/include/c++/v1/bits/stdc++.h' # -fno-sanitize-recover=all
alias c2='g++ -Wall -Wfatal-errors -g -fsanitize=undefined -Wconversion -D_GLIBCXX_DEBUG -std=c++14'
alias copt='g++ -Wall -Wconversion -Wno-sign-conversion -Wfatal-errors -g -std=c++14 -O2'
alias make='make -j2'
alias ap='sudo apt-get'
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"' # (e.g. sleep 10; alert)
alias touchold='touch -t 200001010101'
function apc() {
	apt-cache "$@" | less
}


# breaks asan
# ulimit -v 700000
# breaks wine
# ulimit -s 3000000


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

# Map "," to "git " at the beginning of line (for interactive shells)
function commaToGit {
	if [[ $READLINE_POINT == "0" ]]; then
		READLINE_LINE="git $READLINE_LINE"
		READLINE_POINT=4
	else
		READLINE_LINE=${READLINE_LINE:0:$READLINE_POINT},${READLINE_LINE:$READLINE_POINT}
		let READLINE_POINT++
	fi
}
if [[ -t 1 ]]; then
	bind -x '",":commaToGit'
	bind '"\":" fg\n"'
fi

function paste() {
	local file=${1:-/dev/stdin}
	curl --data-binary @${file} https://paste.rs
}

function pdfl {
	pdflatex -file-line-error </dev/null "$@" | grep '^\./\|^!'
}

export EDITOR=/usr/bin/vim
export PYTHONSTARTUP=~/.pythonrc

export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/bin"
#export PATH="$HOME/code/git-cinnabar:$PATH"
# (etc.)

export HISTTIMEFORMAT="%d/%m/%y %T "
