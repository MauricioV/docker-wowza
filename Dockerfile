FROM ubuntu:focal as builder

ENV WOWZA_VERSION=4.8.17+1 \
    WOWZA_DATA_DIR=/var/lib/wowza \
    WOWZA_LOG_DIR=/var/log/wowza

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y wget supervisor openjdk-11-jre expect nano mlocate openssh-server net-tools\
 && rm -rf /var/lib/apt/lists/*

COPY prepare.sh interaction.exp /app/
RUN /app/prepare.sh

COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

COPY hosts /etc/
COPY wms-server.jar /root/
COPY updateavailablejava_tag.class /root/
COPY updateavailable_tag.class /root/

EXPOSE 1935/tcp 8086/tcp 8087/tcp 8088/tcp
VOLUME ["${WOWZA_DATA_DIR}", "${WOWZA_LOG_DIR}"]
ENTRYPOINT ["/sbin/entrypoint.sh"]
