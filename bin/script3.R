#!/usr/bin/env Rscript
library(monocle3)
library(ggplot2)

args <- commandArgs(trailingOnly = TRUE)
input_file <- args[1]
output_file <- args[2]
labelling <- args[3]
genes <- args[4]
show_trajectory <- args[5]


# parsing input parameters
if (labelling == "FALSE") {
  labelling <- FALSE
} else if (labelling == "TRUE") {
  labelling <- TRUE
}
if (show_trajectory == "FALSE") {
  show_trajectory <- FALSE
} else if (show_trajectory == "TRUE") {
  show_trajectory <- TRUE
}
genes <- strsplit(genes, ",")
genes <- unlist(genes)
print(input_file)


cds <- readRDS(input_file)
plot_cells(cds,
           genes = genes,
           label_cell_groups = labelling,
           show_trajectory_graph = show_trajectory)
ggsave(file.path( output_file, "plot3.jpg"), device = "jpg", width = 8, height = 6, units = "in")