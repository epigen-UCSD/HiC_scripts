#!/bin/bash
#PBS -q condo
#PBS -N callAPA  
#PBS -l nodes=1:ppn=8
#PBS -l mem=32gb
#PBS -l walltime=8:00:00
#PBS -V
#PBS -m abe
#PBS -A condo

set -x
PS4='+\d \t '
source activate hic
export _JAVA_OPTIONS="-Xmx30g"
res=25000
norm=KR
chr=11
workdir=/home/zhc268/scratch/juicer/work/
for SAMPLE in  RMM_307_1_2_3
do
    echo $SAMPLE
    hicfile=${workdir}${SAMPLE}/aligned/inter_30.hic    
    cd $workdir
    outdir=$workdir${SAMPLE}"/domain/"
    mkdir -p $outdir
    outfile=${outdir}chr${chr}_res${res}
    juicer_jar=/home/zhc268/data/software/juicer_github/CPU/common/juicer_tools.jar
    cmd="java -jar $juicer_jar arrowhead -c $chr -r $res --threads 16 -k $norm  $hicfile $outfile"
    echo $cmd
    echo $cmd|bash
done
