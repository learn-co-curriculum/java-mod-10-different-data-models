#!/bin/bash

ID=1
for i in $(cat /words_alpha.txt | head -n 1000)
do
	curl -s -X POST "localhost:9200/key_value/_doc?pretty" -H 'Content-Type: application/json' -d "{\"key\": \"$i\", \"value\": \"$i\"}"
	curl -s -X POST "localhost:9200/id_key/_doc?pretty" -H 'Content-Type: application/json' -d "{\"id\": $ID, \"key\": \"$i\"}"
	ID=$(($ID+1))
done
