#!/bin/bash
set -e

nstu=200

mkdir -p log
for n in `seq 1000 500 3000`; do
    let "npercenter = ($n + 200) / 4"
    bash simulate.sh $npercenter $nstu &> log/c$npercenter.log &
done
