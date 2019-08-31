#!/bin/bash
set -e

ref=$1
stu=$2

fraposa="python $HOME/fraposa/fraposa_runner.py"
$fraposa --method oadp --dim_ref 2 --dim_stu 8 $ref $stu
