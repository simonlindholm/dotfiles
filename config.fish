# Fish-shell port of various bashrc things. Put in ~/.config/fish/config.fish.

set -x EDITOR /bin/vim
set -x LESS -Ri

alias c 'g++ -Wall -g -O1 -fsanitize=undefined -Wconversion -D_GLIBCXX_DEBUG -D_GLIBC_DEBUG -std=c++11'
alias open 'xdg-open'
alias pg 'pgrep -fl'
alias ap 'sudo apt-get'

# Map "," to "git " at the beginning of line
function commaToGit
	if test (commandline -C) = 0
		commandline -i "git "
	else
		commandline -i ","
	end
end

function fish_user_key_bindings
	bind "," commaToGit
end

set -x __fish_git_prompt_showdirtystate 'yes'
set -x __fish_git_prompt_showstashstate 'yes'
set -x __fish_git_prompt_showupstream 'yes'
set -x __fish_git_prompt_color_branch yellow

# Status Chars

set -x __fish_git_prompt_char_dirtystate 'd'
set -x __fish_git_prompt_char_stagedstate 's'
set -x __fish_git_prompt_char_stashstate 't'
set -x __fish_git_prompt_char_upstream_ahead 'a'
set -x __fish_git_prompt_char_upstream_behind 'b'

function fish_prompt
	set last_status $status
	if test $TERM '=' 'dumb';
		printf '> '
	else
		printf '%s:' (hostname)
		set_color $fish_color_cwd
		printf '%s' (prompt_pwd)
		set_color normal
		printf '%s ' (__fish_git_prompt)
		set_color normal
	end
end
