FROM debian:9
MAINTAINER Joseph Mbengue <mbenguejoseph@gmail.com>


ENV \
    DB_NAME=cacti \
    DB_USER=cactiuser \
    DB_PASS=cactipassword \
    DB_HOST=localhost \
    DB_PORT=3306 \
    RDB_NAME=cacti \
    RDB_USER=cactiuser \
    RDB_PASS=cactipassword \
    RDB_HOST=localhost \
    RDB_PORT=3306 \
    BACKUP_RETENTION=7 \
    BACKUP_TIME=0 \
    SNMP_COMMUNITY=public \
    REMOTE_POLLER=0 \
    INITIALIZE_DB=0 \
    INITIALIZE_INFLUX=0 \
    TZ=UTC \
    PHP_MEMORY_LIMIT=800M \
    PHP_MAX_EXECUTION_TIME=60

RUN apt-get update -yq \
    && apt-get install rrdtool snmp snmpd libsnmp-dev libmariadb-dev cron -yq \
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
    && apt-get remove gcc libmariadb-dev -yq \
    && apt-get clean -y

COPY container-files /

EXPOSE 80 81 443
