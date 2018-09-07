cd /home/burak/test
sshpass -p $1 ssh burak@ovh36.antmedia.io "cd test/rtmp_rtmp;rm *"
sshpass -p $1 scp TestPlans/RTMP_RTMP.jmx burak@ovh36.antmedia.io:/home/burak/test/rtmp_rtmp
sshpass -p $1 scp RTMPClient burak@ovh36.antmedia.io:/home/burak/test/rtmp_rtmp
sshpass -p $1 ssh burak@ovh36.antmedia.io "cd test/rtmp_rtmp;../../apache-jmeter-4.0/bin/jmeter -nt RTMP_RTMP.jmx"
rm rtmp_rtmp/*
sshpass -p $1 scp burak@ovh36.antmedia.io:/home/burak/test/rtmp_rtmp/* ./rtmp_rtmp

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


