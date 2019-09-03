#!/bin/bash
set -e

nstu=50

for nref in `seq 250 125 750`; do
    let "n = $nref + $nstu"
    pref=data/n${n}s${nstu}/a
    log=${pref}_simu.log
    mkdir -p `dirname $log`
    bash simulate.sh $n $nstu $pref &> $log &
done
