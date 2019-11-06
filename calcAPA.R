#!/usr/bin/env Rscript

suppressMessages(require(optparse))
suppressMessages(require(data.table))
suppressMessages(require(magrittr))
option_list = list(
    make_option(c("-i", "--input_res"), type="character", default=NULL,
                help="apa results file", metavar="character"),
    make_option(c("-c", "--corner_size"), type="integer", default=6,
                help="corner size [default=%default]",metavar="number")
);

opt_parser = OptionParser(option_list=option_list);
opt = parse_args(opt_parser)


###############################################################
##main
###############################################################
corner_size <- opt$corner_size
input_res <- opt$input_res
input_res_apa <- fread( paste0("cat ", input_res, "|sed 's/\\]//g;s/\\[//g'"))

dat <- c(input_res_apa[[11, 11]], input_res_apa[(21 - corner_size + 1):21, 1:corner_size] %>%
                                  as.matrix %>% as.vector)
zscore <- (dat[1] - mean(dat[-1]))/sd(dat[-1])

apa <- dat[1]/mean(dat[-1])
cat(apa, "\t", zscore, "\n")


