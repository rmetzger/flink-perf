for i in 1 2 3; do
	echo "i = $i"
	echo "running flink kmeans $i" >> log_flink_kmeans_driver
	start1=`date +%s`
	./runKMeansPerf.sh >> log_flink_kmeans_driver
	end=`date +%s`
	runtime=$((end-start1))
	echo "runtime=$runtime" >> log_flink_kmeans_driver
done
