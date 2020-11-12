#!/bin/bash
#PBS -q hotel
#PBS -N runMega
#PBS -l nodes=1:ppn=24
#PBS -l mem=128g
#PBS -l walltime=96:00:00
#PBS -V
#PBS -m abe
#PBS -A epigen-group


source activate hic
export PATH=/projects/ps-epigen/software/miniconda3/envs/scanpy/bin/:$PATH
set -x
PS4='+\d+\t '
#export _JAVA_OPTIONS=-Xmx16384m
export IBM_JAVA_OPTIONS="-Xmx120g -Xgcthreads1"
export _JAVA_OPTIONS="-Xmx120g -Xms120g"

outputdir=$1

### input 
juiceDir=/home/zhc268/scratch/juicer/scripts/common
${juiceDir}/juicer_tools pre  -q 1 $outputdir/merged_nodups.txt $outputdir/inter.hic hg19



