from pyspark import SparkContext, SparkConf

# spark://cloud-11.dima.tu-berlin.de:7077
conf = SparkConf().setAppName("python wordcount").setMaster("local[4]")
sc = SparkContext(conf=conf)

file = sc.textFile("hdfs:///user/robert/datasets/access-50.log")
counts = file.flatMap(lambda line: line.split(" ")) \
             .map(lambda word: (word, 1)) \
             .reduceByKey(lambda a, b: a + b)
counts.saveAsTextFile("hdfs:///user/robert/playground/spark_py_wordcount33")
