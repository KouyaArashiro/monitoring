#! /bin/bash

ip=$1
net=`ping -c 10 -i 0.1 -w 1 $ip | grep 100% | wc -l`
#echo ${net}

if [ ${net} -eq 0 ]; then
    echo ${ip}"'s net OK "
else
    echo ${ip}"'s net NG"
fi
