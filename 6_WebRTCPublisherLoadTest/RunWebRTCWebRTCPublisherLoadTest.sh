#!/bin/bash

#settings
TEST_SERVER=				#test server address
TS_USER=				#test server user
TS_PASS=				#test server password
ORIGIN_SERVER=				#origin server address
LOAD_BALANCER=				#load balancer address
TEST_FILE=				#test media name

#clear test server directories
sshpass -p $TS_PASS ssh $TS_USER@$TEST_SERVER "rm -r test/webrtc_webrtc_cluster;mkdir test/webrtc_webrtc_cluster"
#copy test plan from local pc to test server
sshpass -p $TS_PASS scp WebRTC_WebRTC_Cluster.jmx $TS_USER@$TEST_SERVER:/home/$TS_USER/test/webrtc_webrtc_cluster
#copy WebRTCTest and test file to testing directory
sshpass -p $TS_PASS ssh $TS_USER@$TEST_SERVER "cp test/WebRTCTest test/webrtc_webrtc_cluster"
sshpass -p $TS_PASS ssh $TS_USER@$TEST_SERVER "cp test/$TEST_FILE test/webrtc_webrtc_cluster"
#start test
sshpass -p $TS_PASS ssh $TS_USER@$TEST_SERVER "cd test/webrtc_webrtc_cluster;export QT_QPA_PLATFORM=offscreen;/home/$TS_USER/test/apache-jmeter-4.0/bin/jmeter -Jos=$ORIGIN_SERVER -Jlb=$LOAD_BALANCER -Jmedia=$TEST_FILE -nt WebRTC_WebRTC_Cluster.jmx"

#clear or create local test result directory
rm webrtc_webrtc_cluster/*
mkdir webrtc_webrtc_cluster
#copy test result from test server to local pc
sshpass -p $TS_PASS scp $TS_USER@$TEST_SERVER:/home/$TS_USER/test/webrtc_webrtc_cluster/*.csv ./webrtc_webrtc_cluster
cd webrtc_webrtc_cluster
#plot the cpu usage graph
gnuplot -persist <<-EOFMarker
set datafile separator ','
set term png size 1000,1000
set output 'measures.png'
set xlabel 'clients'
set ylabel 'cpu usage %'
unset key
set multiplot layout 3,2 columnsfirst
set title "node-1"	
plot 'measures.csv' using 1:3 with linespoints
set title "node-2"
plot 'measures.csv' using 1:7 with linespoints
set title "node-3"
plot 'measures.csv' using 1:11 with linespoints
set xlabel 'clients'
set ylabel 'ram usage MB'
set title "node-1"	
plot 'measures.csv' using 1:4 with linespoints
set title "node-2"
plot 'measures.csv' using 1:8 with linespoints
set title "node-3"
plot 'measures.csv' using 1:12 with linespoints
unset multiplot
EOFMarker
