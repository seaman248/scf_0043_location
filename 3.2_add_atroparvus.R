library(biomaRt)
un_table_fun <- read.csv2('./input_data/un_table_fun.csv')
gam_ids <- filter(un_table_fun, gam_chr == c('2L', '2R'))$gam_id


HOST <- 'biomart.vectorbase.org'
BASE <- listMarts(host=HOST)$biomart[1]

all_atr_genes <- getBM(
  attributes=c('ensembl_gene_id','chromosome_name','start_position','end_position','strand', 'agambiae_eg_gene'),
  mart = useMart(
    BASE,
    host=HOST,
    dataset = 'aepiroticus_eg_gene'
  )
)

scf_0043_atr_genes <- all_atr_genes[match(gam_ids, all_atr_genes$agambiae_eg_gene), ]

scfs <- as.data.frame(table(scf_0043_atr_genes$chromosome_name))[, 1]
print(scfs)
lapply(scfs, function(scf){
  k <- un_table_fun[match(scf_0043_atr_genes$agambiae_eg_gene[scf_0043_atr_genes$chromosome_name==scf], un_table_fun$gam_id),]$gam_chr
  unique(as.character(k))
})
