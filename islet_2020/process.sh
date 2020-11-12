#!/bin/bash

## processing scripts for Islet project

############################################################
## run mega.sh
############################################################


echo  RMM_307_1_2_3 RMM_308_1_2_3 RMM_384_1_2 > rmm_307_308_384.txt
qsub -k oe -v sample_file=$(pwd)/rmm_307_308_384.txt ./runMega.pbs


## process endoC 
mkdir -p islet_endoC/fastq

cat endoC/fastq/*_R1.fastq.gz > islet_endoC/fastq/islet_endoC_R1.fastq.gz &
cat endoC/fastq/*_R2.fastq.gz > islet_endoC/fastq/islet_endoC_R2.fastq.gz & 
