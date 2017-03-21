# steph to Isteph
library(rjson)
library(dplyr)

steph_convertor <- bind_rows(fromJSON(file='./input_data/steph_to_Isteph.json'))
steph_genes <- read.csv2('./input_data/astephensi_eg_gene_genes.csv')

Isteph_genes <- steph_convertor[match(steph_genes$ensembl_gene_id, steph_convertor$orth), ][, c(2, 4, 1, 5, 6)]

write.csv2(Isteph_genes, './input_data/Isteph_genes.csv', row.names = F, quote = F)

#  Select genes only from scaffold_00043
Isteph_genes <- as.data.frame(Isteph_genes)

scf_00043_genes <- na.omit(Isteph_genes[Isteph_genes$seqname == 'scaffold_00043',])

write.csv2(scf_00043_genes, './input_data/scf_00043_genes.csv', row.names = F, quote = F)
