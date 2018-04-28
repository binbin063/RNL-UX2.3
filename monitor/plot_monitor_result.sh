#!/bin/bash  
# usage 

hostname=$1

input_cpu_file="yz_cpu_${hostname}.txt"
output_cpu_file="yz_cpu_${hostname}.png"

input_mem_file="yz_mem_${hostname}.txt"
output_mem_file="yz_mem_${hostname}.png"

input_wtps_file="yz_io_write_${hostname}.txt"
input_rtps_file="yz_io_read_${hostname}.txt"
output_io_file="yz_io_${hostname}.png"

plot_cpu()  
{  
  gnuplot << EOF  
  set terminal png size 800, 600
  set output "${output_cpu_file}"
  set tmargin 2
  set lmargin 9
  set rmargin 6
  set grid
  set key center tmargin
  set yrange [0:*]
  set xrange [0:*]
  set xlabel 'TIME (N*10 sec)'
  set ylabel 'CPU (%)'
  plot "${input_cpu_file}" using 0:1 title "${hostname} CPU Usage" w l lt 3 lw 2
EOF
}

plot_mem()  
{  
  gnuplot << EOF  
  set terminal png size 800, 600
  set output "${output_mem_file}"
  set tmargin 2
  set lmargin 9
  set rmargin 6
  set grid
  set key center tmargin
  set yrange [0:*]
  set xrange [0:*]
  set xlabel 'TIME (N*10 sec)'
  set ylabel 'Mem (MB)'
  plot "${input_mem_file}" using 0:1 title "${hostname} Mem Used" w l lt 3 lw 2
EOF
}

plot_io()
{
  gnuplot << EOF  
  set terminal png size 800, 600
  set output "${output_io_file}"
  set xdata time
  set timefmt "%s"
  set format x "%H:%M"
  set tmargin 2
  set lmargin 9
  set rmargin 6
  set grid
  set key center bmargin
  set yrange [0:*]
  plot "${input_wtps_file}" using 0:1 title "IO wtps (n/s)" w l lt 3 lw 2, "${input_rtps_file}" using 0:1 title "IO rtps (n/s)" w l lt 1 lw 2
EOF
}

plot_avg(){
  gnuplot << EOF  
  set terminal png size 800, 600
  set output "plot_avg.png"
  set key top left  
  set key box 
  set tmargin 2
  set lmargin 9
  set rmargin 6
  set ylabel "IO Rtps Avg"
  set xlabel "Number of Concurrent Users"
  set yrange [0:*]
  set xrange [0:24000]
  set grid
  plot "io_rtps_avg.txt" using 1:2 title "mx-razgate01" with linespoints pointtype 5 linewidth 2 linecolor "red", "io_rtps_avg.txt" using 1:3 title "mx-razgate02" with linespoints pointtype 5 linewidth 2 linecolor "blue"
EOF
}

plot_cpu
plot_mem
