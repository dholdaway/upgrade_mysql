#/usr/bin/bash

echo "thank you for Choosing to update your mysql instance to 5.6. I am now going to get the file for you"
if [ ! -f mysql-5.6.19-linux-glibc2.5-x86_64.tar.gz ]; 
		then
				wget "https://downloads.mariadb.com/archives/mysql-5.6/mysql-5.6.19-linux-glibc2.5-x86_64.tar.gz" --no-check-certificate
			fi
			echo ""
			echo "###############"
			echo "# Removing previous instance"
			echo "###############"

			sudo apt-get --assume-yes remove mysql-server-5.5
			sudo apt-get --assume-yes autoremove

			echo ""
			echo "###############"
			echo "# installing libaio"
			echo "###############"

			sudo apt-get --assume-yes install libaio-dev

			echo ""
			echo "###############"
			echo "# extract mysql 5.6"
			echo "###############"

			tar -xzf mysql-5.6.19-linux-glibc2.5-x86_64.tar.gz 
			sudo mv mysql-5.6.19-linux-glibc2.5-x86_64 /usr/local/
			cd /usr/local && sudo ln -s mysql-5.6.19-linux-glibc2.5-x86_64 mysql
			cd mysql
			sudo chown -R mysql:mysql .

			echo ""
			echo "###############"
			echo "# Edit environment file"
			echo "###############"
			sudo sed -i 's/"$/:\/usr\/local\/mysql\/bin"/' /etc/environment

			export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/mysql/bin"

			echo ""
			echo "###############"
			echo "# Adapt configuration file"
			echo "###############"

			sudo sed -i 's/basedir		= \/usr/basedir		=\/usr\/local\/mysql/' /etc/mysql/my.cnf
			sudo sed -i 's/lc-messages-dir	= \/usr\/share\/mysql/lc-messages-dir = \/usr\/local\/mysql\/share\nlc-messages		=en_GB\n/' /etc/mysql/my.cnf
			sudo sed -i 's/myisam-recover	/myisam-recover-options	/' /etc/mysql/my.cnf
			sudo sed -i 's/key-buffer   /key-buffer-size /' /etc/mysql/my.cnf

			echo ""
			echo "###############"
			echo "# running install script"
			echo "###############"

			sudo ./scripts/mysql_install_db --user=mysql --defaults-file=/etc/mysql/my.cnf
			sudo chown -R root .


			echo ""
			echo "###############"
			echo "# Starting mysql"
			echo "###############"

			sudo cp /usr/local/mysql/support-files/mysql.server /etc/init.d/mysql
			sudo update-rc.d mysql defaults
			sudo bin/mysqld_safe --user=mysql &


			echo ""
			echo "###############"
			echo "# running upgrade script"
			echo "###############"

			sudo mysql_upgrade -u root -pcodilink


			echo ""
			echo "###############"
			echo "# You should now have a fully operational 5.6 installation. Enjoy. Lots of love"
			echo "###############"
