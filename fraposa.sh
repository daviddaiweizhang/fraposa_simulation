#!/bin/bash
set -e

ref=$1
stu=$2
method=$3
out=$4

fraposa="python $HOME/fraposa/fraposa_runner.py"
$fraposa --method $method --dim_ref 2 --dim_stu 8 --dim_spikes 2 --out $out $ref $stu 
