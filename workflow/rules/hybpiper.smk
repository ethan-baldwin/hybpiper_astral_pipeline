rule hybpiper_assemble:
    input:
        r1="trimmed_reads/{sample}_P_R1.fastq.gz",
        r2="trimmed_reads/{sample}_P_R2.fastq.gz"
    output:
        directory("hybpiper/{sample}")
    log:
        "logs/hybpiper_assemble_{sample}.log"
    # conda:
    #     "../envs/hybpiper.yml"
    envmodules:
        "Hybpiper/2.1.6-foss-2022b"
    params:
        target_file=config["target_file_command"],
        extra_flags=config["hybpiper_extra_flags"],
        sample_name="{sample}"
    resources:
        mem_mb=90000,
        cpus_per_task=32,
        runtime=6000
    shell:
        "hybpiper assemble {params.target_file} -r {input.r1} {input.r2} --prefix {params.sample_name} -o hybpiper {params.extra_flags}"

rule write_sample_list:
    input:
        assemble_done=expand("hybpiper/{sample}",sample=SAMPLES["sample_name"])
    output:
        "hybpiper/sample_list.txt"
    log:
        "logs/write_sample_list.log"
    params:
        sample_list=SAMPLES["sample_name"]
    run:
        with open(output[0], 'w') as f:
            for sample in params.sample_list:
                f.write(f"{sample}\n")

rule hybpiper_stats:
    input:
        "hybpiper/sample_list.txt"
    output:
        "seq_lengths.tsv"
    log:
        "logs/hybpiper_stats.log"
    # conda:
    #     "../envs/hybpiper.yml"
    envmodules:
        "Hybpiper/2.1.6-foss-2022b"
    params:
        target_file=config["target_file_command"],
        sequence_type=config["sequence_type"]
    resources:
        mem_mb=5000,
        cpus_per_task=1
    shell:
        "hybpiper stats {params.target_file} {params.sequence_type} {input}"

checkpoint hybpiper_retrieve_sequences:
    input:
        expand("hybpiper/{sample}", sample=SAMPLES["sample_name"]),
        sample_list="hybpiper/sample_list.txt"
    output:
        directory("fasta")
    log:
        "logs/hybpiper_retrieve_sequences.log"
    # conda:
    #     "../envs/hybpiper.yml"
    envmodules:
        "Hybpiper/2.1.6-foss-2022b"
    params:
        target_file=config["target_file_command"],
        sequence_type=config["sequence_type"]
    resources:
        mem_mb=20000,
        cpus_per_task=8
    shell:
        "hybpiper retrieve_sequences {params.sequence_type} {params.target_file} --sample_names {input.sample_list} --hybpiper_dir hybpiper --fasta_dir {output}"
