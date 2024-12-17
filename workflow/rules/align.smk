rule align:
    input:
        "fasta/{sample}.fasta"
    output:
        "alignments/{sample}.aln"
    log:
        "logs/align.log"
    conda:
        "../envs/mafft.yml"
    envmodules:
        "MAFFT/7.505-GCC-11.3.0-with-extensions"
    resources:
        mem_mb=20000,
        cpus_per_task=8
    shell:
        "mafft --thread {resources.cpus_per_task} --auto {input} > {output}"
