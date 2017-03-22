library(genoPlotR)

blocks <- lapply(c(1, 6, 11), function(n){
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

xlims <- lapply(blocks, function(block){
  block <- block[order(block[, 3]),]
  unlist(lapply(unique(block[, 2]), function(chr){
    list(
      min(block[block[,2]==chr, 3]),
      max(block[block[,2]==chr, 4])
    )
  }))
})

comparisons <- lapply(1:(length(dna_segs)-1), function(n){
  comparison(data.frame(
    start1=dna_segs[[n]][,2], end1=dna_segs[[n]][,3],
    start2=dna_segs[[n+1]][,2], end2=dna_segs[[n+1]][,3]
  ))
})

annots <- list(
  annotation(xlims[[1]][seq(1, length(xlims[[1]]), 2)], text = c('3L', '2L', '2R')),
  annotation(c(775297,1550595), text = c('scf_00043', 'C')),
  annotation(c(953452,1906904), text = c('5 scfs from c(e5)', 'C'))
)

plot_gene_map(
  dna_segs = dna_segs,
  xlims = xlims,
  comparisons = comparisons,
  annotations = annots
)