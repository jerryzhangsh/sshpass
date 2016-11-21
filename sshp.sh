#!/bin/bash  
  
RC_ERR_NO_HOST=11  
RC_ERR_NO_PASSWORD=21  
RC_SUCCESS=0  
  
pass_path=$(dirname $(readlink -f $0))/sshp_pass
	  
host=$1

if [ -z $host ]; then 
    cat $pass_path | awk  '{print $1}'
    echo "please input one host which displayed above:"  
    read host
fi
  
# arguments   
if [ -z $host ]; then  
    echo "ERR_NO_HOST, please input host."  
    exit $RC_ERR_NO_HOST    
fi  
  
# read file
user=`grep $host\  $pass_path | cut -d' ' -f 2`
password=`grep $host\  $pass_path | cut -d' ' -f 3`
port=`grep $host\  $pass_path | cut -d' ' -f 4`

if [ -z $password ]; then  
    echo "ERR_NO_PASSWORD, please record password first. file path $pass_path"  
    exit $RC_ERR_NO_PASSWORD  
fi

# default port
if [ -z $port ]; then
    port=22
fi

exec sshpass -p $password ssh -o ConnectTimeout=5 $user@$host -p$port  
exit $RC_SUCCESS
