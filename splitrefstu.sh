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
rm -f ${inpref}_tmp_stu
for popu in `cat ${inpref}_tmp | cut -d' ' -f1 | sort | uniq`; do
    cat ${inpref}_tmp | awk -F' ' -v popu="$popu" '$1 == popu' | head -n $nstu >> ${inpref}_tmp_stu
done
plink --bfile $inpref --keep-allele-order --keep ${inpref}_tmp_stu --make-bed --out ${inpref}_stu
plink --bfile $inpref --keep-allele-order --remove ${inpref}_tmp_stu --make-bed --out ${inpref}_ref
plink --bfile ${inpref}_stu --keep-allele-order --recode vcf-iid --out ${inpref}_stu
plink --bfile ${inpref}_ref --keep-allele-order --recode vcf-iid --out ${inpref}_ref

rm ${inpref}_tmp ${inpref}_tmp_stu
