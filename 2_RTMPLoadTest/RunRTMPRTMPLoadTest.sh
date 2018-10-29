#!/bin/bash

TEST_MACHINE=$1
SERVER_MACHINE=$2

cd /home/burak/test
sshpass -p burak ssh burak@$TEST_MACHINE "rm -r test/rtmp_rtmp;mkdir test/rtmp_rtmp"
sshpass -p burak scp TestPlans/RTMP_RTMP.jmx burak@$TEST_MACHINE:/home/burak/test/rtmp_rtmp
sshpass -p burak scp RTMPClient burak@$TEST_MACHINE:/home/burak/test/rtmp_rtmp
sshpass -p burak ssh burak@$TEST_MACHINE "cd test/rtmp_rtmp;../../apache-jmeter-4.0/bin/jmeter -JserverIP=$SERVER_MACHINE -Jduration=300 -nt RTMP_RTMP.jmx"
rm rtmp_rtmp/*
sshpass -p burak scp burak@$TEST_MACHINE:/home/burak/test/rtmp_rtmp/*.csv ./rtmp_rtmp

cd rtmp_rtmp

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
		set output 'latency.png';
		set xlabel 'clients';
		set ylabel 'time in ms';
		plot 'latency.csv' using 10:(\$9-\$8);"


