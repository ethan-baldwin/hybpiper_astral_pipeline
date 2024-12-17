rule hybpiper_assemble:
    input:
        r1="trimmed_reads/{sample}_P_R1.fastq.gz",
        r2="trimmed_reads/{sample}_P_R2.fastq.gz"
    output:
        directory("hybpiper/{sample}")
    log:
        "logs/hybpiper_assemble_{sample}.log"
    conda:
        "../envs/hybpiper.yaml"
    envmodules:
        "Hybpiper/2.3.1-foss-2023a"
    params:
        target_file=config["target_file"],
        extra_flags=config["hybpiper_extra_flags"],
        sample_name="{sample}"
    resources:
        mem_mb=20000,
        cpus_per_task=8
    shell:
        "hybpiper assemble -t_dna {params.target_file} -r {input.r1} {input.r2} --prefix {params.sample_name} -o hybpiper {params.extra_flags}"

rule write_sample_list:
    input:
        assemble_done=expand("hybpiper/{sample}",sample=SAMPLES["sample_name"])
    output:
        "hybpiper/sample_list.txt"
    log:
        "logs/write_sample_list.log"
    params:
        expand("{sample}",sample=SAMPLES["sample_name"])
    run:
        with open(output[0], 'w') as f:
            for line in params:
                f.write("%s\n" % line)

rule hybpiper_stats:
    input:
        "hybpiper/sample_list.txt"
    output:
        "seq_lengths.tsv"
    log:
        "logs/hybpiper_stats.log"
    conda:
        "../envs/hybpiper.yaml"
    envmodules:
        "Hybpiper/2.3.1-foss-2023a"
    params:
        target_file=config["target_file"]
    resources:
        mem_mb=5000,
        cpus_per_task=1
    shell:
        "hybpiper stats -t_dna {params.target_file} gene {input}"

rule hybpiper_retrieve_sequences:
    input:
        expand("hybpiper/{sample}",sample=SAMPLES["sample_name"]),
        sample_list="hybpiper/sample_list.txt"
    output:
        directory("fasta")
    log:
        "logs/hybpiper_retrieve_sequences.log"
    conda:
        "../envs/hybpiper.yaml"
    envmodules:
        "Hybpiper/2.3.1-foss-2023a"
    params:
        target_file=config["target_file"]
    resources:
        mem_mb=20000,
        cpus_per_task=8
    shell:
        "hybpiper retrieve_sequences supercontig -t_dna {params.target_file} --sample_names {input.sample_list} --hybpiper_dir hybpiper {params.extra_flags} --fasta_dir {output}"

rule make_gene_list:
    input:
        directory("fasta")
    output:
        "genelist.txt"
    log:
        "logs/make_gene_list.log"
    conda:
        "../envs/base.yaml"
    shell:
        "for file in {input}/*fasta; do echo $file | sed 's/.fasta//' > genelist.txt"
