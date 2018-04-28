#!/bin/bash

#set -x

# hosts="10.48.129.38 10.48.129.39 10.48.129.42 10.48.129.43 10.48.129.44 10.48.129.45 10.48.129.52 10.48.129.53 10.48.129.54 10.48.129.55 10.48.129.56 10.48.129.57 10.48.129.58 10.48.129.59"
hostnames="mx-razgate01 mx-razgate02 mx-mail01 mx-mail02 mx-ux01 mx-ux02 mx-queue01 mx-queue02 mx-mss01 mx-mss02 mx-search01 mx-search02 mx-directory01 mx-directory02"

dir_result=$1
# Delay time (delay_num*10 sec) in order to get stable performance data
delay_num=100

servers_avg_output="servers_perf_avg.csv"

get_servers_perf_avg() {
    cat /dev/null > $servers_avg_output
    echo "Server CPU MEM IO_write IO_read" >> $servers_avg_output
    echo "--------------------------------" >> $servers_avg_output

    for host in $hostnames
    do
        input_cpu_file="yz_cpu_${host}.txt"
        input_mem_file="yz_mem_${host}.txt"
        input_wtps_file="yz_io_write_${host}.txt"
        input_rtps_file="yz_io_read_${host}.txt"
        
        echo "Calculate CPU MEM IO_write IO_read for ${host}"
        input_cpu_file_avg=$(awk -v start=$delay_num 'BEGIN{num=0}{if(NR>start){num+=$1}}END{print num/(NR-start)}' yz_cpu_${host}.txt)
        input_mem_file_avg=$(awk -v start=$dielay_num 'BEGIN{num=0}{if(NR>start){num+=$1}}END{print num/(NR-start)}' yz_mem_${host}.txt)
        input_wtps_file_avg=$(awk -v start=$delay_num 'BEGIN{num=0}{if(NR>start){num+=$1}}END{print num/(NR-start)}' yz_io_write_${host}.txt)
        input_rtps_file_avg=$(awk -v start=$delay_num 'BEGIN{num=0}{if(NR>start){num+=$1}}END{print num/(NR-start)}' yz_io_read_${host}.txt)
        echo $host $input_cpu_file_avg $input_mem_file_avg $input_wtps_file_avg $input_rtps_file_avg >> $servers_avg_output
    done

    input_cpu_servers_avg=$(awk 'BEGIN{num=0}{if(NR>1){num+=$2}}END{print num/(NR-1)}' $servers_avg_output)
    input_mem_servers_avg=$(awk 'BEGIN{num=0}{if(NR>1){num+=$3}}END{print num/(NR-1)}' $servers_avg_output)
    input_wtps_servers_avg=$(awk 'BEGIN{num=0}{if(NR>1){num+=$4}}END{print num/(NR-1)}' $servers_avg_output)
    input_rtps_servers_avg=$(awk 'BEGIN{num=0}{if(NR>1){num+=$5}}END{print num/(NR-1)}' $servers_avg_output)

    echo "--------------------------------" >> $servers_avg_output
    echo AVERAGE $input_cpu_servers_avg $input_mem_servers_avg $input_wtps_servers_avg $input_rtps_servers_avg >> $servers_avg_output
}

plot_servers_result() {
    for host in $hostnames
    do
        echo "Plot CPU MEM IO for ${host}"
	sh /root/ux2.3-test-data/monitor/plot_monitor_result.sh ${host}
    done
}

cd $dir_result

#get_servers_perf_avg

plot_servers_result

