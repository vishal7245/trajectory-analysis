#!/usr/bin/env Rscript
library(monocle3)
library(ggplot2)

args <- commandArgs(trailingOnly=TRUE)
input_file <- args[1]
output_file <- args[2]
labelling <- args[3]
color_cell <- args[4]
obj_type <- args[5]

if (labelling == "FALSE") {
    labelling <- FALSE
} else if (labelling == "TRUE"){
    labelling <- TRUE
}
 
cds <- readRDS(input_file)

if (obj_type == 'CDS') {
  cds <- reduce_dimension(cds)
}

plot_cells(cds, label_groups_by_cluster = labelling,  color_cells_by = color_cell)
ggsave(file.path( output_file, "plot1.jpg"), device = "jpg", width = 8, height = 6, units = "in")

cds <- cluster_cells(cds)
plot_cells(cds, color_cells_by = "partition")
ggsave(file.path( output_file, "plot2.jpg"), device = "jpg", width = 8, height = 6, units = "in")


saveRDS(cds, file = "reduced_obj.rds")