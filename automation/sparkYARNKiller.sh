#!/bin/bash

#source hadoop_helpers.sh
#HADOOP_PORTS=(8088 50010 50020 50070 50090)
#cd ${HADOOP_INSTALL_DIR}
# Test for sshability to workers.
for NODE in `cat flink-conf/slaves` ; do
  echo "on node $NODE"
  sudo -u hadoop ssh "$NODE" "hostname && pkill -f CoarseGrainedExecutorBackend && exit 0"
done
