#!/bin/bash

. ./configDefaults.sh
. ./utils.sh

HOSTLIST=flink-conf/slaves

echo "Copying local file $1 to $2 on all nodes."

GOON=true
while $GOON
do
    read line || GOON=false
    if [ -n "$line" ]; then
        HOST=$line
        echo "[$HOST]"
        #ssh -n $HOST -- $@
	scp $1 $HOST:$2
    fi
done < "$HOSTLIST"


