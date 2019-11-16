require(ggplot2)
require(data.table)
require(tidyverse)
require(parallel)

getCenter <- function(loop_file, res = 10000,sample='RMM_308_1_2_3') {
    (apa_file <- paste0(sample, "/apa/", loop_file, "/", res, "/gw/rankAPA.txt"))
    if (file.exists(apa_file)) {
        return(fread(cmd = paste0("cat ", apa_file, "|sed 's/\\]//g;s/\\[//g'"))[[11, 
            11]])
    } else {
        return(NA)
    }
    
}

calcAPA <- function(loop_file, res = 10000, corner_size = 6, type = "rankAPA",sample='RMM_308_1_2_3') {
    input_res <- paste0(sample, "/apa/", loop_file, "/", res, "/gw/", type, ".txt")
    if (file.exists(input_res)) {
        input_res_apa <- fread(cmd = paste0("cat ", input_res, "|sed 's/\\]//g;s/\\[//g'"))
        
        dat <- c(input_res_apa[[11, 11]], input_res_apa[(21 - corner_size + 1):21, 
            1:corner_size] %>% as.matrix %>% as.vector)
        # zscore <- (dat[1] - mean(dat[-1]))/sd(dat[-1])
        apa <- dat[1]/mean(dat[-1])
        return(apa)
        # return(data.frame(APA = apa, Zscore = zscore))
        
    } else {
        return(NA)
    }  #return(data.frame(APA = NA, Zscore = NA)))
}
getAPApng <- function(idx, res = 10000, corner_size = 6, type = "rankAPA") {
    apa_file <- paste0(sample, "/apa/", loop_stats$loop_file[idx], "/", res, "/gw/", 
        type, ".png")
    names(apa_file) <- loop_stats$loop_set[idx]
    if (file.exists(apa_file)) {
        return(apa_file)
    } else {
        return(NA)
    }
}

samples <- c("RMM_307_1_2_3","RMM_308_1_2_3")
names(samples) <- c("glucose_low","glucose_high") 