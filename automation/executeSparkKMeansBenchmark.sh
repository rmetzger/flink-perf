for i in 1 2 3; do
	echo "i = $i"
	echo "running spark kmeans $i" >> log_spark_kmeans_driver
	start1=`date +%s`
	./runSparkKMeansPerf-java.sh >> log_spark_kmeans_driver
	end=`date +%s`
	runtime=$((end-start1))
	echo "runtime=$runtime" >> log_spark_kmeans_driver
done
