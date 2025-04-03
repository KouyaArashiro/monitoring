#! /bin/bash

set -a
source .env
set +a

result=$(mysql --silent -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASSWORD" -D "$DB_NAME" -se " select count(*) from todos" 2>/dev/null)

if [[ $result =~ ^[0-9]+$ ]]; then
    echo "DB OK"
else 
    echo "DB NG"
fi
