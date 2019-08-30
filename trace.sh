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
# TODO: take care of reference alleles
