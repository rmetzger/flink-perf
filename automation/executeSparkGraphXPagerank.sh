
for i in 1 2 3; do
	echo "i = $i"
	echo "running spark graphX" >> log_spark_graphx_driver
	start1=`date +%s`
	./runSparkGraphXPagerank.sh >> log_spark_graphx_driver
	end=`date +%s`
	runtime=$((end-start1))
	echo "runtime=$runtime" >> log_spark_graphx_driver
done
