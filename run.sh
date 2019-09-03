#!/bin/bash
set -e

nstu=100
msd=data/msd
rm -f $msd

mkdir -p log
for m in `seq 1000 500 3000`; do
    let "n = $m / 4 + 50"
    pref=data/c${n}/a
    bash simulate.sh $n $nstu $pref &> log/c$n.log &
    cat ${pref}_msd >> $msd
done

Rscript plot_trend.R $msd
