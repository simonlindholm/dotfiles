function _commaToGit {
	if [[ -z $LBUFFER ]]; then
		LBUFFER='git '
	else
		zle self-insert
	fi
}
zle -N _commaToGit
bindkey , _commaToGit
