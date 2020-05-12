#!/bin/bash

REDIS_CONF_DIR=/etc/redis
REDIS_CONF=${REDIS_CONF_DIR}/redis.conf
REDIS_CONF_TMPL=${REDIS_CONF}.tmpl
SENTINEL_CONF=${REDIS_CONF_DIR}/sentinel.conf
SENTINEL_CONF_TMPL=${SENTINEL_CONF}.tmpl

cp -f ${REDIS_CONF_TMPL} ${REDIS_CONF}
cp -f ${SENTINEL_CONF_TMPL} ${SENTINEL_CONF}

if [ "${REDIS_MASTER_HOST:=localhost}" == "localhost" ]; then
  sed '/slaveof/d' -i ${REDIS_CONF}
else
  sed 's,REDIS_MASTER_HOST,'${REDIS_MASTER_HOST}',' -i ${REDIS_CONF}
fi

sed 's,REDIS_MASTER_HOST,'${REDIS_MASTER_HOST}',' -i ${SENTINEL_CONF}

service redis-server start
service redis-sentinel start

exec tail -f /var/log/redis/*.log
