#!/bin/bash
# usage ./ssh_trust.sh mx-razgate01 root Synchron0ss
# Establish trust relationship for host to mx-razgate01

dst_host=$1  
dst_username=$2 
dst_passwd=$3

copy_pub()  
{
	echo "call copy_pub"  
expect << EOF  
	spawn scp /root/.ssh/id_rsa.pub $dst_username@$dst_host:/tmp  
	expect {  
	"password:" {  
	send "$dst_passwd\n";exp_continue  
	}  
	"yes/no*" {  
	send "yes\n";exp_continue  
	}     
	eof {  
	exit  
	}  
	}  
EOF
}

put_pub()  
{  
	echo "call put_pub"
expect << EOF  
  spawn ssh $dst_username@$dst_host "mkdir -p ~/.ssh;cat /tmp/id_rsa.pub >> ~/.ssh/authorized_keys;chmod 600 ~/.ssh/authorized_keys"  
  expect {  
    "password:" {  
      send "$dst_passwd\n";exp_continue  
    }  
    "yes/no*" {  
      send "yes\n";exp_continue  
    }     
    eof {  
      exit  
    }   
  }  
EOF
}

copy_pub  
sleep 1
put_pub
