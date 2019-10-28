#!/bin/bash
set -x
PS4='+\t '
source activate scanpy
cd cecero_islet

cicerofile=beta.cicero_coaccess_05.in_peak.pgl
clodius aggregate bedpe \
        --assembly hg19 \
        --chr1-col 1 --from1-col 2 --to1-col 3 \
        --chr2-col 4 --from2-col 5 --to2-col 6 \
        --output-file ${cicerofile/pgl/multires} \
            $cicerofile
