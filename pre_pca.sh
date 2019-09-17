#!/bin/bash
set -e

nstu=50

for thincount in 0 50000 80000 90000; do
for nref in `seq 250 125 750`; do
    let "n = $nref + $nstu"
    if [ "$thincount" == 0 ]; then
	    pref=data/n${n}s${nstu}/a
    else
	    pref=data/n${n}s${nstu}p${thincount}/a
    fi
    log=${pref}_simu.log
    mkdir -p `dirname $log`
    bash simulate.sh $n $nstu $thincount $pref &> $log &
done
done
