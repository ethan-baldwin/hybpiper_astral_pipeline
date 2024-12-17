rule hybpiper_assemble:
    input:
        r1="trimmed_reads/{sample}_P_R1.fastq.gz",
        r2="trimmed_reads/{sample}_P_R2.fastq.gz",
        sample_name="{sample}"
    output:
        directory("hybpiper/{sample}")
    envmodules:
        "Hybpiper/2.3.1-foss-2023a"
    params:
        target_file=config["target_file"],
        extra_flags=config["hybpiper_extra_flags"]
    resources:
        mem_mb=20000,
        cpus_per_task=8
    shell:
        "hybpiper assemble -t_dna {params.target_file} -r {input.r1} {input.r2} --prefix {input.sample_name} -o hybpiper {params.extra_flags}"

rule write_sample_list:
    input:
        expand("{sample}",sample=SAMPLES["sample_name"])
    output:
        "hybpiper/sample_list.txt"
    run:
        with open(output[0], 'w') as f:
            for line in input:
                f.write("%s\n" % line)

rule hybpiper_stats:
    input:
        "hybpiper/sample_list.txt"
    output:
        "seq_lengths.tsv"
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
        directory("hybpiper/fasta")
    envmodules:
        "Hybpiper/2.3.1-foss-2023a"
    params:
        target_file=config["target_file"],
        # mapper=config["mapper"],
        extra_flags=config["hybpiper_extra_flags"]
    resources:
        mem_mb=20000,
        cpus_per_task=8
    shell:
        "hybpiper retrieve_sequences supercontig -t_dna {params.target_file} --sample_names {input.sample_list} --hybpiper_dir hybpiper {params.extra_flags} --fasta_dir {output}"
