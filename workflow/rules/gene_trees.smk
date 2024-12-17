GENES = glob_wildcards("fasta/{gene}.fasta").gene

rule gene_tree:
    input:
        "trimmed_alignments/{gene}.trimal.aln"
    output:
        "trimmed_alignments/{gene}.trimal.aln.treefile"
    log:
        "logs/gene_trees/{gene}.log"
    conda:
        "../envs/iqtree.yml"
    envmodules:
        "IQ-TREE/2.2.2.6-gompi-2022a"
    shell:
        "iqtree2 -s {input} -nt AUTO -bb 1000 -m MFP"

rule merge_trees:
    input:
        gene_list="genelist.txt",
        trees=lambda wildcards, input: expand("trimmed_alignments/{gene}.trimal.aln.treefile",gene=[line.strip() for line in open(input.gene_list)])
    output:
        'merged.treefile'
    log:
        "logs/merge_trees.log"
    conda:
        "../envs/base.yml"
    shell:
        "cat {input.trees} > {output}"
