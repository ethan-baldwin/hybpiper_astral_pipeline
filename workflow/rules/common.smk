import pandas as pd

SAMPLES = pd.read_table(config["samples"],header=0,sep='\s+').set_index("sample_name", drop=False)

get_sample_read1 = SAMPLES["read1"].to_dict()
get_sample_read2 = SAMPLES["read1"].to_dict()

# genome_to_fasta_path = GENOMES.set_index("genome_id")["genome_path"].to_dict()


# genome_to_fasta = GENOMES.set_index("genome_id")["masked_genome_path"].to_dict()
