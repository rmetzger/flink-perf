for i in 1 2 3; do
	echo "i = $i"
	echo "running flink delta PR $i" >> log_flink_deltaPR_driver
	start1=`date +%s`
	./runPagerankAdaptive.sh >> log_flink_deltaPR_driver
	end=`date +%s`
	runtime=$((end-start1))
	echo "runtime=$runtime" >> log_flink_deltaPR_driver
done
