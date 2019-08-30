#!/bin/bash
set -e

infile=$1
outpref=$2

echo 'producing .tped file...'
cat $infile | tail -n +2 | cut -f2- | sed 's/0/A/g' | sed 's/1/C/g' > tmp
cat $infile | tail -n +2 | cut -f1 | sed 's/,/_/' | sed 's/^/1\t/' | sed 's/$/\t0/' | nawk '{print $0 "\t" FNR}' > tmp_leader
paste tmp_leader tmp | sed 's/\t/ /g' > $outpref.tped

echo 'producing .tfam file...'
cat $infile | head -n 1 | cut -f2- | sed 's/\//_/g' | sed 's/\t/\n/g' | awk 'NR % 2 == 1' | awk '{ print $1 " " $1 }' | sed 's/$/ 0 0 1 1/' | head -n -1 > $outpref.tfam

plink --tfile $outpref --make-bed --out $outpref

rm tmp tmp_leader 
