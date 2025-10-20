#
# This is a Makefile
#
# NCBI Genome accession number  
ACC=AF086833

# The user-friendly name for the genome
NAME=ebola-1976

# Reference genome
REF=refs/${NAME}.fa

# Bioproject number
BPN=PRJNA313294 

# SRR number
SRR=SRP070895

# URL to download the reads
URL=https://ftp.sra.ebi.ac.uk/vol1/fastq/SRR579/006/SRR5790106/SRR5790106.fastq.gz

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
    @echo "# Usage: make [all|refs|fastq|index|align|clean]"    
    @echo "#"

Download the genome:
	refs/${NAME}.fa:
	# Get the genome 
	efetch -db nuccore -format fasta -id ${ACC} > ${REF}

	# Get the annotation
	efetch -db nuccore -format gff -id ${ACC} > ${ACC}.gff
	efetch -db nuccore -format gtf -id ${ACC} > ${ACC}.gtf

Download the reads:
	-x 5: use 5 connections
	-c: continue download
	--summary-interval=10: print summary every 10 seconds
	aria2c -x 5 -c --summary-interval=10 ${URL}

Download the reads with multiple SRR:
	bio search ${SRR} | jq -r '.[].run_accession' > sra_ids.txt
	cat sra_ids.txt
	# make the output dir
	mkdir -p reads
	# loop over each SRR in sra_ids.txt and run your exact command
	while read -r SRR; do
		fastq-dump -X 1000 -F --outdir reads --split-files "${SRR}"
	done < sra_ids.txt