rule collapse_low_bs:
    input:
        "merged.treefile"
    output:
        "merged_BS10.tre"
    log:
        "logs/collapse_low_bs.log"
    conda:
        "../envs/aster.yml"
    shell:
        "nw_ed  {input} 'i & b<=10' o > {output}"

rule astral4_raw_gene_trees:
    input:
        "merged.treefile"
    output:
        "astral/astral4.tre"
    log:
        "logs/astral4_raw_gene_trees.log"
    conda:
        "../envs/aster.yml"
    envmodules:
        "ASTER/1.16-GCC-11.3.0"
    params:
        outgroup=config["outgroup"]
    shell:
        "astral --root {params.outgroup} -i {input} -o {output}"

rule wastral_raw_gene_trees:
    input:
        "merged.treefile"
    output:
        "astral/wastral.tre"
    log:
        "logs/wastral_raw_gene_trees.log"
    conda:
        "../envs/aster.yml"
    envmodules:
        "ASTER/1.16-GCC-11.3.0"
    params:
        outgroup=config["outgroup"]
    shell:
        "wastral --root {params.outgroup} -i {input} -o {output}"

rule astral4_collapsed_gene_trees:
    input:
        "merged_BS10.tre"
    output:
        "astral/astral4_bs10.tre"
    log:
        "logs/astral4_collapsed_gene_trees.log"
    conda:
        "../envs/aster.yml"
    envmodules:
        "ASTER/1.16-GCC-11.3.0"
    params:
        outgroup=config["outgroup"]
    shell:
        "wastral --root {params.outgroup} -i {input} -o {output}"

rule analyze_trees:
    input:
        gene_trees="merged_BS10.tre",
        species_tree="astral/astral4_bs10.tre"
    output:
        scored="astral/astral_4_bs10_scored.tre",
        polytomy="astral/astral_4_bs10_poly.tre",
        alt_freq="astral/astral_4_bs10_qs.tre",
        freq_csv="astral/astral_4_bs10_qf.tre"
    log:
        "logs/score_tree.log"
    envmodules:
        "ASTRAL/5.7.8-Java-1.8.0_241"
    shell:
        """
        java -jar $EBROOTASTRAL/astral.5.7.8.jar -i {input.gene_trees} -q {input.species_tree} -o {output.scored}
        java -jar $EBROOTASTRAL/astral.5.7.8.jar -i {input.gene_trees} -q {input.species_tree} -t 10 -o {output.poly}
        java -jar $EBROOTASTRAL/astral.5.7.8.jar -i {input.gene_trees} -q {input.species_tree} -t 8 -o {output.qs}
        java -jar $EBROOTASTRAL/astral.5.7.8.jar -i {input.gene_trees} -q {input.species_tree} -t 16 -o {output.qf}
        """
