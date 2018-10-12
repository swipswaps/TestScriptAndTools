#!/bin/bash

TEST_MACHINE=$1
SERVER_MACHINE=$2

cd /home/burak/test
sshpass -p burak ssh burak@$TEST_MACHINE "rm -r test/webrtc_webrtc;mkdir test/webrtc_webrtc"
sshpass -p burak scp TestPlans/WebRTC_WebRTC.jmx burak@$TEST_MACHINE:/home/burak/test/webrtc_webrtc
sshpass -p burak ssh burak@$TEST_MACHINE "cp test/WebRTCTest test/webrtc_webrtc;cd test/webrtc_webrtc;export QT_QPA_PLATFORM=offscreen;../../apache-jmeter-4.0/bin/jmeter -JserverIP=$SERVER_MACHINE -Jduration=280 -nt WebRTC_WebRTC.jmx"
rm webrtc_webrtc/*
sshpass -p burak scp burak@$TEST_MACHINE:/home/burak/test/webrtc_webrtc/*.csv ./webrtc_webrtc

cd webrtc_webrtc

gnuplot -e 	"set datafile separator ',';
		set term png; 
		set output 'cpu.png';
		set xlabel 'clients';
		set ylabel 'cpu usage %';
		plot 'measures.csv' using 1:2 with linespoints;"

gnuplot -e 	"set datafile separator ',';
		set term png; 
		set output 'ram.png';
		set xlabel 'clients';
		set ylabel 'ram usage MB';
		plot 'measures.csv' using 1:(\$3/1024/1024) with linespoints;"

gnuplot -e 	"set datafile separator ',';
		set term png; 
		set output 'video.png';
		set xlabel 'clients';
		set ylabel 'video ms';
		plot 'measures.csv' using 1:4 with linespoints;"

gnuplot -e 	"set datafile separator ',';
		set term png; 
		set output 'audio.png';
		set xlabel 'clients';
		set ylabel 'audio ms';
		plot 'measures.csv' using 1:5 with linespoints;"


