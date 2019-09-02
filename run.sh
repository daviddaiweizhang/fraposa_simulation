#!/bin/bash
set -e

nstu=50

mkdir -p log
for m in `seq 1000 500 3000`; do
    let "n = $m / 4 + 50"
    bash simulate.sh $n $nstu &> log/c$n.log &
done
