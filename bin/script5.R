#!/usr/bin/env Rscript
library(monocle3)
library(ggplot2)

args <- commandArgs(trailingOnly=TRUE)
input_file <- args[1]
output_file <- args[2]
label_leaves <- args[3]
label_branch_points <- args[4]
color_cell <- args[5]


#parsing
if (label_leaves == "FALSE") {
    label_leaves <- FALSE
} else if (label_leaves == "TRUE"){
    label_leaves <- TRUE
}
if (label_branch_points == "FALSE") {
    label_branch_points <- FALSE
} else if (label_branch_points == "TRUE"){
    label_branch_points <- TRUE
}
 
cds <- readRDS(input_file)

print(args)

cds <- learn_graph(cds)
plot_cells(cds,
           color_cells_by = color_cell,
           label_cell_groups=FALSE,
           label_leaves= label_leaves,
           label_branch_points= label_branch_points, graph_label_size=1.5)
ggsave(file.path( output_file, "plot5.jpg"), device = "jpg", width = 8, height = 6, units = "in")

