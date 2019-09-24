#!/bin/bash
set -e

inpref=$1

plink --bfile ${inpref}_ref --family --write-cluster --out ${inpref}_ref
plink --bfile ${inpref}_ref --within ${inpref}_ref.clst --fst --out ${inpref}_ref
