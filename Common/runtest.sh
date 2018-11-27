#!/bin/bash

TEST_TYPE=$1
NOW=$(date +"%F_%T")

TEST_BASE=/home/antmedia/test
TEST_DIR=$TEST_BASE/results/$TEST_TYPE/$NOW

TOOLS_BASE=/home/antmedia/test/TestScriptAndTools-master

case $TEST_TYPE in
'hls_play')
    TEST_ORG_DIR=$TOOLS_BASE/1_HLSLoadTest
    TEST_PLAN=RTMP_HLS.jmx
    ;;
'rtmp_play')
    TEST_ORG_DIR=$TOOLS_BASE/2_RTMPLoadTest
    TEST_PLAN=RTMP_RTMP.jmx
    ;;
'webrtc_play')
    TEST_ORG_DIR=$TOOLS_BASE/3_WebRTCLoadTest
    TEST_PLAN=WebRTC_WebRTC.jmx
    ;;
'rtmp_publish')
    TEST_ORG_DIR=$TOOLS_BASE/4_RTMPPublisherLoadTest
    TEST_PLAN=RTMP_Publisher.jmx
    ;;
'webrtc_publish')
    TEST_ORG_DIR=$TOOLS_BASE/5_WebRTCPublisherLoadTest
    TEST_PLAN=WebRTC_Publisher.jmx
    ;;
*)
    echo "invalid test type"
    exit 1
    ;;
esac

mkdir -p $TEST_DIR

cp $TEST_ORG_DIR/* $TEST_DIR
cp $TOOLS_BASE/Media/* $TEST_DIR
cp $TOOLS_BASE/Tools/* $TEST_DIR

cd $TOOLS_BASE/Common
source config.sh
JMETER=$TEST_BASE/apache-jmeter-5.0/bin/jmeter


cd $TEST_DIR
COMMAND="$JMETER -Jos=$ORIGIN_SERVER -Jeap=$EDGE_ACCESS_POINT -Jmedia=$TEST_FILE -Jload=$LOAD_SIZE -Jstream=$STREAM_NAME -Jduration=$DURATION -nt $TEST_PLAN"

export QT_QPA_PLATFORM=offscreen

echo  "running command:$COMMAND" 
$COMMAND

sh report.sh

echo $TEST_DIR>>$TEST_BASE/results/history
echo "test has been finished. check directory:$TEST_DIR"
