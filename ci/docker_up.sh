#!/bin/bash

# Launches a dockerized kafka cluster configured for testing with Helmsman
#
# This script attempts to auto-detect the ip address of an active network
# interface using `./ci/active_ifaces.sh`.  You can override this by
# supplying the name of an interface through the IP_IFACE env var - e.g.,
#
# IP_IFACE=eth0 ./ci/docker_up.sh
#
# This script should be run from the project root

set -e

# Kafka needs to know our ip address so that it can advertise valid
# connnection details
if [ -z ${IP_IFACE} ]
then
  echo Detecting active network interface
  IP_IFACE=$(ifconfig | ./ci/active_ifaces.sh | head -n 1 | cut -d ':' -f1)
fi

export DOCKER_IP=$(ifconfig ${IP_IFACE} | grep 'inet ' | awk '{print $2}' | cut -d ':' -f2)

# for debugging purposes
echo Detected active network interface ${IP_IFACE} with ip ${DOCKER_IP}

for i in 1 2 3
do
  port=$(expr 9092 + ${i} - 1)
  mkdir -p tmp/kafka${i}
  target=tmp/kafka${i}/server.properties.in
  cp ./ci/server.properties ${target}
  # configure broker and port
  sed -i.bak "s/@broker_id@/${i}/g" ${target}
  sed -i.bak "s/@port@/${port}/g" ${target}
  # point at zookeeper in docker
  sed -i.bak "s/localhost:2181/zookeeper:2181/" ${target}
  # delete the existing listeners line
  sed -i.bak "/^listeners=/d" ${target}
  # add an advertised.listeners and listeners together at the end
  echo "advertised.listeners=PLAINTEXT://${DOCKER_IP}:${port}" >> ${target}
  echo "listeners=PLAINTEXT://0.0.0.0:${port}" >> ${target}
done

docker-compose up -d

# create topics needed for testing
docker-compose exec kafka3 /bin/bash -c "KAFKA_ZOOKEEPER_CONNECT=zookeeper:2181 KAFKA_PORT=9094 KAFKA_CREATE_TOPICS=consumer_group_implementation_test:4:2 create-topics.sh"
