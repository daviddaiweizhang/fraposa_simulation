#!/bin/bash
set -e

n=$1
nstu=$2
K=8
k=2
pref=data/c${n}/a
mkdir -p `dirname $pref`

bash ggs.sh $n $pref.ggs
bash ggs2plink.sh $pref.ggs $pref
bash splitrefstu.sh $pref $nstu
bash fraposa.sh ${pref}_ref ${pref}_stu oadp ${pref}_oadp
bash fraposa.sh ${pref}_ref ${pref}_stu ap ${pref}_ap
bash fraposa.sh ${pref}_ref ${pref}_stu sp ${pref}_sp
bash trace.sh ${pref}_ref ${pref}_stu $K $k $pref
Rscript plot.R $pref
