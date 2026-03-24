# The URL for the reference genome
URL=https://hgdownload.soe.ucsc.edu/goldenPath/hg38/chromosomes/chr22.fa.gz

# The reference genome
REF=refs/chr22.fa.gz

# The sequencing reads
SRR=SRR17653520

# The number of reads to download
N=1000000

SAMPLE=sample1

# The first read
R1=reads/${SAMPLE}_1.fastq

# The alignment file
BAM=bam/${SAMPLE}.bam

# The coverage file
WIG=bam/${SAMPLE}.bw

# Custom makefile settings.
SHELL = bash
.ONESHELL:
.SHELLFLAGS = -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

usage:
	@echo "#"
	@echo "# Read the source for more information."
	@echo "#"
	@echo "# N=${N}"
	@echo "# SRR=${SRR}"
	@echo "# SAMPLE=${SAMPLE}"
	@echo "# R1=${R1}"
	@echo "# BAM=${BAM}"
	@echo "# WIG=${WIG}"
	@echo "#"
	@echo "# Usage: make [refs|index|reads|align|peaks|all|clean]"
	@echo "#"

# Download the reference genome
# Needs to be recompressed
genome:
	make -f src/run/curl.mk \
		URL=${URL} \
		FILE=${REF} \
		run

	# Recompress the reference genome
	make -f src/run/bgzip.mk \
		FILE=${REF} \
		run

	# Index the reference genome
	make -f src/run/bwa.mk \
		REF=${REF} \
		index

# Download the sequencing reads
fastq:
	make -f src/run/sra.mk \
		SRR=${SRR} \
		N=${N} \
		R1=${R1} \
		run

# Align the reads to the reference genome
align:
	# Align the reads to the reference genome
	make -f src/run/bwa.mk \
		REF=${REF} \
		R1=${R1} \
		BAM=${BAM} \
		align

	# Create coverage tracks
	make -f src/run/coverage.mk \
		BAM=${BAM} \
		REF=${REF} \
		run
# Create a BAM file file which filtered for multimap reads \
(reads that would be mapped to different refeion. \
actually it filtered out non-primary reads and just keeping the primary reads) to compate it with the \
original BAM file in IGV
# -q 30 — filters out reads with MAPQ < 30, which are multimappers \
(BWA assigns MAPQ=0 to multimapping reads, and low MAPQ to ambiguous ones)\
For ChIP-seq, -q 30 is the standard threshold used in ENCODE pipeline guidelines

demultimap:
	samtools view -b -q 30 ${BAM} -o ${BAM}.filtered.bam
	samtools index ${BAM}.filtered.bam
	
	# Create coverage tracks
	make -f src/run/coverage.mk \
		BAM=${BAM}.filtered.bam \
		REF=${REF} \
		run
#
# Create a macs2 environment with:
# micromamba create -n peak -y  macs2 (In the README file it was explained that we use MACS3)
#
peaks:
	micromamba run -n peak macs3 callpeak -t ${BAM} --outdir peaks

# Clean up the generated files
clean:
	rm -rf ${R1} ${BAM} ${WIG}

# Run all the steps.
all: genome fastq align peaks

# These targets do not correspond to files.
.PHONY: all genome fastq align peaks demultimap clean