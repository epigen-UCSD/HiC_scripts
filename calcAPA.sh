#!/bin/bash

source activate hic
workdir=/home/zhc268/scratch/juicer/work/
loopdir=${workdir}cicero_res_v2/
juicer_jar=/home/zhc268/data/software/juicer_github/CPU/common/juicer_tools.jar
############################################################
# make bined peak files for cicero results 
############################################################
## cat with score bins
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


## cat with score bins2: negative sets
cd $workdir 

for f in ${loopdir}*all.pgl
do
    echo $f
    f1=${f/all.pgl/m05_05.bedpe}
    f2=${f/all.pgl/m10_m05.bedpe}
    f3=${f/all.pgl/m15_m10.bedpe}
    f4=${f/all.pgl/m20_m15.bedpe}
    f5=${f/all.pgl/lt_m20.bedpe}
    awk -v OFS='\t' -v f1=$f1 -v f2=$f2 -v f3=$f3 -v f4=$f4 -v f5=$f5 '{if($7<-.2) {$7="0,255,0";print $0 > f5;}
        else if($7 < -.15) {$7="0,255,0";print $0 > f4;} else if($7< -.1){$7="0,255,0";print $0 > f3;}
        else if($7< -.05){$7="0,255,0";print $0 > f2;} else if($7<=0.05){$7="0,255,0";print $0 > f1;}}' $f
    ls  ${f/all.pgl/*bedpe} |grep -v prom |grep -v enh| xargs wc -l > ${f}.number.txt
    wc -l $f >> ${f}.number.txt && echo ${f}.number.txt && cat  ${f}.number.txt
done

## submit jobs 
for f in ${loopdir}*all.pgl
do
    echo $f
    f1=${f/all.pgl/m05_05.bedpe}
    f2=${f/all.pgl/m10_m05.bedpe}
    f3=${f/all.pgl/m15_m10.bedpe}
    f4=${f/all.pgl/m20_m15.bedpe}
    f5=${f/all.pgl/lt_m20.bedpe}
    for pf in $f1 $f2 $f3 $f4 $f5; do echo $pf; qsub -k oe -v peakfile=$pf  ./HiC_scripts/callAPA.pbs; done 
done

## randomize 200k from negative sets
N=100000
for f in ${loopdir}*m05_05.bedpe
do
    pf=${f/bedpe/r${N}.bedpe}
    echo $f,$pf
A    shuf -n $N $f > $pf
    wc -l $pf
    qsub -v peakfile=$pf  ./HiC_scripts/callAPA.pbs 
done


## submit jobs 
for f in ${loopdir}*all.pgl
do
    echo $f
    f1=${f/all.pgl/m05_05.bedpe}
    f2=${f/all.pgl/m10_m05.bedpe}
    f3=${f/all.pgl/m15_m10.bedpe}
    f4=${f/all.pgl/m20_m15.bedpe}
    f5=${f/all.pgl/lt_m20.bedpe}
    for pf in $f1 $f2 $f3 $f4 $f5; do echo $pf; qsub -k oe -v peakfile=$pf  ./HiC_scripts/callAPA.pbs; done 
done


## cat with annotation  
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

## cat with annotation add score

for f in ${loopdir}*anno.pgl
do
    echo $f
    f1=${f/anno.pgl/enh_enh.pgl}
    f2=${f/anno.pgl/prom_enh.pgl}
    f3=${f/anno.pgl/prom_prom.pgl}
    awk -v OFS='\t' -v f1=$f1 -v f2=$f2 -v f3=$f3 '{if($8=="\." && $9=="\.") {print $0 > f1;}
        else if($8!="\." && $9!="\.")  {print $0 > f3;}
        else{print $0 > f2;}}' $f

    ## add the bins 
    for ff in $f1 $f2 $f3
    do
        echo $ff
        ff2=${ff/05/05_10};ff2=${ff2/pgl/bedpe}
        ff3=${ff/05/10_15};ff3=${ff3/pgl/bedpe}
        ff4=${ff/05/15_20};ff4=${ff4/pgl/bedpe}
        ff5=${ff/05/gt_20};ff5=${ff5/pgl/bedpe}
        awk -v OFS='\t' -v f1=$ff1 -v f2=$ff2 -v f3=$ff3 -v f4=$ff4 -v f5=$ff5 '{if($7>.2) {$7="0,255,0";print $1,$2,$3,$4,$5,$6,$7 > f5;}
        else if($7 >.15) {$7="0,255,0";print $1,$2,$3,$4,$5,$6,$7 > f4;} else if($7>.1){$7="0,255,0";print $1,$2,$3,$4,$5,$6,$7 > f3;}
        else{$7="0,255,0";print $1,$2,$3,$4,$5,$6,$7 > f2;}}' $ff
        wc -l $ff2 $ff3 $ff4 $ff5  > ${ff}.number.txt
        wc -l $ff >> ${ff}.number.txt && echo ${ff}.number.txt && cat  ${ff}.number.txt

        ## submit job 
        for pf in $ff2 $ff3 $ff4 $ff5; do  qsub -k oe -v peakfile=$pf  ./HiC_scripts/callAPA.pbs; done 
    done
    
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


############################################################
# apa call - on 1000 resolution or 5000
############################################################
res=5000
sample=RMM_308_1_2_3
ls -1  ${loopdir}/beta_1_beta_2*filtered* ${loopdir}/beta_1_beta_2*[05].bedpe \
   ${loopdir}*[ls].bedpe |grep -v "_m[12]"| \
    while read peakfile
    do
        echo $peakfile
        java -jar $juicer_jar apa -u -r $res ${workdir}/${sample}/aligned/inter_30.hic $peakfile \
             ${workdir}/${sample}/apa/$(basename $peakfile) && rm -r ${workdir}/${sample}/apa/$(basename $peakfile)/${res}/*v* & sleep 1
    done


############################################################
# apa call - on 10000 resolution for beta cicero score > 0.05 
############################################################

cd $workdir 

for f in ${loopdir}beta*all.pgl
do
    echo $f
    f1=${f/all.pgl/gt_05.bedpe}
    awk -v OFS='\t' -v f1=$f1 '($7>.05) {$7="0,255,0";print $0}' $f > $f1
    wc -l $f1 >> ${f}.number.txt
done

for sample in RMM_308_1_2_3 RMM_307_1_2_3
do
    qsub -k oe -v peakfile=$f1,sample=$sample  ./HiC_scripts/callAPA.pbs
done

