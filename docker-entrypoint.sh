#!/bin/sh

if [ -z "$STASH_HOME" ]; then
	echo Missing STASH_HOME env
	exit 1
fi

if [ -z "$MYSQL_NAME" ]; then 
	echo Missing docker linked container with alias mysql
	exit 1
fi

if [ -z "$MYSQL_ENV_MYSQL_STASH_USER" ]; then
	echo Missing MYSQL_STASH_USER environment variable from docker container named mysql
	exit 1
fi

if [ -z "$MYSQL_ENV_MYSQL_STASH_PASSWORD" ]; then
	echo Missing MYSQL_STASH_PASSWORD environment variable from docker container named mysql
	exit 1
fi

if [ -z "$MYSQL_ENV_MYSQL_STASH_DATABASE" ]; then
	echo Missing MYSQL_STASH_DATABASE environment variable from docker container named mysql
	exit 1
fi


cat <<EOF >$STASH_HOME/shared/stash-config.properties
jdbc.driver=com.mysql.jdbc.Driver
jdbc.url=jdbc:mysql://$MYSQL_PORT_3306_TCP_ADDR:$MYSQL_PORT_3306_TCP_PORT/$MYSQL_ENV_MYSQL_STASH_DATABASE?autoReconnect=true&characterEncoding=utf8&useUnicode=true&sessionVariables=storage_engine%3DInnoDB
jdbc.user=${MYSQL_ENV_MYSQL_STASH_USER}
jdbc.password=${MYSQL_ENV_MYSQL_STASH_PASSWORD}
EOF

exec "$@"

