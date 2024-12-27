# 运行环境：Cygwin
# 编码：65001
# 设置编码方式：在Cygwin的家目录下的.bash_profile中添加语句：cmd /c chcp 65001
# 依赖环境：Cygwin安装expect
# 运行示例：expect thc.sh root@segfault.net segfault

#!/usr/bin/expect

# 检查参数数量
# if {$argc < 1} {
#        puts "Usage: $argv0 <target_host>"
#        exit 1
#    }

set thc_host "root@segfault.net"
set thc_passwd "root@segfault.net"
# set target_host [lindex $argv 0]
# set passwd [lindex $argv 1]

# spawn ssh "$target_host"
spawn ssh "$thc_host"

expect {
	"yes/no" {
		send "yes\r"
		exp_continue
	}
	"password" {
		# send "$passwd\r"
		send "$thc_passwd\r"
		exp_continue
	}
}

while {1} {
		  expect {				 
			  "Press" {
				  send "\n"
				  exp_continue
			  }
			  "y/N" {
				  send "\n"
				  exp_continue
			  }
			  "root" {
				  break;
			  }
		  }		  
	  }

	  interact
