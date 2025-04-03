#! /bin/bash

ip=$1
port=$2
service=`curl -s -i -m 2 ${ip}:${port} | head -n 1 | grep  OK | wc -l`

if [ ${service} -eq 1 ]; then
    echo "Web server is OK!"
else
    echo "Web server is NG!"
fi
