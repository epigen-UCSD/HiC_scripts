
# Datasets

## End points

1. `*.hic` files with reasonable high resolution (ideally 5Kb, 10Kb, and/or 25kb) that can be visualized with juicebox
2. matrix dump (`*.mat`) files for `chr10` (human) or `chr7` (mouse) for virtual 4C plots
3. `HICCUPS loop calls`, assuming these are relatively easy to generate once we have `*.hic` files. One note is that the interaction we are looking for is ~1.3MB, so if there is a distance cutoff we should make sure it's not shorter than 1.5Mb.

Note: Wherever replicates are available, we should merge them to maximize depth/resolution

## Here are the the datasets of interest:

a. Hi-C data from human fetal brain by [Won et al.](https://www.nature.com/articles/nature19847), with data files available [here](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE77565). We can merge 3 individuals for `GZ`, and merge 3 individuals for `CP`. It looks there is already processed 10Kb heat maps available in HDF5 format (`FBD` and `FBP`), which should be fine if can be converted to hic format.

b. DNase Hi-C data from Mouse adult brain by [Deng and Ma et al.](https://genomebiology.biomedcentral.com/articles/10.1186/s13059-015-0728-8#Sec10), with data files available through 4DN portal [here](https://data.4dnucleome.org/experiment-set-replicates/4DNESRWDFFF8/#processed-files). I note that these data are also included in the juicebox pre-loaded datasets under "open" --> "Hi-C data archive", so oviously `\*.hic` files are already available, but would still ask for your help with end-point items (2) and (3) above.

c. Hi-C data from the human SK-N-SH cell line by [Guo et al](https://pubmed.ncbi.nlm.nih.gov/26276636/), with data files available [here](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE71072). Need to re-process these (merging replicates).

### table

| dataset       | species | directory                                                | comment |
| ------------- | ------- | -------------------------------------------------------- | ------- |
| Won_et_al     | human   | `/oasis/tscc/scratch/zhc268/juicer/work/WON/`            | Only 2. |
| deng_ma_et_al | mouse   | `/oasis/tscc/scratch/zhc268/juicer/work/DengMa/aligned/` | 1,2,3,  |
| guo_et_al     | human   | `/oasis/tscc/scratch/zhc268/juicer/work/GUO/aligned/`    | 1,2,3   |

### Note on [Deng and Ma et al.](https://genomebiology.biomedcentral.com/articles/10.1186/s13059-015-0728-8#Sec10)

> **Hi-C reads mapping and pre-processing**

> Mapping and filtering of the reads, as well as normalization of experimental and intrinsic biases of Hi-C contact matrices, were conducted with the following method regardless of cell type to minimize potential variance in the data obtained from different platforms. We implemented hiclib (https://bitbucket.org/mirnylab/hiclib) to perform initial analysis on Hi-C data from mapping to filtering and bias correction. Briefly, quality analysis was performed using a phred score, and sequenced reads were mapped to hg19 human genome by Bowtie2 (with increased stringency, –score-min -L 0.6,0.2–very-sensitive) through iterative mapping. Read pairs were then allocated to HindIII restriction enzyme fragments. Self-ligated and unligated fragments, fragments from repeated regions of the genome, PCR artefacts, and genome assembly errors were removed. Filtered reads were binned at 10 kb, 40 kb, and 100 kb resolution to build a genome-wide contact matrix at a given bin size. Biases can be introduced to contact matrices by experimental procedures and intrinsic properties of the genome. To decompose biases from the contact matrix and yield a true contact probability map, filtered bins were subjected to iterative correction9, the basic assumption of which is that each locus has uniform coverage. _Bias correction and normalization results in a corrected heat map of bin-level resolution. 100-kb resolution bins were assessed for inter-chromosomal interactions, 40 kb for TAD analysis, and 10 kb for gene loop detection_.

In the end, only `10kb` heatmap data were used and extracted to `GSE77565_FBP_IC-heatmap-chr-10k.dump.chr10.csv` and `GSE77565_FBD_IC-heatmap-chr-10k.dump.chr10.csv`.

