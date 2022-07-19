#!/bin/bash

psql -d db_test -U postgres -c "create table key_value(key text, value text, PRIMARY KEY(key));"
psql -d db_test -U postgres -c "create table key_b64(key text, b64 text, PRIMARY KEY(key));"
psql -d db_test -U postgres -c "create table b64_value(b64 text, value text, PRIMARY KEY(b64));"
psql -d db_test -U postgres -c "create table id_key(id serial, key text, PRIMARY KEY(id));"


for i in $(cat /words_alpha.txt | head -n 1000)
do
	BASE64=$(echo $i | base64)
	psql -d db_test -U postgres <<QUERY
	insert into key_value (key, value) values ( '$i' , '$i' );
	insert into key_b64 (key, b64) values ( '$i' , '$BASE64' );
	insert into b64_value (b64, value) values ( '$BASE64' , '$i' );
	insert into id_key (key) values ( '$i' );
QUERY

done
