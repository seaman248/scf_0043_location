library(biomaRt)
library(dplyr)

source('https://raw.githubusercontent.com/seaman248/An.-atroparvus-genome-comparison/compare_plot/R/Clean/functions/seq_num.R')

orths <- read.csv2('./input_data/un_table.csv')[, c(-1)]

HOST <- 'biomart.vectorbase.org'
BASE <- listMarts(host=HOST)$biomart[1]

all_fun_genes <- getBM(
  attributes=c('ensembl_gene_id','chromosome_name','start_position','end_position','strand', 'agambiae_eg_gene'),
  mart = useMart(
    BASE,
    host=HOST,
    dataset = 'afunestus_eg_gene'
  )
)

scf_0043_fun_genes <- all_fun_genes[match(orths$ensembl_gene_id.1, all_fun_genes$agambiae_eg_gene), ][, -ncol(all_fun_genes)]

orths <- na.omit(bind_cols(orths, scf_0043_fun_genes))
names(orths) <- unlist(lapply(c('steph', 'gam', 'fun'), function(sp){
  paste0(sp, '_', c('id', 'chr', 'start', 'end', 'strand'))
}))

# generate seq_num

orths[, c(8, 9)] <- seq_num(orths[, c(7, 8, 9)], chrs=c('3L', '2L', '2R'))
orths[, c(13, 14)] <- seq_num(orths[, c(12, 13, 14)], chrs = c('KB668333', 'KB668859', 'KB668805', 'KB668861', 'KB668931'))

write.csv2(orths, './input_data/un_table_fun.csv', row.names = F)
