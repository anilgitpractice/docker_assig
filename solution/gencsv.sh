#!/bin/bah

touch inputFile && RANDOM=$$
for i in `seq 10`
  do
  echo $i,$RANDOM
done >>inputFile  
