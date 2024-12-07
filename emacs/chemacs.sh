#删除带有指定关键字的行
delete_line_with_special_word () {
    if [[ $# -lt 2 ]]; then
        return
    fi
    FILE=$1
    WORD=$2

    sed -i "/${WORD}/d" ${FILE}
}
#文件内容追加
append_line_into_file () {
    if [[ $# -lt 2 ]]; then
        return
    fi
    FILE=$1
    LINE=$2
    echo $LINE >> $FILE
}

CONFIG_1="$HOME/.bashrc"
CONFIG_2="$HOME/.bash_profile"
string_1="emacs=\"emacs --with-profile"

case $1 in
    config)
        if [ $# -lt 2 ]; then
            echo "Usage："
            echo "$0 config args"
        else

            if [ ! -f "$CONFIG_1" ]; then
                echo ""
            else
                cp $CONFIG_1 $CONFIG_1.old
                delete_line_with_special_word   $CONFIG_1 "$string_1"
                append_line_into_file           $CONFIG_1  "alias emacs=\"emacs --with-profile $2\""
                echo "已配置emacs默认配置文件"
                echo -e "\n接下来需要运行source命令使配置生效：\nsource $CONFIG_1"
            fi

            if [ ! -f "$CONFIG_2" ]; then
                echo ""
            else
                cp $CONFIG_2 $CONFIG_2.old
                delete_line_with_special_word   $CONFIG_2 "$string_1"
            fi
        fi
        ;;
    delete)
        if [ ! -f "$CONFIG_1" ]; then
            echo ""
        else
            cp $CONFIG_1 $CONFIG_1.old
            delete_line_with_special_word   $CONFIG_1 "$string_1"
            echo -e "\n接下来需要运行source命令使配置生效：\nsource $CONFIG_1"
        fi

        if [ ! -f "$CONFIG_2" ]; then
            echo ""
        else
            cp $CONFIG_2 $CONFIG_2.old
            delete_line_with_special_word   $CONFIG_2 "$string_1"
        fi
        ;;
    *)
        echo "Usage："
        echo "$0 config|delete"
esac
