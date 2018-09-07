cd /home/burak/test
sshpass -p $1 ssh burak@54.37.3.113 "cd test/webrtc_webrtc_cluster;rm *"
sshpass -p $1 scp TestPlans/WebRTC_WebRTC_Cluster.jmx burak@54.37.3.113:/home/burak/test/webrtc_webrtc_cluster
sshpass -p $1 ssh burak@54.37.3.113 "cp test/WebRTCTest test/webrtc_webrtc_cluster;cd test/webrtc_webrtc_cluster;export QT_QPA_PLATFORM=offscreen;../../apache-jmeter-4.0/bin/jmeter -nt WebRTC_WebRTC_Cluster.jmx"
rm webrtc_webrtc_cluster/*
sshpass -p $1 scp burak@54.37.3.113:/home/burak/test/webrtc_webrtc_cluster/* ./webrtc_webrtc_cluster

cd webrtc_webrtc_cluster

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


