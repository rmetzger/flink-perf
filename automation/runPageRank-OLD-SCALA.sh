#/bin/sh

echo "Running Page Rank"

. ./configDefaults.sh

HDFS_PAGERANK_PAGES=hdfs:///user/aljoscha/datasets/twitter-vertices
HDFS_PAGERANK_LINKS=hdfs:///user/robert/datasets/twitter-follower-graph
HDFS_PAGERANK__OUT=hdfs:///user/aljoscha/results/pagerank-twitter

NUM_PAGES=41652230

ARGS="$HDFS_PAGERANK_PAGES $HDFS_PAGERANK_LINKS $HDFS_PAGERANK_OUT $NUM_PAGES 10 $DOP"
echo "running Page Rank with args $ARGS"

$FLINK_BUILD_HOME"/bin/flink" run -p $DOP flink-old-scala-examples.jar \
 -c org.apache.flink.examples.scala.graph.PageRank $ARGS

echo "ran Page Rank with args $ARGS"

