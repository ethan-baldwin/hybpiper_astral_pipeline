rule trim_alignments:
    input:
        "alignments/{gene}.aln"
    output:
        "trimmed_alignments/{gene}.trimal.aln"
    log:
        "logs/trim_alignments/{gene}.log"
    conda:
        "../envs/trimal.yml"
    envmodules:
        "trimAl/1.4.1-GCCcore-11.3.0"
    shell:
        "trimal -in {input} -out {output} -gt 0.5"
