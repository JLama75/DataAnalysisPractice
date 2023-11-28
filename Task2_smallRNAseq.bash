#!/bin/bash
#stomach
wget -O DonarB_stomach.bam  https://www.encodeproject.org/files/ENCFF367ONF/@@download/ENCFF367ONF.bam
wget -O DonarB_stomach.tsv	https://www.encodeproject.org/files/ENCFF683JSC/@@download/ENCFF683JSC.tsv

#Spleen
wget -O DonarA_spleen.bam https://www.encodeproject.org/files/ENCFF753TAP/@@download/ENCFF753TAP.bam
wget -O DonarA_spleen.tsv https://www.encodeproject.org/files/ENCFF604YLU/@@download/ENCFF604YLU.tsv

wget -O DonarB_spleen.bam https://www.encodeproject.org/files/ENCFF815CJE/@@download/ENCFF815CJE.bam
wget -O DonarB_spleen.tsv https://www.encodeproject.org/files/ENCFF612UEF/@@download/ENCFF612UEF.tsv


#Lung

wget -O DonarA_lung.bam https://www.encodeproject.org/files/ENCFF682BYZ/@@download/ENCFF682BYZ.bam
wget -O DonarA_lung.tsv https://www.encodeproject.org/files/ENCFF735XYK/@@download/ENCFF735XYK.tsv

wget -O DonarB_lung.bam https://www.encodeproject.org/files/ENCFF774EMQ/@@download/ENCFF774EMQ.bam
wget -O DonarB_lung.tsv https://www.encodeproject.org/files/ENCFF076NNR/@@download/ENCFF076NNR.tsv

#Colon
wget -O DonarA_colon.bam https://www.encodeproject.org/files/ENCFF636PCD/@@download/ENCFF636PCD.bam
wget -O DonarA_colon.tsv https://www.encodeproject.org/files/ENCFF875UFG/@@download/ENCFF875UFG.tsv

wget -O DonarB_colon.bam https://www.encodeproject.org/files/ENCFF329ENM/@@download/ENCFF329ENM.bam
wget -O DonarB_colon.tsv https://www.encodeproject.org/files/ENCFF366BBV/@@download/ENCFF366BBV.tsv

gzip DonarB_stomach.bam Donar*_spleen.bam Donar*_lung.bam Donar*_colon.bam

