#!/bin/bash

#SBATCH --job-name=timer
#SBATCH --time=02:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=8g
#SBATCH --array=0-1

#SBATCH --account=leeshawn
#### #SBATCH --account=jiankang
#SBATCH --output=log/%x-%A-%4a.log
#SBAtCH --partition=standard
#### #SBATCH --mail-user=daiweiz@umich.edu
#### #SBATCH --mail-type=BEGIN,END,FAIL

srun hostname
srun echo $SLURM_ARRAY_JOB_ID
srun echo $SLURM_ARRAY_TASK_ID
srun date

srun echo zero
srun let "i = $SLURM_ARRAY_TASK_ID % 5"
srun echo $i
srun let "n = 300 + i * 125"
srun echo $n
srun bash timer.sh $n

srun date
