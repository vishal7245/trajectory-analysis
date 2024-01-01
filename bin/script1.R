#!/usr/bin/env Rscript
library(monocle3)

args <- commandArgs(trailingOnly=TRUE)
input_file <- args[1]
num_dim <- args[2]
alignment_group <- args[3]
residual_model_formula_str <- args[4]
batch_correction <- args[5]



num_dim <- as.numeric(num_dim)
cds <- readRDS(input_file)

cds <- preprocess_cds(cds, num_dim = num_dim)

if (batch_correction == 'TRUE') {
  #parsing
  elements <- strsplit(residual_model_formula_str, ",")
  residual_model_formula_str <- paste0("~ ", paste(unlist(elements), collapse = " + "))
  cds <- align_cds(cds, alignment_group = alignment_group, residual_model_formula_str = residual_model_formula_str)
  print("Batch Correction Performed")
} else {
    print("Batch Correction Skipped")
}
saveRDS(cds, file = "preprocessed_obj.rds")