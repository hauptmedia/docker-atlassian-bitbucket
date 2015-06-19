FROM		hauptmedia/java:oracle-java8
MAINTAINER	Julian Haupt <julian.haupt@hauptmedia.de>

ENV		STASH_VERSION 3.10.0
ENV		MYSQL_CONNECTOR_J_VERSION 5.1.34

ENV		STASH_HOME     		/var/atlassian/application-data/stash
ENV		STASH_INSTALL_DIR	/opt/atlassian/stash

ENV		RUN_USER            daemon
ENV		RUN_GROUP           daemon

ENV             DEBIAN_FRONTEND noninteractive

# install needed debian packages & clean up
RUN             apt-get update && \
                apt-get install -y --no-install-recommends curl tar xmlstarlet ca-certificates git && \
                apt-get clean autoclean && \
                apt-get autoremove --yes && \
                rm -rf /var/lib/{apt,dpkg,cache,log}/

# download and extract stash
RUN             mkdir -p ${STASH_INSTALL_DIR} && \
                curl -L --silent http://www.atlassian.com/software/stash/downloads/binary/atlassian-stash-${STASH_VERSION}.tar.gz | tar -xz --strip=1 -C ${STASH_INSTALL_DIR} && \
                chown -R ${RUN_USER}:${RUN_GROUP} ${STASH_INSTALL_DIR}

# integrate mysql connector j library
RUN             curl -L --silent http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-${MYSQL_CONNECTOR_J_VERSION}.tar.gz | tar -xz --strip=1 -C /tmp && \
                cp /tmp/mysql-connector-java-${MYSQL_CONNECTOR_J_VERSION}-bin.jar ${STASH_INSTALL_DIR}/lib && \
                rm -rf /tmp/*

# add docker-entrypoint.sh script
COPY            docker-entrypoint.sh ${STASH_INSTALL_DIR}/bin/

USER		${RUN_USER}:${RUN_GROUP}	

# HTTP Port
EXPOSE		7990

# SSH Port
EXPOSE		7999 

VOLUME		["${STASH_INSTALL_DIR}"]

WORKDIR		${STASH_INSTALL_DIR}

ENTRYPOINT	["bin/docker-entrypoint.sh"]
CMD		["bin/start-stash.sh", "-fg"]
