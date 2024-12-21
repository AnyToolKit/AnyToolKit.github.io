pkg install -y mariadb			
cd $PREFIX/etc/
mkdir -p my.cnf.d
mysql_install_db				# 初始化数据库
