#plot the graphs
gnuplot -persist <<-EOFMarker
set datafile separator ','
set term png size 500,1000
set output 'measures.png'
set xlabel 'clients'
unset key
set multiplot layout 2,1 columnsfirst
set title "cpu"
set ylabel 'cpu usage %'	
plot 'measures.csv' using 1:2 with linespoints
set title "memory"
set ylabel 'ram usage MB'	
plot 'measures.csv' using 1:(\$3/1024/1024) with linespoints
unset multiplot
EOFMarker


