#!/bin/bash

source activate hic
workdir=/home/zhc268/scratch/juicer/work/
loopdir=${workdir}cicero_res_v2/

############################################################
# make bined peak files for cicero results 
############################################################

cd $workdir 

for f in ${loopdir}*all.pgl
do
    echo $f
    f1=${f/all.pgl/lt_05.bedpe}
    f2=${f/all.pgl/05_10.bedpe}
    f3=${f/all.pgl/10_15.bedpe}
    f4=${f/all.pgl/15_20.bedpe}
    f5=${f/all.pgl/gt_20.bedpe}
    awk -v OFS='\t' -v f1=$f1 -v f2=$f2 -v f3=$f3 -v f4=$f4 -v f5=$f5 '{if($7>.2) {$7="0,255,0";print $0 > f5;}
        else if($7 >.15) {$7="0,255,0";print $0 > f4;} else if($7>.1){$7="0,255,0";print $0 > f3;}
        else if($7>.05){$7="0,255,0";print $0 > f2;}else{$7="0,255,0";print $0 > f1;}}' $f
done


## filter 
for f in ${loopdir}*anno.pgl
do
    echo $f
    f1=${f/anno.pgl/enh_enh.bedpe}
    f2=${f/anno.pgl/prom_enh.bedpe}
    f3=${f/anno.pgl/prom_prom.bedpe}
    awk -v OFS='\t' -v f1=$f1 -v f2=$f2 -v f3=$f3 '{if($8=="\." && $9=="\.") {$7="0,255,0";print $1,$2,$3,$4,$5,$6,$7 > f1;}
        else if($8!="\." && $9!="\.")  {$7="0,255,0";print $1,$2,$3,$4,$5,$6,$7 > f3;}
        else{$7="0,255,0";print $1,$2,$3,$4,$5,$6,$7 > f2;}}' $f
done


############################################################
# apa call - on all 
############################################################
export _JAVA_OPTIONS="-Xmx4g"
juicer_jar=/home/zhc268/data/software/juicer_github/CPU/common/juicer_tools.jar
workdir='/home/zhc268/scratch/juicer/work/'
loopdir=${workdir}cicero_res_v2/
for sample in   Islet RMM_307_1_2_3 RMM_308_1_2_3 #Islet
do
    echo $sample 
    for peakfile in ${loopdir}*o_05.*bedpe  #for peakfile in ${loopdir}*.bedpe
    do
        echo $peakfile
        mkdir -p ${workdir}/${sample}/apa/
        java -jar $juicer_jar apa -u -r 10000 ${workdir}/${sample}/aligned/inter_30.hic $peakfile \
             ${workdir}/${sample}/apa/$(basename $peakfile) && rm -r ${workdir}/${sample}/apa/$(basename $peakfile)/10000/*v* & sleep 1
    done
    wait 
done



