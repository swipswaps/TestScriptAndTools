cd /home/burak/test
sshpass -p $1 ssh burak@ovh36.antmedia.io "cd test/rtmp_hls;rm *"
sshpass -p $1 scp TestPlans/RTMP_HLS.jmx burak@ovh36.antmedia.io:/home/burak/test/rtmp_hls
sshpass -p $1 ssh burak@ovh36.antmedia.io "cd test/rtmp_hls;../../apache-jmeter-4.0/bin/jmeter -nt RTMP_HLS.jmx"
rm rtmp_hls/*
sshpass -p $1 scp burak@ovh36.antmedia.io:/home/burak/test/rtmp_hls/* ./rtmp_hls

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
		plot 'getonets.csv' using 6:2;"


