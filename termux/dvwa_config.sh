pkg install -y mariadb			
cd $PREFIX/etc/
mkdir -p my.cnf.d
mysql_install_db				# 初始化数据库
nohup mysqld &					# 启动 MySQL 服务
# ps aux | grep -v "grep" | grep "mysql" | awk '{print $2}' | xargs kill -9 # 关闭数据库
