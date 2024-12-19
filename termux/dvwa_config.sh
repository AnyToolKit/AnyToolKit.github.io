pkg install -y mariadb
cd $PREFIX/etc/
mkdir -p my.cnf.d
mysql_install_db
