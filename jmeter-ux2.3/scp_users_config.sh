#!/bin/bash

#set -x

jmeter_hosts="10.48.129.62 10.48.129.63 10.48.129.64 10.48.129.65 10.48.129.66 10.48.129.67"

dir_path=/root/ux2.3-test-data/jmeter-ux2.3

for host in $jmeter_hosts
do
    src_file=./jmeter_${host:10}_users.dat
    dest_file=root@${host}:${dir_path}/jmeter_users_range.dat
    echo "Copy $host : scp -p $src_file $dest_file"
    ssh -o BatchMode=yes root@${host} "mkdir -p ${dir_path};cat /dev/null ${dir_path}/jmeter_users_range.dat"
    scp -p -o BatchMode=yes $src_file $dest_file
#	ssh -o BatchMode=yes root@${host} "rm -rf /root/ux2.3-test-data/jmeter_ux2.3"
done
