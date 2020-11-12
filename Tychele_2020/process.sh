#!/bin/bash
source activate hic
############################################################ 
# 1. Won_et_al
############################################################ 
## make folder
mkdir  ~/scratch/juicer/work/Tychele_2020
ln -s   ~/scratch/juicer/work/Tychele_2020 ./dataset
cd dataset/
mkdir Won_et_al
cd Won_et_al/

## SRA raw fastq download 
# conda install -c bioconda sra-tools
# link: SRP066745
for i in SRR2970466 SRR2970467 SRR2970468 SRR2973607 SRR2973608 SRR2973609; do echo -e "fasterq-dump --split-files $i";done

## hdf5 file
wget https://ftp.ncbi.nlm.nih.gov/geo/series/GSE77nnn/GSE77565/suppl/GSE77565_FBD_IC-heatmap-chr-10k.hdf5.gz
wget https://ftp.ncbi.nlm.nih.gov/geo/series/GSE77nnn/GSE77565/suppl/GSE77565_FBP_IC-heatmap-chr-10k.hdf5.gz

pip install hicexplorer

#https://hicexplorer.readthedocs.io/en/latest/content/tools/hicConvertFormat.html
hicConvertFormat --matrices GSE77565_FBD_IC-heatmap-chr-10k.hdf5.gz --outFileName \
                 FBD.10k.cool --inputFormat h5 --outputFormat cool --resolutions 10000


############################################################
# 2. Deng_ma et al 
############################################################
## makdir 
 mkdir deng_ma_et_al
cd deng_ma_et_al/
# https://data.4dnucleome.org/experiment-set-replicates/4DNESRWDFFF8/#processed-files
wget https://data.4dnucleome.org/files-processed/4DNFIQ48NYOW/@@download/4DNFIQ48NYOW.hic

## KR dump 
export PATH=/home/zhc268/github/HiC_scripts/:$PATH
scratch_folder=/oasis/tscc/scratch/zhc268/juicer/work/
mkdir -p $scratch_folder/DengMa/aligned
ln -s $(pwd)/4DNFIQ48NYOW.hic   $scratch_folder/DengMa/aligned/inter.hic
dumpKR.sh DengMa 7 25000

## hicupp
qsub -v sample=DengMa,chr=7 ./runHiccups.pbs
bash runHiccups.sh DengMa 7 
############################################################
# 3. Guo et al 
############################################################
mkdir guo_et_al  && cd  guo_et_al 

# link https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE71072
for i in SRR2106508 SRR2106509 SRR2106510 SRR2106511 SRR2106512 SRR2106513;do echo -e "fasterq-dump --split-files $i";done
#for i in SRR2106508 SRR2106509 SRR2106510 SRR2106511 SRR2106512 SRR2106513;do echo $i;prefetch --type fastq  $i;done
for i in SRR2106508 SRR2106509 SRR2106510 SRR2106511 SRR2106512 SRR2106513;do echo $i; fasterq-dump --split-files $i;done


cat *_1.fastq|gzip > GUO_R1.fastq.gz &
cat *_1.fastq|gzip > GUO_R2.fastq.gz &

## run processing 
scratch_folder=/oasis/tscc/scratch/zhc268/juicer/work/GUO
mkdir -p ${scratch_folder}/fastq
ln -s $(pwd)/GUO_R1.fastq.gz ${scratch_folder}/fastq/
ln -s $(pwd)/GUO_R2.fastq.gz ${scratch_folder}/fastq/
cd $scratch_folder; cd ..
qsub -v sample=GUO run.pbs
rsync -avzr $scratch_folder ~/data/outputs/HiC
qsub -v sample=GUO,chr=10 ./runHiccups.pbs
dumpKR.sh GUO 10 25000

############################################################
# 4. Bonev et al 
############################################################
## http://hicfiles.tc4ga.com/juicebox.properties
## __External_2017Bonev_EScells = __External_2017Bonev, ES cells, http://hicfiles.s3.amazonaws.com/external/bonev/ES_mapq30.hic
#__External_2017Bonev_NPC = __External_2017Bonev, Neural Progenitors, http://hicfiles.s3.amazonaws.com/external/bonev/NPC_mapq30.hic
#__External_2017Bonev_CN = __External_2017Bonev, Cortical Neurons, http://hicfiles.s3.amazonaws.com/external/bonev/CN_mapq30.hic

mkdir -p /home/zhc268/scratch/juicer/work/bonev
cd /home/zhc268/scratch/juicer/work/bonev
for url in http://hicfiles.s3.amazonaws.com/external/bonev/ES_mapq30.hic http://hicfiles.s3.amazonaws.com/external/bonev/NPC_mapq30.hic http://hicfiles.s3.amazonaws.com/external/bonev/CN_mapq30.hic
do
    echo $url 
    bash ~/github/HiC_scripts/runHiccups_online.sh $url 7
done


