#!/bin/bash

n=$1
outfile=$2

K=2 # sidelength of grid
M=100 # migration rate
L=100 # number of loci in a genealogy
G=1000 # number of independent genealogies
let "C = $n * 2" # number of haplid samples per center
ggs=~/ggs/ggs

if [ -s "$outfile" ]; then
    echo "using existing $outfile"
else
    $ggs -K $K -c $C -M $M -G $G -L $L -o $outfile
fi
