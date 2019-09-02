#!/bin/bash
set -e

refpref=$1
stupref=$2
K=$3
k=$4
outpref=$5

vcf2geno=~/laser/vcf2geno/vcf2geno
trace=~/laser/trace

$vcf2geno --inVcf $refpref.vcf --out $refpref
$vcf2geno --inVcf $stupref.vcf --out $stupref
$trace -s $stupref.geno -g $refpref.geno -o $outpref -k $k -K $K
cat $outpref.ProPC.coord | tail -n +2 | cut -f2,7- > ${outpref}_tmp
cat ${outpref}_tmp | cut -d'_' -f-2 | paste - ${outpref}_tmp > ${outpref}_adp.pcs
cat $outpref.RefPC.coord | tail -n +2 | cut -f2- > ${outpref}_tmp
cat ${outpref}_tmp | cut -d'_' -f-2 | paste - ${outpref}_tmp > ${outpref}_ref.pcs
rm -f trace.conf
