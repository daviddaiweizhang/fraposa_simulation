#!/bin/bash
set -e

inpref=$1
nstu=$2

cat $inpref.fam | sort -R > tmp
cat tmp | head -n $nstu > tmp_stu
plink --bfile $inpref --keep-allele-order --keep tmp_stu --make-bed --out ${inpref}_stu
plink --bfile $inpref --keep-allele-order --remove tmp_stu --make-bed --out ${inpref}_ref
plink --bfile ${inpref}_stu --keep-allele-order --recode vcf-iid --out ${inpref}_stu
plink --bfile ${inpref}_ref --keep-allele-order --recode vcf-iid --out ${inpref}_ref

rm tmp tmp_stu
