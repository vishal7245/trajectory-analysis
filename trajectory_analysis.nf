#!/usr/bin/env nextflow
params.outdir = "$projectDir/output"
file_reads = Channel.fromPath('input/*.rds')


process READ_AND_PREPROCESS {
    container 'vishal1908/monocle-final:monocle-final-env'
    publishDir "$params.outdir", mode: 'copy'

    input:
     path sample
     val num_dim
     val alignment_group
     val residual_model_formula_str
     val perform_batch_correction

    output:
     path 'preprocessed_obj.rds'

    script:
     """
     script1.R $sample $num_dim $alignment_group $residual_model_formula_str $perform_batch_correction
     """
}

process REDUCE_AND_VISUALIZE {
    container 'vishal1908/monocle-final:monocle-final-env'
    publishDir "$params.outdir", mode: 'copy'

    input:
     path preprocessed_obj
     val label_groups_by_cluster
     val colour_cells_by

    output:
     path 'reduced_obj.rds'

    script:
    """
    script2.R $preprocessed_obj $params.outdir $label_groups_by_cluster $colour_cells_by
    """

}


process VISUALIZE_GENES {
    container 'vishal1908/monocle-final:monocle-final-env'
    publishDir "$params.outdir", mode: 'copy'

    input:
     path preprocessed_obj
     val label_groups_by_cluster
     val genes 
     val show_trajectory_graph


    when:
     params.visualize_gene == 'TRUE'

    script:
    """
    script3.R $preprocessed_obj $params.outdir $label_groups_by_cluster $genes $show_trajectory_graph
    """

}

process TRAJECTORY_GRAPH {
    container 'vishal1908/monocle-final:monocle-final-env'
    publishDir "$params.outdir", mode: 'copy'

    input:
     path preprocessed_obj
     val label_groups_by_cluster
     val colour_cells_trajectory
     val label_leaves
     val label_branch_points

    script:
    """
    script4.R $preprocessed_obj $params.outdir $label_groups_by_cluster $colour_cells_trajectory $label_leaves $label_branch_points
    """

}

process TRAJECTORY_GRAPH_PSUEDOTIME {
    container 'vishal1908/monocle-final:monocle-final-env'
    publishDir "$params.outdir", mode: 'copy'

    input:
     path preprocessed_obj
     val label_leaves
     val label_branch_points
     val psuedotime_column

    when:
     params.psuedotime_graph = 'TRUE'

    script:
    """
    script5.R $preprocessed_obj $params.outdir $label_leaves $label_branch_points $psuedotime_column 
    """

}





workflow {
    result1 = READ_AND_PREPROCESS(file_reads.first(), params.num_dim , params.alignment_group, params.residual_model_formula_str, params.perform_batch_correction)
    result2 = REDUCE_AND_VISUALIZE(result1, params.label_groups_by_cluster, params.colour_cells_by)
    VISUALIZE_GENES(result2, params.label_groups_by_cluster, params.genes, params. show_trajectory_graph)
    TRAJECTORY_GRAPH(result2, params.label_groups_by_cluster, params.colour_cells_trajectory, params.label_leaves, params.label_branch_points)
    TRAJECTORY_GRAPH_PSUEDOTIME(result2, params.label_leaves, params.label_branch_points, params.psuedotime_column)
}