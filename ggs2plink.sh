#!/bin/bash
set -e

infile=$1
outpref=$2
thincount=$3
seed=123

echo 'producing .tped file...'
cat $infile | tail -n +2 | cut -f2- | sed 's/0/A/g' | sed 's/1/C/g' > ${outpref}_tmp
cat $infile | tail -n +2 | cut -f1 | sed 's/,/_/' | sed 's/^/1\t/' | sed 's/$/\t0/' | nawk '{print $0 "\t" FNR}' > ${outpref}_tmp_leader
paste ${outpref}_tmp_leader ${outpref}_tmp | sed 's/\t/ /g' > $outpref.tped

echo 'producing .tfam file...'
cat $infile | head -n 1 | cut -f2- | sed 's/\//_/g' | sed 's/\t/\n/g' | awk 'NR % 2 == 1' > ${outpref}_tmp_iid
cat ${outpref}_tmp_iid | cut -d'_' -f1,2 > ${outpref}_tmp_fid
paste ${outpref}_tmp_fid ${outpref}_tmp_iid | sed 's/$/ 0 0 1 1/' | head -n -1 > $outpref.tfam

if [ "$thincount" == 0 ]; then
    plink --tfile $outpref --make-bed --out $outpref
else
    plink --seed $seed --tfile $outpref --thin-count $thincount --make-bed --out $outpref
fi

rm ${outpref}_tmp ${outpref}_tmp_leader 
