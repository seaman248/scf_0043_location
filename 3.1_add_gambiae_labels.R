library(biomaRt)
gam_ids <- read.csv2('./input_data/un_table_fun.csv')$gam_id

HOST <- 'biomart.vectorbase.org'
BASE <- listMarts(host=HOST)$biomart[1]

all_alb_genes <- getBM(
  attributes=c('ensembl_gene_id','chromosome_name','start_position','end_position','strand', 'agambiae_eg_gene'),
  mart = useMart(
    BASE,
    host=HOST,
    dataset = 'aalbimanus_eg_gene'
  )
)

all_alb_genes <- filter(all_alb_genes, chromosome_name != c('KB672410'), ensembl_gene_id != c('AALB008787', 'AALB008786'))

scf_0043_alb_genes <- all_alb_genes[match(gam_ids, all_alb_genes$agambiae_eg_gene), ][, 1:5]

un_table_fun_alb <- na.omit(bind_cols(read.csv2('./input_data/un_table_fun.csv'), scf_0043_alb_genes))

write.csv2(un_table_fun_alb, './input_data/un_table_fun_alb.csv', row.names = F)
