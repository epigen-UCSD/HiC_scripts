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

| dataset       | species |
| ------------- | ------- |
| Won_et_al     | human   |
| deng_ma_et_al | mouse   |
| guo_et_al     | human   |
