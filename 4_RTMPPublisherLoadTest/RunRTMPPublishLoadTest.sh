#!/bin/bash

TEST_MACHINE=$1
SERVER_MACHINE=$2
CONF=$3
LOAD=$4
DURATION=$5

cd /home/burak/test
sshpass -p burak ssh burak@$TEST_MACHINE "rm -r test/rtmp_publish;mkdir test/rtmp_publish"
sshpass -p burak scp TestPlans/RTMP_Publish.jmx burak@$TEST_MACHINE:/home/burak/test/rtmp_publish
sshpass -p burak ssh burak@$TEST_MACHINE "cd test/rtmp_publish;../../apache-jmeter-4.0/bin/jmeter -JserverIP=$SERVER_MACHINE -Jload=$LOAD -Jduration=$DURATION -Jconf=Settings_$CONF -nt RTMP_Publish.jmx"

#rm rtmp_publish/*
sshpass -p burak scp burak@$TEST_MACHINE:/home/burak/test/rtmp_publish/*.csv ./rtmp_publish

cd rtmp_publish

gnuplot -e 	"set datafile separator ',';
		set term png; 
		set output '$CONF-cpu.png';
		set xlabel 'clients';
		set ylabel 'cpu usage %';
		plot 'Settings_$CONF.csv' using 1:2 with linespoints;"

gnuplot -e 	"set datafile separator ',';
		set term png; 
		set output '$CONF-ram.png';
		set xlabel 'clients';
		set ylabel 'ram usage MB';
		plot 'Settings_$CONF.csv' using 1:(\$3/1024/1024) with linespoints;"






