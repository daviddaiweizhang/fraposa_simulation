#!/bin/bash
set -e

nstu=50
K=8
k=2

for n in `seq 300 125 800`; do
    base=data/n${n}s${nstu}
    id=`date +%s.%N`
    root=$base/tmp/$id
    mkdir -p $root
    cp $base/a_{ref,stu}.{bed,bim,fam} $root

    rm -f $root/*.dat
    time -p bash fraposa.sh $root/a_ref $root/a_stu sp $root/a_sp
    rm -f $root/*.dat
    time -p bash fraposa.sh $root/a_ref $root/a_stu ap $root/a_ap
    rm -f $root/*.dat
    time -p bash fraposa.sh $root/a_ref $root/a_stu oadp $root/a_oadp
    rm -f $root/*.dat $root/*.coord
    time -p bash trace.sh $root/a_ref $root/a_stu $K $k $root/a_adp $root/a_ref
done
