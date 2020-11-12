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

# https://zaiste.net/posts/how-to-join-elements-of-array-bash/
function join { local IFS="$1"; shift; echo "$*"; }
############################################################
## handle sample_files 1) pipe 2) file
############################################################
if [ -p /dev/stdin ]; then
    echo "samples are provided as pipes"
    # If we want to read the input line by line
    all_samples=($(while  read line; do
        echo  ${line}
    done))
else
    sample_file=$1 # space seperated samples
    echo "samples are provided as file: $sample_file"
    all_samples=(cat $sample_file)
fi

stage=$2
############################################################
## prepare folder: symbolic link element sample to this folder
############################################################
output_dir=$(join _ ${all_samples[@]})
echo "prepare the mega folder $output_dir"

#echo $output_dir
mkdir -p /home/zhc268/scratch/juicer/work/${output_dir}
cd  /home/zhc268/scratch/juicer/work/${output_dir}


for i in ${all_samples[@]};do
    ln -sf /home/zhc268/scratch/juicer/work/$i ./
done

echo "run the mega.sh"
[[ ! -z "$stage" ]] && stage_opt="-S $stage" 
../../scripts/common/mega.sh -D ../../ $stage_opt

#rsync -avzru /home/zhc268/scratch/juicer/work/${sample} ~/data/outputs/juicer/
