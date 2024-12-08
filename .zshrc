# ====================
# 基础设置
# ====================
source /Users/fingerfrings/script/shell/toggle-proxy.sh > /dev/null

# 初始化补全系统
autoload -Uz compinit
compinit

# 设置基础补全选项
setopt COMPLETE_IN_WORD
setopt AUTO_LIST
setopt AUTO_MENU
setopt ALWAYS_TO_END

# ====================
# Zinit 初始化
# ====================
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

# ====================
# 插件配置
# ====================
# 1. Zinit Annexes
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

# 2. Pure Theme
# 简单的提示符配置
setopt PROMPT_SUBST
PROMPT='%F{blue}%~%f %F{magenta}$%f '

# 3. FZF
zinit ice from"gh-r" as"command"
zinit light junegunn/fzf

zinit ice wait lucid multisrc"shell/{key-bindings,completion}.zsh" id-as"junegunn/fzf_completions" \
    pick"/dev/null"
zinit light junegunn/fzf

# 4. Zoxide
zinit ice from"gh-r" as"program" \
    atclone"./zoxide init zsh --cmd cd --hook pwd > init.zsh" \
    atpull"%atclone" src"init.zsh" \
    nocompile'!' \
    atload'eval "$(zoxide init zsh --cmd cd --hook pwd)"'
zinit light ajeetdsouza/zoxide

# 5. Other plugins
zinit wait lucid light-mode for \
    blockf atpull'zinit creinstall -q .' \
        zsh-users/zsh-completions \
    atinit"zicompinit; zicdreplay" \
        zdharma-continuum/fast-syntax-highlighting \
    atload"_zsh_autosuggest_start" \
        zsh-users/zsh-autosuggestions

# 6. FZF-tab (需要在语法高亮之前加载)
zinit ice lucid wait'0'
zinit light Aloxaf/fzf-tab

# ====================
# 补全系统配置
# ====================
# 1. 基础补全配置
zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*:cd:*' tag-order local-directories named-directories directory-stack path-directories
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$HOME/.zcompcache"

# 2. SSH 补全配置
function _ssh_hosts() {
    local -a config_hosts
    config_hosts=(${${${(@M)${(f)"$(cat ~/.ssh/config 2>/dev/null)"}:#Host *}#Host }:#*[*?]*})
    _wanted hosts expl 'remote host name' compadd -M 'm:{a-zA-Z}={A-Za-z}' "$@" $config_hosts
}

zstyle ':completion:*:*:ssh:*' tag-order 'hosts:-config:SSH 配置主机' 'hosts:-host:host'
zstyle ':completion:*:*:ssh:*' group-order 'hosts:-config' 'hosts:-host'
zstyle ':completion:*:hosts-config' command _ssh_hosts
zstyle ':completion:*:*:ssh:*' completer _ssh_hosts _complete

# ====================
# 自定义配置
# ====================
# 加载自定义配置
if [[ -f "$HOME/.config/zsh/init.zsh" ]]; then
   source "$HOME/.config/zsh/init.zsh"
fi

# 加载 asdf
. /usr/local/opt/asdf/libexec/asdf.sh
