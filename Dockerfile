FROM ubuntu:18.04

ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8 DEBIAN_FRONTEND=noninteractive

RUN echo "#!/bin/sh\nexit 0" > /usr/sbin/policy-rc.d && \
    apt-get -y update && \
    apt-get -yq install wget apt-transport-https locales && \
    locale-gen en_US.UTF-8 && \
    apt-get -yq install \
        redis-server \
        redis-sentinel && \
    service redis-server stop && \
    service redis-sentinel stop && \
    rm -rf /var/lib/apt/lists/*

COPY config/* /etc/redis/

EXPOSE 6379 26379

VOLUME /var/log/redis /var/lib/redis

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]
