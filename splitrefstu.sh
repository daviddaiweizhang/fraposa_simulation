#!/bin/bash
set -e

inpref=$1
nstu=$2
seed=123

get_seeded_random()
{
    seed="$1"
    openssl enc -aes-256-ctr -pass pass:"$seed" -nosalt </dev/zero 2>/dev/null
}

cat $inpref.fam | shuf --random-source=<(get_seeded_random $seed) > ${inpref}_tmp
cat ${inpref}_tmp | head -n $nstu > ${inpref}_tmp_stu
plink --bfile $inpref --keep-allele-order --keep ${inpref}_tmp_stu --make-bed --out ${inpref}_stu
plink --bfile $inpref --keep-allele-order --remove ${inpref}_tmp_stu --make-bed --out ${inpref}_ref
plink --bfile ${inpref}_stu --keep-allele-order --recode vcf-iid --out ${inpref}_stu
plink --bfile ${inpref}_ref --keep-allele-order --recode vcf-iid --out ${inpref}_ref

rm ${inpref}_tmp ${inpref}_tmp_stu
