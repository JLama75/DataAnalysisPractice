#!/bin/bash

#Intersecting EP300 and CTCF ChIP-seq peaks with enhancers

for file in *.bed.gz
do

NAMES=$(echo "$file" | cut -d . -f 1 )    
echo  -e "\n processing $file"
echo processed $file names into $NAMES 

echo extracting the chromosomal positions ...
zcat ${NAMES}.bed.gz | awk '{print $1, $2, $3}' | sort -k1,1 -k2,2n > ${NAMES}.bed

echo fixing bed with tab-delimited format ...
awk '{$1=$1}1' OFS="\t"  ${NAMES}.bed >  ${NAMES}_sorted.bed
rm ${NAMES}.bed

done

#Finding overlaps
echo -e  "\n Finding overlaps... \n "
#Calculating total no. of peaks
echo calculating total no. of peaks
Total_ep300="$(cat EP300_sorted.bed | wc -l)" #23343
echo ${Total_ep300}
Total_ctcf="$(cat CTCF_sorted.bed | wc -l)" #51759
echo ${Total_ctcf}
Total_enhancer="$(cat K562_Enhancers_sorted.bed | wc -l)" #19532
echo ${Total_enhancer}

echo -e "Calculating overlaps... \n"

#1. EP300 peaks overlapping with the enhancers. 
bedtools intersect -a EP300_sorted.bed -b K562_Enhancers_sorted.bed -wa -u > Ep300_overlap_unique.bed
Overlap="$(wc -l < Ep300_overlap_unique.bed)"
echo -e "No. of unique EP300 overlap is: ${Overlap}"
#Calculating percentage
PercentOverlap=$((Overlap * 100 / Total_ep300))
echo -e "PercentOverlap: ${PercentOverlap}\n"

#2. Enhancer peaks overlapping E300 peaks
bedtools intersect -a K562_Enhancers_sorted.bed -b EP300_sorted.bed -wa -u > Enhancer_Ep300_overlap.bed
Overlap="$(wc -l < Enhancer_Ep300_overlap.bed)"
echo -e "No. of unique enhancer overlap to EP300 is: ${Overlap}"
#Calculating percentage
PercentOverlap=$((Overlap * 100 / Total_enhancer))
echo -e "PercentOverlap: ${PercentOverlap}\n"


#3. CTCF peaks overlapping with the enhancers. 
bedtools intersect -a CTCF_sorted.bed -b K562_Enhancers_sorted.bed -wa -u > CTCF_overlap.bed
Overlap="$(wc -l < CTCF_overlap.bed)"
echo -e "No. of unique CTCF overlap is: ${Overlap}"
#Calculating percentage
PercentOverlap=$((Overlap * 100 / Total_ctcf))
echo -e "PercentOverlap: ${PercentOverlap}\n"


#4. Enhancer peaks overlapping E300 peaks
bedtools intersect -a K562_Enhancers_sorted.bed -b CTCF_sorted.bed -wa -u > Enhancer_CTCF_overlap.bed
Overlap="$(wc -l < Enhancer_CTCF_overlap.bed)"
echo -e "No. of unique enhancer overlap to CTCF is: ${Overlap}"
#Calculating percentage
PercentOverlap=$((Overlap * 100 / Total_enhancer))
echo -e "PercentOverlap: ${PercentOverlap}\n"


#5. Enhancer peaks overlapping E300 peaks
awk 'NR==FNR{a[$1,$2,$3];next} ($1,$2,$3) in a' Enhancer_Ep300_overlap.bed Enhancer_CTCF_overlap.bed > Enhancer_both_overlap.bed
Overlap="$(wc -l < Enhancer_both_overlap.bed)"
echo -e "No. of unique enhancer overlap to both is: ${Overlap}"
#Calculating percentage
PercentOverlap=$((Overlap * 100 / Total_enhancer))
echo -e "PercentOverlap: ${PercentOverlap}\n"


######################################################################
#To generate a Venn Diagram using R
