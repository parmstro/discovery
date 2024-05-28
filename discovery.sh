#!/bin/bash

export DISCOVERY_PGDATA=~/.discovery/pgsql/data
export DISCOVERY_DATA=~/.discovery/data
export DISCOVERY_LOG=~/.discovery/log
export DISCOVERY_SSHKEYS=~/.discovery/sshkeys
export DISCOVERY_PASS=notsecret1234

mkdir -p $DISCOVERY_PGDATA
mkdir -p $DISCOVERY_DATA
mkdir -p $DISCOVERY_LOG
mkdir -p $DISCOVERY_SSHKEYS

podman run --name dsc-db \
  --pod new:discovery-pod \
  --publish 9443:443 \
  --restart on-failure \
  -e POSTGRESQL_USER=dsc \
  -e POSTGRESQL_PASSWORD=$DISCOVERY_PASS \
  -e POSTGRESQL_DATABASE=dsc-db \
  -v dsc-data:$DISCOVERY_PGDATA \
  -d registry.redhat.io/rhel9/postgresql-15:latest
  
podman run \
  --name discovery \
  --restart on-failure \
  --pod discovery-pod \
  -e DJANGO_DEBUG=False \
  -e NETWORK_CONNECT_JOB_TIMEOUT=60 \
  -e NETWORK_INSPECT_JOB_TIMEOUT=600 \
  -e PRODUCTION=True \
  -e QPC_DBMS_HOST=localhost \
  -e QPC_DBMS_PASSWORD=$DISCOVERY_PASS \
  -e QPC_DBMS_USER=dsc \
  -e QPC_DBMS_DATABASE=dsc-db \
  -e QPC_SERVER_PASSWORD=$DISCOVERY_PASS \
  -e QPC_SERVER_TIMEOUT=120 \
  -e QPC_SERVER_USERNAME=admin \
  -e QPC_SERVER_USER_EMAIL=admin@example.com \
  -v $DISCOVERY_DATA/:/var/data:z \
  -v $DISCOVERY_LOG/:/var/log:z \
  -v $DISCOVERY_SSHKEYS/:/sshkeys:z \
  -d registry.redhat.io/discovery/discovery-server-rhel9:latest
  
  
  
