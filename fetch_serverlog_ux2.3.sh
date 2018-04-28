#!/bin/bash

#set -x

# hosts="10.48.129.38 10.48.129.39 10.48.129.42 10.48.129.43 10.48.129.44 10.48.129.45 10.48.129.52 10.48.129.53 10.48.129.54 10.48.129.55 10.48.129.56 10.48.129.57 10.48.129.58 10.48.129.59"
hostnames="mx-razgate01 mx-razgate02 mx-mail01 mx-mail02 mx-ux01 mx-ux02 mx-queue01 mx-queue02 mx-mss01 mx-mss02 mx-search01 mx-search02 mx-directory01 mx-directory02"
username="root"
password="Synchron0ss"
today_date=`date +%Y%m%d`

dir_path=/root/ux2.3-test-data/log
if [ ! -f ${dir_path} ]; then
    mkdir -p ${dir_path}
fi

for host in $hostnames
do
    if [ ! -f ${dir_path}/$host ]; then
    	echo mkdir -p ${dir_path}/$host
	mkdir -p ${dir_path}/$host
    fi
    src_file=${username}@${host}:/opt/imail/log/*${today_date}*.log
    dest_file=${dir_path}/$host
    echo "Copy $host logs: scp -p $src_file $dest_file"
    # expect expect_scp.exp $src_file $dest_file $password
    scp -p -o BatchMode=yes $src_file $dest_file
done


