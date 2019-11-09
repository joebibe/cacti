FROM centos:7
MAINTAINER Joseph Mbengue (mbenguejoseph@gmail.com)
ADD . /go/src/cacti-app

## --- CACTI ---
RUN \
    rpm --rebuilddb && yum clean all && \
    yum update -y && \
    yum install -y \
        rrdtool net-snmp net-snmp-utils cronie php-ldap php-devel mysql php \
        ntp bison php-cli php-mysql php-common php-mbstring php-snmp curl \
        php-gd openssl openldap mod_ssl php-pear net-snmp-libs php-pdo \
        autoconf automake gcc gzip help2man libtool make net-snmp-devel \
        m4 libmysqlclient-devel libmysqlclient openssl-devel dos2unix wget \
        sendmail mariadb-devel which && \
    yum clean all

## --- CRON ---
# Fix cron issues - https://github.com/CentOS/CentOS-Dockerfiles/issues/31
RUN sed -i '/session required pam_loginuid.so/d' /etc/pam.d/crond

## --- SCRIPTS ---
COPY cmd.php /cmd.php
RUN chmod +x /cmd.php
