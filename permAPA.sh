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
sample=$1 #RMM_308_1_2_3
cd $workdir
N_PERM=1000
N_LOOPS=10000
RES_DIR=${workdir}${sample}/apa/perm_np${N_PERM}_nloops${N_LOOPS}/
mkdir -p $RES_DIR
TEMP_DIR=$(mktemp -d)
BASE_LOOPS=beta_1_beta_2.cicero_all.pgl
export _JAVA_OPTIONS="-Xmx1g"
juicer_jar=/home/zhc268/data/software/juicer_github/CPU/common/juicer_tools.jar

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
final_res=${loopdir}"/beta_perm_res_"${sample}".txt" 
cicero_res_file=${loopdir}"${BASE_LOOPS}"
cicero_res_bedpe=${TEMP_DIR}"/${BASE_LOOPS/pgl/bedpe}"
awk -v OFS='\t' '{$7="0,255,0";print $0}' $cicero_res_file >  $cicero_res_bedpe
0> $final_res
for seed in $(seq 1 $N_PERM)
do
    ## tmp file
    echo $seed
    tmp_loops=${RES_DIR}"beta_seed"_${seed}.bedpe
    shuf --random-source=<(get_seeded_random $seed)  -n $N_LOOPS $cicero_res_bedpe > $tmp_loops
    res_tmp_dir=${tmp_loops/.bedpe/}
    mkdir -p $res_tmp_dir
    res_tmp_apa=${res_tmp_dir}/10000/gw/rankAPA.txt
    java -jar $juicer_jar apa -u -r 10000 ${workdir}/${sample}/aligned/inter_30.hic $tmp_loops $res_tmp_dir 2>&1 1>/dev/null && \
        paste <(echo $seed)   <(awk -v FS=',' '(NR==11){print $11}' $res_tmp_apa) >> $final_res & sleep 1
    (( $seed %50 == 0 )) && wait 
done




