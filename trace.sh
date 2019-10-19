#!/bin/bash
set -e

refpref=$1
stupref=$2
K=$3
k=$4
outpref=$5
coordpref=$6

vcf2geno=vcf2geno
trace=trace

# convert plink --> vcf --> trace
for pref in $refpref $stupref; do
    if [[ -f ${pref}.geno && -f ${pref}.site ]]; then
        echo Using existing files: "${pref}.geno, ${pref}.site"
    else
        echo Files not found: "${pref}.geno, ${pref}.site"
        plink --bfile $pref --keep-allele-order --recode vcf --out $pref
        awk '{ print $1 "_" $2 "\t" $1 "\t" $2 }' $pref.fam > ${outpref}_tmp 
        $vcf2geno --inVcf $pref.vcf --out $pref --updateID ${outpref}_tmp
    fi
done

# convert ref pcs to coord file
n_pcs=`head -n1 $coordpref.pcs | cut -f3- | wc -w`
cat <( echo -e 'popID\nindivID' ) <( seq 1 $n_pcs | sed 's/^/PC/' ) | tr '\n' '\t' | sed 's/.$/\n/' | cat - $coordpref.pcs > $coordpref.coord

# run trace
$trace -s $stupref.geno -g $refpref.geno -o $outpref -k $k -K $K -c $coordpref.coord
cat $outpref.ProPC.coord | tail -n +2 | cut -f1,2,7- > ${outpref}.pcs

rm -f trace.conf
