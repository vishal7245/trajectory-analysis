#!/usr/bin/env Rscript
library(monocle3)
library(ggplot2)

args <- commandArgs(trailingOnly=TRUE)
input_file <- args[1]
output_file <- args[2]
labelling <- args[3]
color_cell <- args[4]
label_leaves <- args[5]
label_branch_points <- args[6]


#parsing
if (labelling == "FALSE") {
    labelling <- FALSE
} else if (labelling == "TRUE"){
    labelling <- TRUE
}
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

cds <- learn_graph(cds)
plot_cells(cds,
           color_cells_by = color_cell,
           label_groups_by_cluster= labelling,
           label_leaves= label_leaves,
           label_branch_points= label_branch_points)
ggsave(file.path( output_file, "plot4.jpg"), device = "jpg", width = 8, height = 6, units = "in")

