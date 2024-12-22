# ====================
# 基础设置
# ====================
source /Users/fingerfrings/script/shell/toggle-proxy.sh > /dev/null


### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

############################################################################costom config#########################################################


zinit wait light-mode for \
    zsh-users/zsh-syntax-highlighting \
    atload'autoload -U compinit; compinit' Aloxaf/fzf-tab \
    zsh-users/zsh-completions \
    sunlei/zsh-ssh \
    atload"_zsh_autosuggest_start" zsh-users/zsh-autosuggestions \
    atload"eval $(zoxide init --cmd cd zsh)" ajeetdsouza/zoxide 

zinit light-mode for \
        agkozak/agkozak-zsh-prompt
  
# 设置 agkozak-zsh-prompt 的配置
AGKOZAK_PROMPT_CHAR=( $ %# : )
AGKOZAK_LEFT_PROMPT_ONLY=1
AGKOZAK_PROMPT_DIRTRIM=20





# ====================
# 自定义配置
# ====================
zinit wait lucid  is-snippet for \
    "$HOME/.config/zsh/alias.zsh" \
    "$HOME/.config/zsh/config.zsh" \
    as"completion" \
        "$HOME/.config/zsh/zoxide_complete.zsh"


export PATH=$HOME/script/shell:$HOME/script/apple-script:$PATH

# 加载 asdf
. /usr/local/opt/asdf/libexec/asdf.sh
