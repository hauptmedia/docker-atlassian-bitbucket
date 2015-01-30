FROM		hauptmedia/java:oracle-java7
MAINTAINER	Julian Haupt <julian.haupt@hauptmedia.de>

ENV		STASH_VERSION 3.6.1
ENV		MYSQL_CONNECTOR_J_VERSION 5.1.34

ENV		STASH_HOME     		/var/atlassian/application-data/stash
ENV		STASH_INSTALL_DIR	/opt/atlassian/stash

ENV		RUN_USER            daemon
ENV		RUN_GROUP           daemon

ADD		http://www.atlassian.com/software/stash/downloads/binary/atlassian-stash-${STASH_VERSION}.tar.gz /tmp/
ADD		http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-${MYSQL_CONNECTOR_J_VERSION}.tar.gz /tmp/
ADD		docker-entrypoint.sh /tmp/

RUN		apt-get update -qq && \
    		apt-get install -y --no-install-recommends git && \
		apt-get clean autoclean && \
		apt-get autoremove --yes && \
		rm -rf /var/lib/{apt,dpkg,cache,log}/ && \
		mkdir -p ${STASH_INSTALL_DIR} && \
		tar -xzf /tmp/atlassian-stash-${STASH_VERSION}.tar.gz --strip=1 -C ${STASH_INSTALL_DIR} && \
		tar -xzf /tmp/mysql-connector-java-${MYSQL_CONNECTOR_J_VERSION}.tar.gz --strip=1 -C /tmp/ && \
		cp /tmp/mysql-connector-java-${MYSQL_CONNECTOR_J_VERSION}-bin.jar ${STASH_INSTALL_DIR}/lib && \
		mv /tmp/docker-entrypoint.sh ${STASH_INSTALL_DIR}/bin && \
		chown -R ${RUN_USER}:${RUN_GROUP} ${STASH_INSTALL_DIR} && \
		rm -rf /tmp/*

USER		${RUN_USER}:${RUN_GROUP}	

# HTTP Port
EXPOSE		7990

# SSH Port
EXPOSE		7999 

VOLUME		["${STASH_INSTALL_DIR}"]

WORKDIR		${STASH_INSTALL_DIR}

ENTRYPOINT	["bin/docker-entrypoint.sh"]
CMD		["bin/start-stash.sh", "-fg"]
