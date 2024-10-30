apt install -y openssh-server
if [ -f ${1} ]; then
	cp $1 $1_backup	
else
	echo "$1 not exists!"
fi

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
	echo do
	echo $LINE >> $FILE
}
# CONFIG="/etc/ssh/sshd_config"
CONFIG="./sshd_config"
cp $CONFIG $CONFIG.old

string_1="Port 22"
string_2="PermitRootLogin"
string_3="PubkeyAuthentication"
string_4="AuthorizedKeysFile"
string_5="PasswordAuthentication yes"

string_6="Port 22"
string_7="PermitRootLogin yes"
string_8="PubkeyAuthentication yes"
string_9="AuthorizedKeysFile      .ssh/authorized_keys .ssh/authorized_keys2"
string_10="PasswordAuthentication yes"

## 配置过程
delete_line_with_special_word   $CONFIG  "$string_1"
append_line_into_file           $CONFIG  "$string_1"
delete_line_with_special_word   $CONFIG  "$string_2"
append_line_into_file           $CONFIG  "$string_7"
delete_line_with_special_word   $CONFIG  "$string_3"
append_line_into_file           $CONFIG  "$string_8"
delete_line_with_special_word   $CONFIG  "$string_4"
append_line_into_file           $CONFIG  "$string_9"
delete_line_with_special_word   $CONFIG  "$string_5"
append_line_into_file           $CONFIG  "$string_10"
