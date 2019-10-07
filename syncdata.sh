#!/bin/bash
set -e

rsync -am -e ssh --progress --include='*.png' --include='*/' --exclude='*' daiweiz@snowwhite.sph.umich.edu:~/fraposa_simulation/data/ data/
