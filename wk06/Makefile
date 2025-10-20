#
# This is a Makefile
#
# NCBI Genome accession number  
ACC=AY632535.2

# The user-friendly name for the genome
NAME=zika_mr766

# Bioproject number
BPN=PRJNA313294 

# SRR number
SRR=SRR3194431

# URL to download the reads
URL=https://trace.ncbi.nlm.nih.gov/Traces?run=SRR3194431

# Reference genome
REF=refs/${NAME}.fa

# Read 1
R1=reads/${SRR}_1.fastq

# Read 2
R2=reads/${SRR}_2.fastq

# BAM file
BAM=bam/${SRR}.bam

# How many reads to download
N=10000



# Set the shell the commands run in.
SHELL = bash

# Execute all commands in a single shell.
.ONESHELL:

# Run the shell with strict error checking.
.SHELLFLAGS = -eu -o pipefail -c

# Delete target files if the command fails.
.DELETE_ON_ERROR:

# Warn if a variable is not defined.
MAKEFLAGS += --warn-undefined-variables

# Disable built-in rules.
MAKEFLAGS += --no-builtin-rules



# Prints the usage message
usage:
	@echo "#"
	@echo "# Makefile for downloading the genome and reads for sequencing data
	and aligning the reads to the genome to generate a BAM file. And evaluate
	the alignment statistics."
	@echo "# Usage: make [all|refs|fastq|index|align|clean]"
	@echo "#"

ref:
	# Make the refs directory
	mkdir -p $(dir ${REF})
	# Get the genome
	efetch -db nuccore -format fasta -id ${ACC} > ${REF}

	# Get the annotation
	efetch -db nuccore -format gff -id ${ACC} > ${ACC}.gff
	efetch -db nuccore -format gtf -id ${ACC} > ${ACC}.gtf

	# Show some stats about the genome
	seqkit stats ${REF}

read:
	# Make the reads directory
	mkdir -p $(dir ${R1})
	# Download the reads
	fastq-dump -X ${N} --outdir reads --split-files ${SRR}

align: 
	# Make the refs directory
	mkdir -p $(dir ${BAM})
	minimap2 --MD -ax sr ${REF} ${R1} | \
		samtools sort > ${BAM}

# Generate alignment statistics
stats:
	samtools flagstat ${BAM} > ${SRR}_bam_flagstat.txt

# Clean up generated files
# clean:
	# rm -rf ${REF} ${R1} ${R2} ${BAM} ${BAM}.bai

# Create necessary directories
all: ref read align stats clean

# Create necessary directories
.PHONY: all ref read align stats clean