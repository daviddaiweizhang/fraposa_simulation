#!/bin/bash
set -e

inpref=$1

plink --bfile ${inpref} --freq --out ${inpref}
echo $inpref
cat $inpref.frq | awk '{ print $5 }' | tail -n +2 | Rscript -e 'x=scan("stdin"); png("'"$inpref"'_maf.png", 1000, 1000); par(cex=2); hist(x, breaks=seq(0.0, 0.5, 0.05), main="MAF for simulation study"); dev.off'
