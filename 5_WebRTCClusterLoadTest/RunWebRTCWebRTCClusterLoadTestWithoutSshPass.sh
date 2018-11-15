#!/bin/bash

#settings
TEST_SERVER=				#test server address
TS_USER=				#test server user
TS_PASS=na				#test server password
ORIGIN_SERVER=				#origin server address
LOAD_BALANCER=				#load balancer address
TEST_FILE=				#test media name

#clear test server directories
ssh $TEST_SERVER "rm -r test/webrtc_webrtc_cluster;mkdir test/webrtc_webrtc_cluster"
#copy test plan from local pc to test server
scp WebRTC_WebRTC_Cluster.jmx $TEST_SERVER:/home/$TS_USER/test/webrtc_webrtc_cluster
#copy WebRTCTest and test file to testing directory
ssh $TEST_SERVER "cp test/WebRTCTest test/webrtc_webrtc_cluster"
ssh $TEST_SERVER "cp test/$TEST_FILE test/webrtc_webrtc_cluster"
#start test

ssh $TEST_SERVER "sudo docker exec -w /home/burak/test/webrtc_webrtc_cluster ant-test /bin/bash -c 'export QT_QPA_PLATFORM=offscreen && /home/$TS_USER/test/apache-jmeter-5.0/bin/jmeter -Jos=$ORIGIN_SERVER -Jlb=$LOAD_BALANCER -Jmedia=$TEST_FILE -Jload=1000 -Jstream=test -Jduration=1000 -nt WebRTC_WebRTC_Cluster.jmx'"

#clear or create local test result directory
rm webrtc_webrtc_cluster/*
mkdir webrtc_webrtc_cluster
#copy test result from test server to local pc
scp $TEST_SERVER:/home/$TS_USER/test/webrtc_webrtc_cluster/*.csv ./webrtc_webrtc_cluster
cd webrtc_webrtc_cluster
#plot the cpu usage graph
gnuplot -persist <<-EOFMarker
set datafile separator ','
set term png size 1000,800
set output 'measures.png'
set xlabel 'clients'
set ylabel 'cpu usage %'
unset key
set multiplot layout 2,2 columnsfirst
set title "server-1 - cpu"	
plot 'measures.csv' using 1:3 with linespoints
set title "server-2 - cpu"
plot 'measures.csv' using 1:7 with linespoints
set xlabel 'clients'
set ylabel 'ram usage MB'
set title "server-1 - ram"	
plot 'measures.csv' using 1:4 with linespoints
set title "server-2 - ram"
plot 'measures.csv' using 1:8 with linespoints
unset multiplot
EOFMarker
