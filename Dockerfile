FROM debian:jessie
MAINTAINER needo <needo@superhero.org>
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -q

# Install Dependencies
RUN apt-get install -qy mariadb-server

# Fix a Debianism of the mysql uid/gid
RUN usermod -u 27 mysql
RUN usermod -g 27 mysql

EXPOSE 3306

VOLUME /db

# Running things as root is bad.
ADD start.sh /start.sh
CMD ["/bin/bash", "/start.sh"]
