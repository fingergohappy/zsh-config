_zoxide_zsh_tab_completion() {
    (( $+compstate )) && compstate[insert]=menu
    local keyword="${words:2}"
    local completions=(${(@f)"$(zoxide query -l "$keyword")"})


    if [[ ${#completions[@]} == 0 ]]; then
        _files -/
    else
        compadd -U -V z "${(@)completions}"
    fi
}

if [ "${+functions[compdef]}" -ne 0 ]; then
    compdef _zoxide_zsh_tab_completion z 2> /dev/null
fi