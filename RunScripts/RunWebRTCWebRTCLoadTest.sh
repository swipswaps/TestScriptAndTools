cd /home/burak/test
sshpass -p $1 ssh burak@54.37.3.113 "cd test/webrtc_webrtc;rm *"
sshpass -p $1 scp TestPlans/WebRTC_WebRTC.jmx burak@54.37.3.113:/home/burak/test/webrtc_webrtc
sshpass -p $1 ssh burak@54.37.3.113 "cp test/WebRTCTest test/webrtc_webrtc;cd test/webrtc_webrtc;export QT_QPA_PLATFORM=offscreen;../../apache-jmeter-4.0/bin/jmeter -nt WebRTC_WebRTC.jmx"
rm webrtc_webrtc/*
sshpass -p $1 scp burak@54.37.3.113:/home/burak/test/webrtc_webrtc/* ./webrtc_webrtc

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


