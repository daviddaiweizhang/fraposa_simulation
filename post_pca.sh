#!/bin/bash
set -e

nstu=50

for thincount in 0 10000 50000 80000; do
    if [ "$thincount" == 0 ]; then
        msd=data/msd
    else
        msd=data/msd_p${thincount}
    fi
    rm -r $msd
    for nref in `seq 250 125 750`; do
        let "n = $nref + $nstu"
        if [ "$thincount" == 0 ]; then
                pref=data/n${n}s${nstu}/a
        else
                pref=data/n${n}s${nstu}p${thincount}/a
        fi
        cat ${pref}_msd >> $msd
    done
    Rscript plot_trend.R $msd
done
