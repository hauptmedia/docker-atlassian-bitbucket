FROM		hauptmedia/java:oracle-java8
MAINTAINER	Julian Haupt <julian.haupt@hauptmedia.de>

ENV		BITBUCKET_VERSION 4.6.1
ENV		MYSQL_CONNECTOR_J_VERSION 5.1.34

ENV		BITBUCKET_HOME     	/var/atlassian/application-data/bitbucket
ENV		BITBUCKET_INSTALL_DIR	/opt/atlassian/bitbucket

ENV		RUN_USER            daemon
ENV		RUN_GROUP           daemon

ENV             DEBIAN_FRONTEND noninteractive

# install needed debian packages & clean up
RUN             apt-get update && \
                apt-get install -y --no-install-recommends curl tar xmlstarlet ca-certificates git && \
                apt-get clean autoclean && \
                apt-get autoremove --yes && \
                rm -rf /var/lib/{apt,dpkg,cache,log}/

# download and extract bitbucket 
RUN             mkdir -p ${BITBUCKET_INSTALL_DIR} && \
                curl -L --silent http://www.atlassian.com/software/stash/downloads/binary/atlassian-bitbucket-${BITBUCKET_VERSION}.tar.gz | tar -xz --strip=1 -C ${BITBUCKET_INSTALL_DIR} && \
                chown -R ${RUN_USER}:${RUN_GROUP} ${BITBUCKET_INSTALL_DIR}

# integrate mysql connector j library
RUN             curl -L --silent http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-${MYSQL_CONNECTOR_J_VERSION}.tar.gz | tar -xz --strip=1 -C /tmp && \
                cp /tmp/mysql-connector-java-${MYSQL_CONNECTOR_J_VERSION}-bin.jar ${BITBUCKET_INSTALL_DIR}/lib && \
                rm -rf /tmp/*

# add docker-entrypoint.sh script
COPY            docker-entrypoint.sh ${BITBUCKET_INSTALL_DIR}/bin/

USER		${RUN_USER}:${RUN_GROUP}	

# HTTP Port
EXPOSE		7990

# SSH Port
EXPOSE		7999 

VOLUME		["${BITBUCKET_INSTALL_DIR}"]

WORKDIR		${BITBUCKET_INSTALL_DIR}

ENTRYPOINT	["bin/docker-entrypoint.sh"]
CMD		["bin/start-bitbucket.sh", "-fg"]
