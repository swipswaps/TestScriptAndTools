#!/bin/bash

TEST_MACHINE=$1
SERVER_MACHINE=$2

cd /home/burak/test
sshpass -p burak ssh burak@$TEST_MACHINE "rm -r test/rtmp_hls;mkdir test/rtmp_hls"
sshpass -p burak scp TestPlans/RTMP_HLS2.jmx burak@$TEST_MACHINE:/home/burak/test/rtmp_hls
sshpass -p burak ssh burak@$TEST_MACHINE "cd test/rtmp_hls;../../apache-jmeter-4.0/bin/jmeter -JserverIP=$SERVER_MACHINE -Jduration=530 -nt RTMP_HLS2.jmx"
rm rtmp_hls/*
sshpass -p burak scp burak@$TEST_MACHINE:/home/burak/test/rtmp_hls/*.csv ./rtmp_hls

cd rtmp_hls

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
		set output 'ts.png';
		set xlabel 'clients';
		set ylabel 'time in ms';
		plot 'getonets.csv' using 7:2;"


