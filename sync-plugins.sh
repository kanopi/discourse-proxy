#!/bin/bash

PLUGIN_HOME=/bitnami/discourse/plugins/
PLUGIN_MOUNT=/bitnami/discourse/local-plugins/
#docker-compose exec discourse sh -c "find ${PLUGIN_HOME} -type l -exec rm {} \;"
docker-compose exec discourse sh -c "cp -R ${PLUGIN_MOUNT}/${1} ${PLUGIN_HOME} || true"
docker-compose exec discourse sh -c "chown -R discourse:discourse ${PLUGIN_HOME}"
echo "The Discourse Container will need to be rebuilt."
docker-comopse up --force-recreate -d discourse