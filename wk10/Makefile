#
# This is a Makefile

# Parameters set for the specific reference genome
# NCBI Genome accession number  
ACC=AY632535.2

# NCBI Genome number
GEN=GCF_000882815

# The user-friendly name for the genome
NAME=zika_mr766


#Parameters set for the specific reads
# Bioproject number
BPN=PRJNA313294 

# SRR numbers
SRR=SRR3191545

# URL to download the reads
URL=https://trace.ncbi.nlm.nih.gov/Traces/?run=${SRR}


# Other parameters
# Reference genome
REF=ref/${NAME}.fa

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

# We can set it to 1 if we wanted to check what the code execute
DRYRUN=0

# The variant file.
VCF ?= vcf/$(notdir $(basename ${BAM})).vcf.gz

# Additional bcf flags for pileup annotation.
PILE_FLAGS =  -d 100 --annotate 'INFO/AD,FORMAT/DP,FORMAT/AD,FORMAT/ADF,FORMAT/ADR,FORMAT/SP'

# Additional bcf flags for calling process.
CALL_FLAGS = --ploidy 2 --annotate 'FORMAT/GQ'


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
	and running qc on the reads, then aligning the reads to the genome to generate a BAM file. And evaluate
	the alignment statistics. Also, making Wiggle files from BAM for 
	understanding the coverage. And then generating the vcf file"
	@echo "# Usage: make [all|ref|qc|index|align|wiggle|stat|vcf|clean]"
	@echo "#"


# working with the reference
ref:
	# Make the reference directory if it already not exists
	mkdir -p $(dir ${REF})
	datasets download genome accession ${GEN} --include genome,gff3,gtf --filename ${GEN}.zip
	unzip -n -o  ${GEN}.zip -d ref
	rm  ${GEN}.zip
	mv ref/ncbi_dataset/data/${GEN}*/*.fna ref/${NAME}.fa
	mv ref/ncbi_dataset/data/${GEN}*/*.gff ref/${NAME}.gff
	mv ref/ncbi_dataset/data/${GEN}*/*.gtf ref/${NAME}.gtf

	# Show some stats about the genome
	# Make the stat directory if it already not exists
	mkdir -p stats
	seqkit stats ${REF} > stats/${NAME}_fasta_stats.txt


# working wth the reads
read:
	# Make the reads directory if it already not exists
	mkdir -p $(dir ${R1})
	# Download the reads
	fastq-dump -X ${N} --outdir reads --split-files ${SRR} 

# Align the reads and convert to BAM. Use 4 threads
# Works for paired-end reads. Modify for single-end reads.

qc:
	# Run FastQC on the reads
	mkdir -p qc
	fastqc -o qc ${R1} ${R2}

align:
    # Make the BAM directory if it already not exists
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
	mkdir -p stats	
	samtools flagstat ${BAM} > stats/${SRR}_bam_flagstat.txt
	samtools coverage ${BAM} > stats/${SRR}_bam_coverage.txt

# Generating VCF files
${VCF}: ${BAM} ${REF}
	mkdir -p $(dir $@)
	bcftools mpileup ${PILE_FLAGS} -O u -f ${REF} ${BAM} | \
		bcftools call ${CALL_FLAGS} -mv -O u | \
		bcftools norm -f ${REF} -d all -O u | \
		bcftools sort -O z > ${VCF}

${VCF}.tbi: ${VCF}
	bcftools index -t -f $<

vcf:: ${VCF}.tbi
	@ls -lh ${VCF}

# Clean up generated files
clean:
	rm -rf ${REF} ${R1} ${R2} ${BAM} ${BAM}.bai ${BAM}.vcf ${BAM}.vcf.gz

# Create necessary directories
all: ref read qc align wiggle stats vcf
refs: ref
reads: read align wiggle stats
readsvcf: read align wiggle stats vcf

# Create necessary directories
.PHONY: all ref read qc align wiggle stats vcf clean









