rule gene_tree:
    input:
        "trimmed_alignments/{gene}.trimal.aln"
    output:
        "iqtree/{gene}/{gene}.treefile",
        "iqtree/{gene}/{gene}.bionj",
        "iqtree/{gene}/{gene}.ckp.gz",
        "iqtree/{gene}/{gene}.contree",
        "iqtree/{gene}/{gene}.iqtree",
        "iqtree/{gene}/{gene}.log",
        "iqtree/{gene}/{gene}.mldist",
        "iqtree/{gene}/{gene}.model.gz",
        "iqtree/{gene}/{gene}.splits.nex"
    log:
        "logs/gene_trees/{gene}.log"
    conda:
        "../envs/iqtree.yml"
    envmodules:
        "IQ-TREE/2.2.2.6-gompi-2022a"
    params:
        "iqtree/{gene}/{gene}"
    shell:
        "iqtree2 -s {input} --prefix {params} -nt AUTO -bb 1000 -m MFP"

rule merge_trees:
    input:
        expand("iqtree/{gene}/{gene}.treefile", gene=get_genes)
    output:
        "merged.treefile"
    log:
        "logs/merge_trees.log"
    # conda:
    #     "../envs/base.yml"
    shell:
        "cat {input} > {output}"
