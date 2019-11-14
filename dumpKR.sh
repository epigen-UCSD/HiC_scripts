#!/bin/bash
source activate hic
workdir=/home/zhc268/scratch/juicer/work/
sample=RMM_308_1_2_3
juicer_jar=/home/zhc268/data/software/juicer_github/CPU/common/juicer_tools.jar
hic="inter_30.hic"
hicfile="${workdir}/${sample}/aligned/${hic}"
chr1=11
chr2=11
binsize=25000
type=observed
output="${workdir}/${sample}/aligned/${hic}.${type}.KR.${chr1}_${chr2}.bsz${binsize}.txt"
cmd="java -jar $juicer_jar dump $type KR $hicfile $chr1 $chr2  BP $binsize $output"
echo -e $cmd |bash
