# Nextflow Monocle Workflow Documentation

This document provides an overview and documentation for the Nextflow pipeline designed for Trajectory analysis. The workflow consists of several processes, each responsible for a specific step in the Trajectory analysis pipeline. We have used Monocle3, which is a bioinformatics package commonly used for the analysis of single-cell RNA sequencing data.
The Pipeline is highly parameterized and can adapt to different datasets accordingly. Please refer to the parameters section

## Sample Output
  ![Plot1](https://github.com/vishal7245/trajectory-analysis/blob/main/output/plot1.jpg)
  ![Plot2](https://github.com/vishal7245/trajectory-analysis/blob/main/output/plot2.jpg)
  ![Plot3](https://github.com/vishal7245/trajectory-analysis/blob/main/output/plot3.jpg)
  ![Plot4](https://github.com/vishal7245/trajectory-analysis/blob/main/output/plot4.jpg)
  ![Plot5](https://github.com/vishal7245/trajectory-analysis/blob/main/output/plot5.jpg)

## Prerequisites

Before running this workflow, ensure that the following dependencies are installed:

- Nextflow (https://www.nextflow.io/)
- Docker or a containerization system compatible with Nextflow

### Installing Nextflow

1. **Prerequisites:**
   - Ensure you have Java installed on your system (Nextflow is a Java-based tool).
   - You can download Java from [Oracle's official website](https://www.oracle.com/java/technologies/javase-downloads.html) or use OpenJDK.

2. **Download Nextflow:**
   - Open a terminal and run the following command to download Nextflow:
     ```bash
     curl -s https://get.nextflow.io | bash
     ```

3. **Move Nextflow to a Directory in Your PATH:**
   - Move the downloaded Nextflow script to a directory in your PATH, for example:
     ```bash
     mv nextflow /usr/local/bin
     ```

4. **Verify Installation:**
   - Run the following command to verify that Nextflow is installed correctly:
     ```bash
     nextflow -v
     ```

### Installing Docker

Docker is used to containerize the Monocle analysis environment.

1. **Download and Install Docker:**
   - Follow the instructions for your specific operating system on the [Docker website](https://docs.docker.com/get-docker/).

2. **Verify Docker Installation:**
   - After installation, run the following command to ensure Docker is installed and running:
     ```bash
     docker --version
     docker run hello-world
     ```

## Folder Structure
The workflow consists of the following folders:


1. **Bin**
   - Bin folder contains all the necessary scripts for the proper functioning of the pipeline.
    
2. **Input**
   - Input folder should contain the CDS (Cell Dataset) object(Preferred) or preprocessed Seurat object as the input data.
   - The object should consist of 3 sub-objects namely, Expression Matrix, Cell Metadata and Gene Metadata.
  
3. **Ouput**'
   - Output folder contains the result graphs once the pipeline is executed.
  
4. **Work**
   - Work folder contains the log report ans output of each step involved in the execution.
  

## Parameters
The pipeline is highly parameterized and all the parameters are pre-defined in the **params.config** beforehand.
 - Initial Parameters
   ```
   //Define Object
    params.obj_type = 'CDS'    //CDS (Preferred) or Seurat
   ```
   Define the input object type

 - Preprocessing Parameters
   ```
   // Preprocessing
   params.num_dim = 50
   ```
   Define the number of dimensions

 - Batch Correction(Optional Step)
   ```
   params.perform_batch_correction = 'TRUE'
   params.alignment_group = 'batch' 
   params.residual_model_formula_str = 'bg.300.loading,bg.400.loading,bg.500.1.loading,bg.500.2.loading,bg.r17.loading,bg.b01.loading,bg.b02.loading' 
   ```
   To perform batch correction on the dataset set ```params.perform_batch_correction = 'TRUE'``` and define other parameters according to your dataset

 - Cluster Visualization Graph(Optional Step)
   ```
   // Cluster Visualization
   params.label_groups_by_cluster = 'TRUE'
   params.colour_cells_by = 'cell.type' 
   ```
   Based on the annotation of your data, specify the ```params.colour_cells_by```


 - Visualize how individual genes vary along the trajectory(Optional Step)
   ```
   params.visualize_gene = 'TRUE'
   params.genes = "che-1,hlh-17,nhr-6,dmd-6,ceh-36,ham-1"
   params.show_trajectory_graph = 'FALSE'
   ```
   To visualize individual genes according to the trajectory make ```params.visualize_gene = 'TRUE'``` and specify the genes in ```params.genes``` seperated by ",".

  - Learn trajectory graph
    ```
    params.colour_cells_trajectory = 'cell.type' 
    params.label_leaves = 'TRUE'
    params.label_branch_points = 'TRUE'
    ```
    This parameters are for the trajectory analysis step. Specify the ```params.colour_cells_trajectory``` based on your data annotation.

  - Trajectory graph psuedotime(Optional Step)
    ```
    params.psuedotime_graph = 'TRUE'
    params.psuedotime_column = 'embryo.time.bin'
    ```
    To perform trajectory analysis based on pseudotime make ```params.psuedotime_graph = 'TRUE'``` and specify ```params.psuedotime_column``` based on the timeseries column available with the cell metadata

## Workflow Overview

The workflow consists of the following processes:


1. **READ_AND_PREPROCESS**
    Preprocess Data:
        If the object type is 'CDS' (CellDataSet), the script preprocesses the data using the preprocess_cds function from Monocle3, with the specified number of dimensions (num_dim).
        If batch correction is requested (batch_correction is 'TRUE'), the script aligns the data using the align_cds function, considering the specified alignment group (alignment_group) and residual model formula (residual_model_formula_str).

    Handle Seurat Object:
        If the object type is 'Seurat', the script converts the Seurat object to a Monocle3 CDS object. It also sets the gene_short_name in the feature data using the row names.

    Save Preprocessed Data:
        The preprocessed data object (cds) is saved using the saveRDS function, and the resulting file is named "preprocessed_obj.rds".

2. **REDUCE_AND_VISUALIZE**
    Reduce Dimensionality (if 'CDS'):
        If the object type is 'CDS' (CellDataSet), the script reduces the dimensionality of the data using the reduce_dimension function from Monocle3.

    Generate and Save Plots:

        The script generates two plots:
            Plot 1: Visualization of cells with an option to label cells by cluster and color cells based on the specified parameter (color_cells_by).
            Plot 2: Visualization of cells after clustering, with cells colored by their assigned partitions.

        Plots are saved as JPEG files using ggsave, and the files are named "plot1.jpg" and "plot2.jpg" in the specified output directory.

    Cluster Cells:
        The script clusters cells using the cluster_cells function from Monocle3.

3. **VISUALIZE_GENES**
    Parsing Input Parameters:
        The script parses boolean parameters (labelling and show_trajectory) from string values ("TRUE" or "FALSE").

    Visualize Cells:
        The script uses the plot_cells function from Monocle3 to generate a plot of cells. It allows for customization with options such as specifying genes (genes), labeling cell groups, and showing the trajectory graph.

 
4. **TRAJECTORY_GRAPH**
    Parsing Input Parameters:
        The script parses boolean parameters (labelling, label_leaves, and label_branch_points) from string values ("TRUE" or "FALSE").

    Learn Graph:
        The script uses the learn_graph function from Monocle3 to infer the trajectory graph from the preprocessed data.

    Visualize Cells:
        The script uses the plot_cells function from Monocle3 to generate a plot of cells, with options for coloring cells by a specified parameter (color_cell), labeling cells by cluster, and optionally labeling leaves and branch points in the trajectory.

5. **TRAJECTORY_GRAPH_PSUEDOTIME**
    Parsing Input Parameters:
        The script parses boolean parameters (label_leaves and label_branch_points) from string values ("TRUE" or "FALSE").

    Learn Graph:
        The script uses the learn_graph function from Monocle3 to infer the trajectory graph from the preprocessed data.

    Visualize Cells:
        The script uses the plot_cells function from Monocle3 to generate a plot of cells, with options for coloring cells by a specified parameter (color_cell), and optionally labeling leaves and branch points in the trajectory. The label_cell_groups parameter is set to FALSE to avoid labeling cells by group.

## Workflow Execution

To execute the workflow, use the following command:

```bash
nextflow run trajectory_analysis.nf -c params.config
```

After the execution the output would be produced in the output folder




