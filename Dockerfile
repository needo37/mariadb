FROM phusion/baseimage:0.9.16
ENV DEBIAN_FRONTEND noninteractive

# Set correct environment variables
ENV HOME /root
ENV TERM xterm
# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# Add mariadb.sh, firstrun.sh and my.cnf
ADD mariadb.sh /root/mariadb.sh
ADD firstrun.sh /etc/my_init.d/firstrun.sh

# Configure user nobody to match unRAID's settings
RUN \
usermod -u 99 nobody && \
usermod -g 100 nobody && \
usermod -d /home nobody && \
chown -R nobody:users /home && \

# mv startup file and make executable
mkdir -p /etc/service/mariadb && \
mkdir -p /db
mv /root/mariadb.sh /etc/service/mariadb/run && \
chmod +x /etc/service/mariadb/run && \
chmod +x /etc/my_init.d/firstrun.sh && \
    
# update apt
apt-get update -q && \

# Install Dependencies
apt-get install -qy mariadb-server && \
apt-get install -qy mysqltuner && \

# Tweak my.cnf
sed -i -e 's#\(bind-address.*=\).*#\1 0.0.0.0#g' /etc/mysql/my.cnf && \
sed -i -e 's#\(log_error.*=\).*#\1 /db/databases/mysql_safe.log#g' /etc/mysql/my.cnf && \
sed -i -e 's/\(user.*=\).*/\1 nobody/g' /etc/mysql/my.cnf && \
echo '[mysqld]' > /etc/mysql/conf.d/innodb_file_per_table.cnf && \
echo 'innodb_file_per_table' >> /etc/mysql/conf.d/innodb_file_per_table.cnf && \
cp /etc/mysql/my.cnf /root/my.cnf

EXPOSE 3306
