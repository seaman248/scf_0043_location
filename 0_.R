# load the data
library(biomaRt)
sp_of_interest <- c('astephensi_eg_gene', 'agambiae_eg_gene')
HOST <- 'biomart.vectorbase.org'
BASE <- listMarts(host=HOST)$biomart[1]

orths <- getBM(attributes=c('ensembl_gene_id', 'agambiae_eg_gene'), mart = useMart(
  BASE, host=HOST, dataset = 'astephensi_eg_gene'
))

orths <- orths[orths$agambiae_eg_gene != '',]

geneSets <- lapply(sp_of_interest, function(DB_NAME){
  getBM(
    attributes=c('ensembl_gene_id','chromosome_name','start_position','end_position','strand'),
    mart = useMart(
      BASE,
      host=HOST,
      dataset = DB_NAME
    )
  )
})
names(geneSets) <- sp_of_interest

lapply(sp_of_interest, function(sp){
  write.csv2(geneSets[[sp]], paste0('./input_data/', sp, '_genes.csv'), row.names = F)
})

write.csv2(orths, './input_data/orths.csv', row.names = F)
