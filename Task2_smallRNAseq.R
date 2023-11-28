#Rcode for XIST expression dot plot and PCA plot

setwd("/local/workdir/jl3285/TrainingTest/Task2")
library(tidyverse)
library(ggfortify)
library(ggplot2)

#uploading the samples
upload_tsv <- function(file_path) {
  name <- sub("\\.tsv", "", file_path) #DonarA_stomach
  data <- read.table(file_path, header = TRUE)
  data <- data[,c(1,5,6)]
  colnames(data) <- c("gene_id", paste0(name, "_Count"),paste0(name, "_TPM"))
  return(data)
}

#Opening samnples and creating objects
Tissue <- c("stomach", "spleen", "lung", "colon")
Donar <- c("DonarA", "DonarB")
for(tissue in Tissue) {
  pattern2=".tsv"
  
  for(d in Donar) { 
    object_name <- paste(d, tissue, sep = "_") #DonarA_stomach
    filename <- paste0(paste(d, tissue, sep = "_"), pattern2) #DonarA_stomach.tsv
    assign(object_name, upload_tsv(filename))  #calls the function upload_excel() to upload the files
    
  }
}

#Merging all samples
All_tissues <- merge(DonarA_stomach[,c(1,3)], DonarB_stomach[,c(1,3)], by ="gene_id")
All_tissues <- merge(All_tissues, DonarA_spleen[,c(1,3)], by ="gene_id")
All_tissues <- merge(All_tissues, DonarB_spleen[,c(1,3)], by ="gene_id")
All_tissues <- merge(All_tissues, DonarA_lung[,c(1,3)], by ="gene_id")
All_tissues <- merge(All_tissues, DonarB_lung[,c(1,3)], by ="gene_id")
All_tissues <- merge(All_tissues, DonarA_colon[,c(1,3)], by ="gene_id")
All_tissues <- merge(All_tissues, DonarB_colon[,c(1,3)], by ="gene_id")


#Extracting expression of XIST 
Xist <- subset(All_tissues, gene_id == "ENSG00000229807.11")
Xist <- Xist[,-1] 
rownames(Xist) <- "TPM"
Xist <- t(Xist) %>% data.frame() 
Xist$Sample <- rownames(Xist)
split_values <- strsplit(Xist$Sample, "_")
Xist$Donor <- sapply(split_values, function(x) x[1])
Xist$Tissue <- sapply(split_values, function(x) x[2])
Xist <- Xist[order(Xist$Donor), ]

# Reorder and relabel the "Sample" column
Xist$Sample <- factor(Xist$Sample, levels = unique(Xist$Sample))
Sample_order <- c("DonarA_stomach", "DonarA_spleen", "DonarA_lung", "DonarA_colon", "DonarB_stomach", "DonarB_spleen", "DonarB_lung", "DonarB_colon")
Xist$Sample  <- factor(Xist$Sample, labels= Sample_order)

mynamestheme <- theme(plot.title = element_text(family = "Helvetica", size = (25), hjust = 0.5), 
                      legend.title = element_blank(), 
                      axis.title = element_text(family = "Helvetica", size = (20), colour = "black"),
                      axis.text = element_text(family = "Helvetica", colour = "black", size = (16)))

ggplot(Xist, aes(x = Tissue, colour = Donor, y = TPM)) + geom_point(size = 4) +
  labs(y = 'TPM', title = 'Xist expression', x = '') + scale_y_continuous(breaks=seq(0,65,by=15)) +
  theme_bw() + mynamestheme 

#Generating PCA plot 

#Spike in normalization 
SpikeIn <- All_tissues[grep("gSpikein_ERCC", All_tissues$gene_id),]

#Removing spike in
All_tissues <- subset(All_tissues, !grepl("gSpikein_ERCC", gene_id))
A <- All_tissues
rownames(A) <- A$gene_id
rownames(SpikeIn) <- SpikeIn$gene_id
SpikeIn <- SpikeIn[,-1]
SpikeInMean <- colMeans(SpikeIn) %>% data.frame() %>% t()
#Normalization perfomed using spike-in 
df <- A[,-1]/as.vector(SpikeInMean)

#Creating metadat with sample Informations
sampleInfo <- data.frame(Sample = colnames(A))
split_values <- strsplit(sampleInfo$Sample, "_")
sampleInfo$Donor <-  sapply(split_values, function(x) x[1])
sampleInfo$Tissue <-  sapply(split_values, function(x) x[2])
sampleInfo <- sampleInfo[-1,]

# Perform PCA
df <- t(df)
df.pca <- prcomp(df)
str(df.pca)

PCA_plot <- autoplot(df.pca, data = sampleInfo, colour = "Donor", shape = "Tissue", size =5)
PCA_plot + theme_bw() + mynamestheme 
