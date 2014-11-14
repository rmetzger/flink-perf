#!/bin/bash


echo "Updating configuration. Remember to restart"

. ./configDefaults.sh

echo "overwriting config.sh in bin/"
cp flink-conf/config.sh $FILES_DIRECTORY/flink-build/bin/config.sh

for file in flink-conf/* ; do
	filename=$(basename "$file")
	extension="${filename##*.}"
	if [[ "$extension" != "template" ]]; then
		echo "copying $file to $FILES_DIRECTORY/flink-build/conf/"
		cp $file $FILES_DIRECTORY/flink-build/conf/
	fi
done
