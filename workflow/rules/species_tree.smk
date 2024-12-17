rule species_tree:
    input:
        "merged.treefile"
    output:
        "astral/speciestree.tre"
    log:
        "logs/specie_tree.log"
    conda:
        "../envs/aster.yml"
    envmodules:
        "ASTER/1.16-GCC-11.3.0"
    shell:
        "astral -i {input} -o {output}"
