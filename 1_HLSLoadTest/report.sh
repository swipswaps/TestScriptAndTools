#plot the graphs
gnuplot -persist <<-EOFMarker
set datafile separator ','
set term png size 500,1500
set output 'measures.png'
set xlabel 'players'
unset key
set multiplot layout 3,1 columnsfirst
set ylabel 'cpu usage %'
set title "CPU"	
plot 'measures.csv' using 1:2 with linespoints
set ylabel 'ram usage MB'
set title "Memory"	
plot 'measures.csv' using 1:(\$3/1024/1024) with linespoints
set ylabel 'time in ms'
set title "Time to get one .ts"	
plot 'getonets.csv' using 7:2 with linespoints
unset multiplot
EOFMarker
