#plot the graphs
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


