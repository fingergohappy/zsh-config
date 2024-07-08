# https://github.com/zsh-users/zsh-autosuggestions/issues/238
# 解决zsh卡顿的问题,添加了有奇效
SPACESHIP_PROMPT_ASYNC=FALSE
pasteinit() {
  OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
  zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
}

pastefinish() {
  zle -N self-insert $OLD_SELF_INSERT
}
zstyle :bracketed-paste-magic paste-init pasteinit

# yazi 
function yy() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		z  "$cwd"
	fi
	rm -f -- "$tmp"
}



# ______   ______     ______  
#/\  ___\ /\___  \   /\  ___\ 
#\ \  __\ \/_/  /__  \ \  __\ 
# \ \_\     /\_____\  \ \_\   
#  \/_/     \/_____/   \/_/   
                             
# fzf config
export FZF_DEFAULT_COMMAND='fd -H . . $HOME '
export FZF_DEFAULT_OPTS='-x -e'
export FZF_COMPLETION_TRIGGER='\'
# Options to fzf command
export FZF_COMPLETION_OPTS='--border --info=inline'
export FZF_TMUX=1
export FZF_TMUX_OPTS='-p80%,60%'
# Preview file content using bat (https://github.com/sharkdp/bat)
export FZF_CTRL_T_COMMAND='fd -H . . $HOME '
export FZF_CTRL_T_OPTS="
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"

export FZF_CTRL_R_OPTS="
  --preview 'echo {}' --preview-window up:3:hidden:wrap
  --bind 'ctrl-/:toggle-preview'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --color header:italic
  --header 'Press CTRL-Y to copy command into clipboard'"

# Use fd (https://github.com/sharkdp/fd) instead of the default find
# command for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'tree -C {} | head -200'   "$@" ;;
    export|unset) fzf --preview "eval 'echo \$'{}"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview 'bat -n --color=always {}' "$@" ;;
  esac
}

# tmux config
if [[ $TMUX != "" ]] then
    export TERM="tmux-256color"
else
    # export TERM="xterm-256color"
    export TERM="wezterm"
fi

# Set colors for man pages
function man() {
  env \
  LESS_TERMCAP_mb=$(printf "\e[1;31m") \
  LESS_TERMCAP_md=$(printf "\e[1;31m") \
  LESS_TERMCAP_me=$(printf "\e[0m") \
  LESS_TERMCAP_se=$(printf "\e[0m") \
  LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
  LESS_TERMCAP_ue=$(printf "\e[0m") \
  LESS_TERMCAP_us=$(printf "\e[1;32m") \
  command man "$@"
}

