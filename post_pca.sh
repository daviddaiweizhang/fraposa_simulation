#!/bin/bash
set -e

msd=data/msd
rm -f $msd
for m in `seq 1000 500 3000`; do
    let "n = $m / 4 + 50"
    pref=data/n${n}s${nstu}/a
    cat ${pref}_msd >> $msd
done
Rscript plot_trend.R $msd
