#!/bin/bash
set -e

npercenter=30
nstu=20
K=8
k=2
pref=data/example
mkdir -p `dirname $pref`

bash ggs.sh $npercenter $pref.ggs
bash ggs2plink.sh $pref.ggs $pref
bash splitrefstu.sh $pref $nstu
bash trace.sh ${pref}_ref ${pref}_stu $K $k $pref
bash fraposa.sh ${pref}_ref ${pref}_stu --method oadp --dim_ref 2 --dim_stu 8
rm fraposa.log
