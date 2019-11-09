FROM debian:9
MAINTAINER Joseph Mbengue <mbenguejoseph@gmail.com>


ENV DB_USER=root \
    DB_PASS=password \
    DB_ADDRESS=127.0.0.1 \
    SPINE_VERSION=latest \
    CACTI_COMMIT_HASH=dfba135dbd84f93f30704da824fa52a7df272b65 \
    TIMEZONE=UTC

RUN apt-get update -yq \
    && apt-get install rrdtool net-snmp net-snmp-devel net-snmp-utils mariadb-devel cronie -yq \
    && git clone https://github.com/Cacti/cacti.git /cacti/ -yq \
    && cd cacti -yq \
    && git checkout ${CACTI_COMMIT_HASH} -yq \
    && curl -o /tmp/cacti-spine.tgz http://www.cacti.net/downloads/spine/cacti-spine-${SPINE_VERSION}.tar.gz -yq \
    && mkdir -p /tmp/spine -yq \
    && tar zxvf /tmp/cacti-spine.tgz -C /tmp/spine --strip-components=1 -yq \
    && rm -f /tmp/cacti-spine.tgz -yq \
    && cd /tmp/spine/ -yq \
    && ./configure -yq \
    && make -yq \
    && make install -yq \
    && rm -rf /tmp/spine -yq \
    && apt-get remove gcc mariadb-devel net-snmp-devel -yq \
    && apt-get clean -y

COPY container-files /

EXPOSE 80 81 443
