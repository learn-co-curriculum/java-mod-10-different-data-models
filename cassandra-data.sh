#!/bin/bash

cqlsh -e "CREATE KEYSPACE IF NOT EXISTS performance WITH REPLICATION = { 'class' : 'SimpleStrategy', 'replication_factor' : '1' };"
cqlsh -e "CREATE TABLE IF NOT EXISTS performance.key_value (key text PRIMARY KEY, value text);"
cqlsh -e "CREATE TABLE IF NOT EXISTS performance.id_key (id int PRIMARY KEY, key text);"

ID=1
for i in $(cat /words_alpha.txt | head -n 1000)
do

cat <<QUERY | cqlsh
INSERT INTO performance.key_value (key, value) VALUES ('$i', '$i'); INSERT INTO performance.id_key (id, key) VALUES ($ID, '$i');
QUERY

ID=$(($ID+1))

done
