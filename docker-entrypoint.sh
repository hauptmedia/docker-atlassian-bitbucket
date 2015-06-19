#!/bin/sh

if [ -z "$STASH_HOME" ]; then
	echo Missing STASH_HOME env
	exit 1
fi

if [ -n "$CONNECTOR_PROXYNAME" ]; then
        xmlstarlet ed --inplace --delete "/Server/Service/Connector/@proxyName" $STASH_INSTALL_DIR/conf/server.xml
        xmlstarlet ed --inplace --insert "/Server/Service/Connector" --type attr -n proxyName -v $CONNECTOR_PROXYNAME $STASH_INSTALL_DIR/conf/server.xml
fi

if [ -n "$CONNECTOR_PROXYPORT" ]; then
        xmlstarlet ed --inplace --delete "/Server/Service/Connector/@proxyPort" $STASH_INSTALL_DIR/conf/server.xml
        xmlstarlet ed --inplace --insert "/Server/Service/Connector" --type attr -n proxyPort -v $CONNECTOR_PROXYPORT $STASH_INSTALL_DIR/conf/server.xml
fi

if [ -n "$CONNECTOR_SECURE" ]; then
        xmlstarlet ed --inplace --delete "/Server/Service/Connector/@secure" $STASH_INSTALL_DIR/conf/server.xml
        xmlstarlet ed --inplace --insert "/Server/Service/Connector" --type attr -n secure -v $CONNECTOR_SECURE $STASH_INSTALL_DIR/conf/server.xml
fi

if [ -n "$CONNECTOR_SCHEME" ]; then
        xmlstarlet ed --inplace --delete "/Server/Service/Connector/@scheme" $STASH_INSTALL_DIR/conf/server.xml
        xmlstarlet ed --inplace --insert "/Server/Service/Connector" --type attr -n scheme -v $CONNECTOR_SCHEME $STASH_INSTALL_DIR/conf/server.xml
fi

if [ -n "$CONTEXT_PATH" ]; then
        if [ "$CONTEXT_PATH" = "/" ]; then
                CONTEXT_PATH=""
        fi

        xmlstarlet ed --inplace --delete "/Server/Service/Engine/Host/Context/@path" $STASH_INSTALL_DIR/conf/server.xml
        xmlstarlet ed --inplace --insert "/Server/Service/Engine/Host/Context" --type attr -n path -v "$CONTEXT_PATH" $STASH_INSTALL_DIR/conf/server.xml
fi

exec "$@"

