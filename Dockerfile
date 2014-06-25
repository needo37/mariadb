FROM phusion/baseimage:0.9.11
MAINTAINER needo <needo@superhero.org>
ENV DEBIAN_FRONTEND noninteractive

# Set correct environment variables
ENV HOME /root

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

RUN apt-get update -q

# Install Dependencies
RUN apt-get install -qy mariadb-server

# Fix a Debianism of the mysql uid/gid
RUN usermod -u 27 mysql
RUN usermod -g 27 mysql

EXPOSE 3306

VOLUME /db

# Add firstrun.sh to init. This will create the database if it doesn't exist
RUN mkdir -p /etc/my_init.d
ADD firstrun.sh /etc/my_init.d/firstrun.sh
RUN chmod +x /etc/my_init.d/firstrun.sh

# Add mariadb to runit
RUN mkdir /etc/service/mariadb
ADD mariadb.sh /etc/service/mariadb/run
RUN chmod +x /etc/service/mariadb/run
