#!/bin/bash
set -e

nstu=50

for thincount in 0 50000 80000 90000; do
for nref in `seq 250 125 750`; do
    let "n = $nref + $nstu"
    pref=data/n${n}s${nstu}p${thincount}/a
    log=${pref}_simu.log
    mkdir -p `dirname $log`
    bash simulate.sh $n $nstu $thincount $pref &> $log &
done
done
