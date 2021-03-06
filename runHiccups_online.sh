#!/bin/bash
#PBS -q condo
#PBS -N hiccup
#PBS -l nodes=1:ppn=24
#PBS -l walltime=8:00:00
#PBS -V
#PBS -m abe
#PBS -A epigen-group

# -v sample,chr

#set -x
#PS4='+\d+\t '
source activate hic
workdir=/home/zhc268/scratch/juicer/work/
module load cuda
export LD_PRELOAD=/usr/lib64/libcuda.so.1
hicfile=$1 #url
chr=$2 #11

juicer_jar=/home/zhc268/data/software/juicer_github/CPU/common/juicer_tools.jar
hic=$(basename $hicfile)
#hic="inter.hic"
#hicfile="${workdir}/${sample}/aligned/${hic}"
type=observed


# https://github.com/aidenlab/juicer/wiki/HiCCUPS, Medium resolution default setting 
matrixSize=512
normalization=KR
#chr=7
res="5000,10000,25000"
fdr=".1,.1,.1"
peak_width="4,2,1"
window="7,5,3"
thresholds="7,5,3"
centroid_distances="20000,20000,50000"
output="$(pwd)/${hic%.*}"

# Usage:   juicer_tools hiccups [-m matrixSize] [-k normalization (NONE/VC/VC_SQRT/KR)] [-c chromosome(s)] [-r resolution(s)] [-f fdr] [-p peak width] [-i window] [-t thresholds] [-d centroid distances] [--ignore_sparsity]<hicFile> <outputDirectory> [specified_loop_list]
cmd="/projects/ps-epigen/software/miniconda3/envs/bds_atac/bin/java -jar $juicer_jar hiccups  -m $matrixSize -k $normalization -c $chr -r $res -f $fdr -p $peak_width -i $window -t $thresholds -d $centroid_distances $hicfile $output" # --threads 20
echo $cmd                                                               
echo $cmd |bash 

