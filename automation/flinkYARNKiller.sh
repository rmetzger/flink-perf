#!/bin/bash

#source hadoop_helpers.sh
#HADOOP_PORTS=(8088 50010 50020 50070 50090)
#cd ${HADOOP_INSTALL_DIR}
# Test for sshability to workers.

# do a local pkill
pkill -f org.apache.flink.yarn

for NODE in `cat flink-conf/slaves` ; do
  echo "on node $NODE"
  sudo -u hadoop ssh "$NODE" "hostname && pkill -f org.apache.flink.yarn && exit 0"
done
