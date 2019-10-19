#!/bin/bash
set -e

n=$1

nstu=50
K=8
k=2
pref=data/n${n}s${nstu}/a
time -p bash fraposa.sh ${pref}_ref ${pref}_stu oadp ${pref}_oadp
time -p bash fraposa.sh ${pref}_ref ${pref}_stu ap ${pref}_ap
time -p bash fraposa.sh ${pref}_ref ${pref}_stu sp ${pref}_sp
time -p bash trace.sh ${pref}_ref ${pref}_stu $K $k ${pref}_adp ${pref}_ref
