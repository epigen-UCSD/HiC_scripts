#!/bin/bash
#set -x
#PS4='+\d+\t '
source activate hic
workdir=/home/zhc268/scratch/juicer/work/
sample=$1 #RMM_308_1_2_3
chr=$2 #11
binsize=$3 
juicer_jar=/home/zhc268/data/software/juicer_github/CPU/common/juicer_tools.jar
hic="inter.hic"
hicfile="${workdir}/${sample}/aligned/${hic}"
type=observed
output="${workdir}/${sample}/aligned/${hic}.${type}.KR.${chr}_${chr}.bsz${binsize}.txt"
#cmd="java -jar $juicer_jar dump $type KR $hicfile $chr $chr  BP $binsize $output"
#echo -e $cmd |bash
/projects/ps-epigen/software/miniconda3/envs/bds_atac/bin/java -jar $juicer_jar dump $type KR $hicfile $chr $chr  BP $binsize $output
