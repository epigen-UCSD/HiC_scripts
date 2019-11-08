#!/bin/bash
#############################################################
# permutate all cicero loops to get a null distribution
# for rankAPA/APA scores and center values
# input: 1. N_PERM: number of permutation, 2 N_LOOPS number of loops 
#        in each permutation
# output: 1. random seed for each perm
#         2. rankAPA score  3. center rankAPA value 
#############################################################
source activate hic
workdir=/home/zhc268/scratch/juicer/work/
loopdir=${workdir}cicero_res_v2/
sample=RMM_308_1_2_3
cd $workdir
N_PERM=1000
N_LOOPS=10000

#############################################################
# https://www.gnu.org/software/coreutils/manual/html_node/Random-sources.html
############################################################
get_seeded_random()
{
    seed="$1"
    openssl enc -aes-256-ctr -pass pass:"$seed" -nosalt \
            </dev/zero 2>/dev/null
}



############################################################
# main
############################################################
N_PERM=1000
TEMP_DIR=$(mktemp -d)
final_res=${loopdir}"/beta_perm_res.txt" 
export _JAVA_OPTIONS="-Xmx1g"
juicer_jar=/home/zhc268/data/software/juicer_github/CPU/common/juicer_tools.jar
cicero_res_file=${loopdir}'/beta_1_beta_2.cicero_all.pgl'
cicero_res_bedpe=${TEMP_DIR}'/beta_1_beta_2.cicero_all.bedpe'
awk -v OFS='\t' '{$7="0,255,0";print $0}' $cicero_res_file >  $cicero_res_bedpe
> $final_res
for seed in $(seq 1 $N_PERM)
do
    ## tmp file
    echo $seed
    tmp_loops=${TEMP_DIR}/"beta_r"${N_LOOPS}"_"${seed}.bedpe
    shuf --random-source=<(get_seeded_random $seed)  -n $N_LOOPS $cicero_res_bedpe > $tmp_loops
    res_tmp_dir=$(mktemp -d)
    res_tmp_apa=${res_tmp_dir}/10000/gw/rankAPA.txt
    java -jar $juicer_jar apa -u -r 10000 ${workdir}/${sample}/aligned/inter_30.hic $tmp_loops $res_tmp_dir 2>&1 1>/dev/null && \
        paste <(echo $seed)   <(awk -v FS=',' '(NR==11){print $11}' $res_tmp_apa) >> $final_res & sleep 1
    (( $seed %50 == 0 )) && wait 
done




