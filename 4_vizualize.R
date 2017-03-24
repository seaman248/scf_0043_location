library(genoPlotR)
# 
# source('./0_.R')
# source('./1_clean.R')
# source('./2_orths_table_create.R')
# source('3_add_funestus.R')
blocks <- lapply(seq(1, 11, 5), function(n){
  gene_table <- read.csv2('./input_data/un_table_fun.csv')[, seq(n, n+4, 1)]
  colnames(gene_table) <- c('name', 'chr', 'start', 'end', 'strand')
  gene_table
})

blocks <- blocks[c(2, 1, 3)]
names(blocks) <- c('gam', 'steph', 'fun')

dna_segs <- lapply(blocks, function(block){
  block$gene_type <- 'blocks'
  dna_seg(block[c(1, 3, 4, 5, 6)])
})
names(dna_segs) <- names(blocks)

inverse_scfs <- c('L', 'KB668805', 'KB668861')
xlims <- lapply(blocks, function(block){
  block <- block[order(block[, 3]),]
  unlist(lapply(unique(block[, 2]), function(chr){
    loc_xlims <- list(
      min(block[block[,2]==chr, 3]),
      max(block[block[,2]==chr, 4])
    )
    if(length(grep(paste0(inverse_scfs, collapse = '|'), chr)) != 0){
      loc_xlims[c(2, 1)]
    } else {
      loc_xlims[c(1, 2)]
    }
  }))
})

comparisons <- lapply(1:(length(dna_segs)-1), function(n){
  as.comparison(data.frame(
    start1=dna_segs[[n]][,2], end1=dna_segs[[n]][,3],
    start2=dna_segs[[n+1]][,2], end2=dna_segs[[n+1]][,3]
  ))
})

annots <- list(
  annotation(c(66479, 3145252, 64220999), text = c('c3L', '2Lc', 'c2R')),
  annotation(c(775297,1490712), text = c('scf_00043', 'C')),
  annotation(c(953452,1415349), text = c('5 scfs from c(e5)', 'C'))
)

plot_gene_map(
  dna_segs = dna_segs,
  xlims = xlims,
  comparisons = comparisons,
  annotations = annots
)