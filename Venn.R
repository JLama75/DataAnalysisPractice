#Generating Venn Diagram in R

setwd("~/Documents/Interview/Test")
library(VennDiagram)
library(ggplot2)
EP300 = 23343
CTCF = 51759
Enhancers = 19532
EP300_CTCF = 3984
CTCF_Enhancer = 2547
EP300_Enhancer = 6732
Enhancer_both = 896
Venn.plot <- draw.triple.venn(EP300, CTCF, Enhancers, EP300_CTCF, CTCF_Enhancer,
EP300_Enhancer, Enhancer_both,
category = c("EP300", "CTCF", "K562-enhancers"), color = "black")
