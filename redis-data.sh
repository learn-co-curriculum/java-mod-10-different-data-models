#!/bin/bash

for i in $(cat /words_alpha.txt | head -n 1000)
do
	redis-cli hset key_value $i $i
done
