#!/bin/bash
#SBATCH --job-name=snakemake_hybpiper
#SBATCH --partition=batch
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=2gb
#SBATCH --time=140:00:00
#SBATCH --mail-type=END,FAIL
#SBATCH --output=/scratch/eab77806/logs/%x_%j.out
#SBATCH --error=/scratch/eab77806/logs/%x_%j.error

ml snakemake
# ml Mamba
conda activate base

snakemake --profile /home/eab77806/.config/slurm_profile/ --directory /scratch/eab77806/hybpiper_snakemake/ --configfile /home/eab77806/hybpiper_astral_pipeline/config/config.yaml --rerun-incomplete --use-conda
