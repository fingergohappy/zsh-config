# 获取当前脚本的目录
script_dir=$(dirname "$0")
# 遍历目录下的所有 .zsh 文件并 source
for file in "$script_dir"/*.zsh; do
    if [ "$file" != "$script_dir/init.zsh" ] && [ -f "$file" ]; then
        source "$file"
    fi
done


export PATH=$HOME/script/shell:$HOME/script/apple-script:$PATH
