#!/bin/bash
#PBS -q hotel
#PBS -N juicer  
#PBS -l nodes=1:ppn=24
#PBS -l mem=128g
#PBS -l walltime=24:00:00
#PBS -V
#PBS -m abe
#PBS -A epigen-group

sample=$1
stage=$2

source activate hic

[[ ! -z "$stage" ]] && stage_opt="-S $stage" 

cd /home/zhc268/scratch/juicer/work/${sample}
../../scripts/juicer.sh -D ../../ $stage_opt

#rsync -avzru /home/zhc268/scratch/juicer/work/${sample} ~/data/outputs/juicer/
