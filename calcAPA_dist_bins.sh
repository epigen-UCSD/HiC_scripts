#!/bin/bash
source activate hic

############################################################
# apa call - on distance bins 1. 300-500kb 2. 500-700kb, 3. 750kb-1Mb
############################################################
workdir=/home/zhc268/scratch/juicer/work/
loopdir=${workdir}cicero_res_v2/
sample=RMM_308_1_2_3
cd $workdir
TEMP_DIR=$(mktemp -d)
cicero_res_bedpe=${loopdir}'/beta_1_beta_2.cicero_gt_05.bedpe'
cicero_res_file=${loopdir}'/beta_1_beta_2.cicero_all.pgl'
awk -v OFS='\t' '($7>0.05){$7="0,255,0";print $0}' $cicero_res_file >  $cicero_res_bedpe


dist_record=${loopdir}'/test_distance_bins.txt'
> $dist_record

for loop_set in beta_1_beta_2.cicero_gt_05 greenwald_2019_loops islet_pcHiC.CHiCAGO_interactions.intrachromsomal
do
    loop_file=${loopdir}${loop_set}.bedpe
    ls $loop_file
    f1=${loop_file/bedpe/300k_500k.bedpe}
    f2=${loop_file/bedpe/500k_750k.bedpe}
    f3=${loop_file/bedpe/750k_1m.bedpe}
    f4=${loop_file/bedpe/lt_750k.bedpe}
    f5=${loop_file/bedpe/gt_1m.bedpe}
    echo $f1 $f2 $f3
    awk -v OFS='\t' -v f1=$f1 -v f2=$f2 -v f3=$f3 -v f4=$f4 -v f5=$f5 '{dist=sqrt(($2+$3-$5-$6)^2)/2;if(dist>=300000 && dist <500000) {print $0 > f1;}
        else if(dist>=500000 && dist <750000) {print $0 > f2;} else if(dist >=750000 && dist <= 1000000){print $0 > f3;} 
        else if(dist >100000){print $0 > f5;} else{print $0 > f4}}' $loop_file
    wc -l $f1 $f2 $f3 $f4 $f5 >> $dist_record
    wc -l $loop_file >> $dist_record
done
cat $dist_record

## call APA
#export _JAVA_OPTIONS="-Xmx2g"
juicer_jar=/home/zhc268/data/software/juicer_github/CPU/common/juicer_tools.jar
for loop_set in beta_1_beta_2.cicero_gt_05 greenwald_2019_loops islet_pcHiC.CHiCAGO_interactions.intrachromsomal
do
    loop_file=${loopdir}${loop_set}.bedpe
    ls $loop_file
    f1=${loop_file/bedpe/300k_500k.bedpe}
    f2=${loop_file/bedpe/500k_750k.bedpe}
    f3=${loop_file/bedpe/750k_1m.bedpe}
    for peakfile in $f1 $f2 $f3
    do
        echo $peakfile
        java -jar $juicer_jar apa -u -r 10000 ${workdir}/${sample}/aligned/inter_30.hic $peakfile \
             ${workdir}/${sample}/apa/$(basename $peakfile) && rm -r ${workdir}/${sample}/apa/$(basename $peakfile)/10000/*v* & sleep 1
    done
    wait 
done


