#
# This is a Makefile
#
# NCBI Genome accession number  
ACC=AY632535.2

# The user-friendly name for the genome
NAME=zika_mr766

# Bioproject number
BPN=PRJNA313294 

# SRR numbers
SRR=SRR3191545

# URL to download the reads
URL=https://trace.ncbi.nlm.nih.gov/Traces/?run=${SRR}

# Reference genome
REF=refs/${NAME}.fa

# Read 1
R1=reads/${SRR}_1.fastq

# Read 2
R2=reads/${SRR}_2.fastq

# BAM files
BAM=bam/${SRR}.bam

# The temporary bedgraph files
BG=bam/${SRR}.bedgraph

# The BW wiggle files
BW=bam/${SRR}.bw

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
# working with the reference
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

# working wth the reads
read:
	# Make the reads directory
	mkdir -p $(dir ${R1})
	# Download the reads
	fastq-dump -X ${N} --outdir reads --split-files ${SRR} 

# Align the reads and convert to BAM. Use 4 threads
# Works for paired-end reads. Modify for single-end reads.
align:
    # Make the BAM directory
	mkdir -p $(dir ${BAM})
	
    # Align the reads and index the BAM file
	minimap2 --MD -ax sr ${REF} ${R1} | samtools sort > ${BAM}
	samtools index ${BAM}

# Creating Wiggle files from BAM
wiggle:
    # Index the reference genome
	samtools faidx ${REF}

    # Generate the temporary bedgraph file
	LC_ALL=C; bedtools genomecov -ibam  ${BAM} -split -bg | sort -k1,1 -k2,2n > ${BG}

    # Convert the bedgraph file to bigwig
	bedGraphToBigWig ${BG} ${REF}.fai ${BW}

# Generate alignment statistics of the alignment file
stats:
	samtools flagstat ${BAM}
	samtools coverage ${BAM}

# Create necessary directories
all: ref read align stats clean

# Create necessary directories
.PHONY: all ref read align stats clean