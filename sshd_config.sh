apt install -y openssh-server
if [ -f ${1} ]; then
	sudo cp $1 $1_backup	
else
	echo "$1 not exists!"
fi

string_1="Port 22"
if grep -q "${string_1}" "$1"; then
    # echo "字符串 "${string_1}" 存在于文件 "${1}" 中。"
	# sed -i "/${string_1}/s/^/#/" $1
	sed -i "/${string_1}/s/^/#/; /$string_1/a $string_1" $1 
else
    echo "字符串 "${string_1}" 不存在于文件 "${1}" 中。"
fi

string_2="PermitRootLogin"
if grep -q "${string_2}" "$1"; then
    # echo "字符串 "${string_2}" 存在于文件 "${1}" 中。"
	# sed -i "/${string_2}/s/^/#/" $1
	sed -i "/${string_2}/s/^/#/; /$string_2/a $string_2 yes" $1
else
    echo "字符串 "${string_2}" 不存在于文件 "${1}" 中。"
fi

string_3="PubkeyAuthentication"
if grep -q "${string_3}" "$1"; then
    # echo "字符串 "${string_3}" 存在于文件 "${1}" 中。"
	# sed -i "/${string_3}/s/^/#/" $1
	sed -i "/${string_3}/s/^/#/; /$string_3/a $string_3 yes" $1
else
    echo "字符串 "${string_3}" 不存在于文件 "${1}" 中。"	
fi

string_4="AuthorizedKeysFile"
if grep -q "${string_4}" "$1"; then
    # echo "字符串 "${string_4}" 存在于文件 "${1}" 中。"
	# sed -i "/${string_4}/s/^/#/" $1
	sed -i "/${string_4}/s/^/#/; /$string_4/a $string_4      .ssh/authorized_keys .ssh/authorized_keys2" $1
else
    echo "字符串 "${string_4}" 不存在于文件 "${1}" 中。"
fi

string_5="PasswordAuthentication yes"
if grep -q "${string_5}" "$1"; then
    # echo "字符串 "${string_5}" 存在于文件 "${1}" 中。"
	# sed -i "/${string_5}/s/^/#/" $1
	sed -i "/${string_5}/s/^/#/; /$string_5/a $string_5" $1
else
    echo "字符串 "${string_5}" 不存在于文件 "${1}" 中。"
fi
