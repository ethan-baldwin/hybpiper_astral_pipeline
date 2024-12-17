rule trim_alignments:
    input:
        "alignments/{sample}.aln"
    output:
        "trimmed_alignments/{sample}.trimal.aln"
    log:
        "logs/trim_alignments.log"
    conda:
        "../envs/trimal.yml"
    envmodules:
        "trimAl/1.4.1-GCCcore-11.3.0"
    shell:
        "trimal -in {input} -out {output} -gt 0.5"
