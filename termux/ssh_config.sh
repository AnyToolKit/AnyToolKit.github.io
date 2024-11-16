# pkg update
# pkg install -y openssh-server

# 获取当前用户的家目录
home_dir="$HOME"
ssh_dir="$home_dir/.ssh"
private_key="$ssh_dir/id_rsa"
public_key="$ssh_dir/id_rsa.pub"

# 判断 .ssh 目录是否存在
if [ ! -d "$ssh_dir" ]; then
	# 检查公钥和私钥是否存在
	if [ ! -f "$private_key" ] || [ ! -f "$public_key" ]; then
	    echo "SSH keys not found. Generating new SSH keys..."
	    ssh-keygen -t rsa -b 4096 -f "$private_key" -N ""  # 生成新的 SSH 密钥，空密码
	    echo "SSH keys have been generated."
	else
	    echo "SSH keys already exist. Skipping key generation."
	fi
fi

