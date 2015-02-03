FROM phusion/baseimage:0.9.16
ENV DEBIAN_FRONTEND noninteractive

# Set correct environment variables
ENV HOME /root
ENV TERM xterm
# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# Add mariadb.sh and my.cnf to /root
ADD mariadb.sh /root/mariadb.sh
ADD my.cnf /root/my.cnf

# Configure user nobody to match unRAID's settings
RUN \
usermod -u 99 nobody && \
usermod -g 100 nobody && \
usermod -d /home nobody && \
chown -R nobody:users /home && \

# mv startup file and make executable
mkdir -p /etc/service/mariadb && \
mv /root/mariadb.sh /etc/service/mariadb/run && \
chmod +x /etc/service/mariadb/run && \

    
# update apt
apt-get update -q && \

# Install Dependencies
apt-get install -qy mariadb-server && \
apt-get install -qy mysqltuner && \


# InnoDB engine to use 1 file per table, vs everything in ibdata.
echo '[mysqld]' > /etc/mysql/conf.d/innodb_file_per_table.cnf && \
echo 'innodb_file_per_table' >> /etc/mysql/conf.d/innodb_file_per_table.cnf


EXPOSE 3306
