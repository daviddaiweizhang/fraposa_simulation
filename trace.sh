#!/bin/bash
set -e

refpref=$1
stupref=$2
K=$3
k=$4
outpref=$5
coordpref=$6

vcf2geno=~/laser/vcf2geno/vcf2geno
trace=~/laser/trace

# convert plink --> vcf --> trace
plink --bfile $refpref --keep-allele-order --recode vcf --out $refpref
plink --bfile $stupref --keep-allele-order --recode vcf --out $stupref
awk '{ print $1 "_" $2 "\t" $1 "\t" $2 }' $refpref.fam > ${outpref}_tmp 
$vcf2geno --inVcf $refpref.vcf --out $refpref --updateID ${outpref}_tmp
awk '{ print $1 "_" $2 "\t" $1 "\t" $2 }' $stupref.fam > ${outpref}_tmp 
$vcf2geno --inVcf $stupref.vcf --out $stupref --updateID ${outpref}_tmp 

# run trace
$trace -s $stupref.geno -g $refpref.geno -o $outpref -k $k -K $K -c $coordpref.coord
cat $outpref.ProPC.coord | tail -n +2 | cut -f1,2,7- > ${outpref}.pcs

rm -f trace.conf
