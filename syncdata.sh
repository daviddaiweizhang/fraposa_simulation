#!/bin/bash
set -3

p=$1
 for n in `seq 300 125 800`; do
	 dname=data/n${n}s50p${p}
	 mkdir -p $dname
	 scp daiweiz@fantasia.sph.umich.edu:~/fraposa_simulation/$dname/*.pcs $dname
	 Rscript plot_pcs.R $dname/a
 done 
