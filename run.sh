#!/bin/bash
set -e

mkdir -p log
for n in `seq 1000 500 3000`; do
    let "npercenter = ($n + 200) / 4"
    bash run.sh $npercenter &> log/c$npercenter.log & 
done
