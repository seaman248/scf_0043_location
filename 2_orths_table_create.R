library(dplyr)

scf_00043_genes <- read.csv2('./input_data/scf_00043_genes.csv')
gam_genes <- read.csv2('./input_data/agambiae_eg_gene_genes.csv')
orths <- read.csv2('./input_data/orths.csv')

names(scf_00043_genes) <- names(gam_genes)
names(orths) <- c('steph', 'gam')

scf_00043_starts <- max(scf_00043_genes$end_position) - scf_00043_genes$start_position
scf_00043_ends <- max(scf_00043_genes$end_position) -  scf_00043_genes$end_position

scf_00043_genes[, c(3, 4)] <- data.frame(scf_00043_starts, scf_00043_ends)
# which 00043 genes in gambiae?

scf_00043_gam_genes <- orths[match(scf_00043_genes$ensembl_gene_id, orths$steph),]$gam

scf_00043_gam_genes <- gam_genes[match(scf_00043_gam_genes, gam_genes$ensembl_gene_id), ]

un_table <- na.omit(bind_cols(scf_00043_genes, scf_00043_gam_genes))

un_table <- un_table[un_table[, 7] != 'UNKN' & un_table[, 7] != 'X' & un_table[, 6] != 'AGAP002508' & un_table[, 6] != 'AGAP010741', ]
write.csv2(un_table, './input_data/un_table.csv')
