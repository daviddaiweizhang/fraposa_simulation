#!/bin/bash
set -e

pat=$1
rsync -am -e ssh --progress --include="$pat" --include='*/' --exclude='*' daiweiz@snowwhite.sph.umich.edu:~/fraposa_simulation/data/ data/
