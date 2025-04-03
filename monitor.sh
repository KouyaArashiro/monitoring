#! /bin/bash

set -a
source .env
set +a

net_check () {
    ip=$1
    result=`ping -c 10 -i 0.1 -w 1 ${ip} | grep 100% | wc -l`
    if [ $result -eq 0 ]; then
        return 1
    else
        return 0
    fi
}

db_check () {
    result=$(mysql --connect-timeout=5 -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASSWORD" -D "$DB_NAME" -se " select count(*) from todos" 2>/dev/null)

    if [[ $result =~ ^[0-9]+$ ]]; then
        return 1
    else
        return 0
    fi
}

web_check () {
    ip=$1
    port=$2
    service=`curl -s -i -m 2 ${ip}:${port} | head -n 1 | grep  OK | wc -l`

    if [ ${service} -eq 1 ]; then
        return 1
    else
        return 0
    fi
}

while [ 1 ]; do
    net_check $TARGET_IP
    if [ $? -eq 1 ]; then
        echo "Network OK"
    else
        echo "Network NG"
        echo "Start recovery..."
        exit
    fi

    db_check
    if [ $? -eq 1 ]; then
        echo "Database OK"
    else
        echo "Database NG"
        echo "Start recovery..."
        #exit
    fi

    web_check $TARGET_IP $TARGET_PORT
    if [ $? -eq 1 ]; then
        echo "Web OK"
    else
        echo "Web NG"
        echo "Start recovery..."
        #exit
    fi

    sleep 10
done
