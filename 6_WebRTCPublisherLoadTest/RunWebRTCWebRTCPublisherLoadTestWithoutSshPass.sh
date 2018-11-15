#!/bin/bash

#settings
TEST_SERVER=				#test server address
TS_USER=				#test server user
TS_PASS=na				#test server password
ORIGIN_SERVER=				#origin server address
LOAD_BALANCER=				#load balancer address
TEST_FILE=				#test media name

#clear test server directories
ssh $TEST_SERVER "rm -r test/webrtc_publisher;mkdir test/webrtc_publisher"
#copy test plan from local pc to test server
scp WebRTC_Publisher.jmx $TEST_SERVER:/home/$TS_USER/test/webrtc_publisher
#copy WebRTCTest and test file to testing directory
ssh $TEST_SERVER "cp test/WebRTCTest test/webrtc_publisher"
ssh $TEST_SERVER "cp test/$TEST_FILE test/webrtc_publisher"
#start test

ssh $TEST_SERVER "sudo docker exec -w /home/burak/test/webrtc_publisher ant-test /bin/bash -c 'export QT_QPA_PLATFORM=offscreen && /home/$TS_USER/test/apache-jmeter-5.0/bin/jmeter -Jos=$ORIGIN_SERVER -Jlb=$LOAD_BALANCER -Jmedia=$TEST_FILE -Jload=60 -Jstream=test -Jduration=180 -nt WebRTC_Publisher.jmx'"

#clear or create local test result directory
rm webrtc_publisher/*
mkdir webrtc_publisher
#copy test result from test server to local pc
scp $TEST_SERVER:/home/$TS_USER/test/webrtc_publisher/*.csv ./webrtc_publisher
cd webrtc_publisher
#plot the graphs
gnuplot -persist <<-EOFMarker
set datafile separator ','
set term png size 1000,500
set output 'measures.png'
set xlabel 'publishers'
set ylabel 'cpu usage %'
unset key
set multiplot layout 1,2 columnsfirst
set title "transcoder"	
plot 'measures.csv' using 1:2 with linespoints
set xlabel 'publishers'
set ylabel 'ram usage MB'
set title "transcoder"	
plot 'measures.csv' using 1:(\$3/1024/1024) with linespoints
unset multiplot
EOFMarker
