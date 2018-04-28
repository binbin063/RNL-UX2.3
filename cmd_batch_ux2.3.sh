#!/bin/bash

#set -x

# hosts="10.48.129.38 10.48.129.39 10.48.129.42 10.48.129.43 10.48.129.44 10.48.129.45 10.48.129.52 10.48.129.53 10.48.129.54 10.48.129.55 10.48.129.56 10.48.129.57 10.48.129.58 10.48.129.59"
hostnames="mx-razgate01 mx-razgate02 mx-mail01 mx-mail02 mx-ux01 mx-ux02 mx-queue01 mx-queue02 mx-mss01 mx-mss02 mx-search01 mx-search02 mx-directory01 mx-directory02"
#jmeter_hosts="10.48.129.62 10.48.129.63 10.48.129.64 10.48.129.65 10.48.129.66 10.48.129.67"

#echo $jmeter_hosts
for host in $hostnames
do
	
    	#cmd="echo ${host}"
   	#cmd="sh ssh_trust.sh $host root Synchron0ss"
	#cmd="ssh -o BatchMode=yes root@${host} 'yum -y install sysstat'"
#	cmd="ssh -o BatchMode=yes root@$host 'mkdir -p /root/ux2.3-test-data/monitor'; scp -o BatchMode=yes -r /root/ux2.3-test-data/monitor/yz_* root@$host:/root/ux2.3-test-data/monitor"
	#cmd="ssh -o BatchMode=yes root@$host \"rm -rf /root/ux2.3-test-data\""
	cmd="ssh -o BatchMode=yes root@${host} 'service ntpd start'"
	echo "exec cmd: ${cmd}"
     	eval $cmd
done
