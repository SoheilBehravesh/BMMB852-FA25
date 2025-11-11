#
# This is a Makefile made by Soheil Behravesh skb6394@psu.edu

# -------------- Useful Options for the Makefile --------------

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


# -------------- Setting up the Parameters --------------

# NCBI Genome accession number  
ACC=AY632535.2
# NCBI Genome number
GEN=GCF_000882815

# The user-friendly name for the genome
NAME=zika_mr766

# Parameters set for the specific reads
# Bioproject number
BPN=PRJNA313294 
# SRR numbers
SRR=SRR3191544
# URL to download the reads
URL=https://trace.ncbi.nlm.nih.gov/Traces/?run=${SRR}


# Reference genome
REF=ref/${NAME}.fa

# Read 1
R1=reads/${SRR}_1.fastq
# Read 2
R2=reads/${SRR}_2.fastq
# How many reads to download
N=100000

# BAM files
BAM=bam/${SRR}.bam
# The temporary bedgraph files
BG=bam/${SRR}.bedgraph
# The BW wiggle files
BW=bam/${SRR}.bw

# VCF Variables 
# The variant file.
VCF = vcf/$(notdir $(basename ${BAM})).vcf.gz
# Additional bcf flags for pileup annotation.
PILE_FLAGS =  -d 100 --annotate 'INFO/AD,FORMAT/DP,FORMAT/AD,FORMAT/ADF,FORMAT/ADR,FORMAT/SP'
# Additional bcf flags for calling process. Pay attention to this, if your organism is diploid, the ploidy should set to 2.
CALL_FLAGS = --ploidy 1 --annotate 'FORMAT/GQ'

# snpEff parameters (local database built from the REF and GFF)
# SNEFF_DB: name of the snpEff genome/database (choose simple name, e.g. zika_mr766)
SNEFF_DB = ${NAME}
# Where snpEff keeps its data directory; default is ./snpEff/data but users may overwrite
SNEFF_DIR = snpEff/data
# Local copy of the reference GFF/FASTA to feed snpEff build (will be copied into SNEFF_DIR/${SNEFF_DB})
SNEFF_GFF = ${REF:.fa=.gff}
SNEFF_FASTA = ${REF}
# Path to the snpEff jar (optional). If empty, assume snpEff is on PATH as `snpEff` and `snpEff.jar` not required.
SNEFF_JAR =


# -------------- No Changes Below This Line --------------

# Prints the usage message
usage:
	@echo "#"
	@echo "# Makefile for downloading genome/read data, QC, alignment, coverage (wiggle), VCF calling and annotation"
	@echo "# Targets overview:"
	@echo "#  ref        - download and prepare reference files"
	@echo "#  read       - download reads"
	@echo "#  qc         - run FastQC on reads"
	@echo "#  align      - align reads, produce BAM and index"
	@echo "#  wiggle     - produce bedgraph and bigWig from BAM"
	@echo "#  stats      - alignment statistics (flagstat, coverage)"
	@echo "#  vcf        - call variants (produces ${VCF} and index)"
	@echo "#  snpeff-db  - build a local snpEff database from REF+GFF"
	@echo "#  annotate-vcf - annotate the called VCF with snpEff (produces annotated .annot.vcf.gz)"
	@echo "#  clean      - remove generated files (BAMs, VCFs, snpEff DB)"
	@echo "# Usage: make [all|ref|read|qc|align|wiggle|stats|vcf|snpeff-db|annotate-vcf|clean]"
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

qc:
	# Run FastQC on the reads
	mkdir -p qc
	fastqc -o qc ${R1} ${R2}


# Align the reads and convert to BAM. Use 4 threads
# Works for paired-end reads. Modify for single-end reads.
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

# -------------------- snpEff integration --------------------
# Build a local snpEff database from the provided FASTA and GFF.
# This target will create the directory ${SNEFF_DIR}/${SNEFF_DB} and copy the FASTA/GFF
# into it, then invoke snpEff build. It expects either `snpEff` on PATH or SNEFF_JAR set.
snpeff-db:
	@echo "Preparing snpEff DB '${SNEFF_DB}' in '${SNEFF_DIR}'"
	mkdir -p ${SNEFF_DIR}/${SNEFF_DB}
	# copy fasta and gff into the snpEff data directory (portable, do not overwrite existing files)
	if [ ! -f ${SNEFF_DIR}/${SNEFF_DB}/sequences.fa ]; then \
		cp ${SNEFF_FASTA} ${SNEFF_DIR}/${SNEFF_DB}/sequences.fa; \
		chmod 644 ${SNEFF_DIR}/${SNEFF_DB}/sequences.fa; \
	fi
	if [ ! -f ${SNEFF_DIR}/${SNEFF_DB}/genes.gff ]; then \
		cp ${SNEFF_GFF} ${SNEFF_DIR}/${SNEFF_DB}/genes.gff; \
		chmod 644 ${SNEFF_DIR}/${SNEFF_DB}/genes.gff; \
	fi
	# also copy the fasta into the genomes dir expected by some snpEff workflows
	mkdir -p ${SNEFF_DIR}/genomes
	if [ ! -f ${SNEFF_DIR}/genomes/${SNEFF_DB}.fa ]; then \
		cp ${SNEFF_FASTA} ${SNEFF_DIR}/genomes/${SNEFF_DB}.fa; \
		chmod 644 ${SNEFF_DIR}/genomes/${SNEFF_DB}.fa; \
	fi

	# Build the snpEff database. Prefer snpEff CLI if available, otherwise try the jar.
	@if command -v snpEff >/dev/null 2>&1; then \
		snpEff build -v -gff3 -datadir snpEff/data ${SNEFF_DB}; \
	elif [ -n "${SNEFF_JAR}" ]; then \
		java -Xmx2g -jar ${SNEFF_JAR} build -v -gff3 -datadir snpEff/data ${SNEFF_DB}; \
	else \
		echo "ERROR: snpEff not found on PATH and SNEFF_JAR is empty. Install snpEff or set SNEFF_JAR." >&2; exit 1; \
	fi

# Annotate the called VCF with snpEff. Requires snpeff-db to be run once first.
# Produces ${VCF} annotated as ${VCF%.vcf.gz}.annot.vcf.gz and an index.
ANN_VCF = $(patsubst %.vcf.gz,%.annot.vcf.gz,${VCF})

annotate-vcf: snpeff-db ${VCF}
	@echo "Annotating ${VCF} with snpEff database ${SNEFF_DB} -> ${ANN_VCF}"
	# Run snpEff annotate; prefer CLI if available
	@if command -v snpEff >/dev/null 2>&1; then \
		snpEff -v -datadir snpEff/data ${SNEFF_DB} ${VCF} | bgzip -c > ${ANN_VCF}; \
	else \
		if [ -n "${SNEFF_JAR}" ]; then \
			java -Xmx2g -jar ${SNEFF_JAR} eff -v -datadir snpEff/data ${SNEFF_DB} ${VCF} | bgzip -c > ${ANN_VCF}; \
		else \
			echo "ERROR: snpEff not found and SNEFF_JAR not set. Cannot annotate." >&2; exit 1; \
		fi; \
	fi
	# index the annotated VCF
	bcftools index -t -f ${ANN_VCF}
	@ls -lh ${ANN_VCF}

# Clean up generated files
clean:
	# remove alignment and intermediate files
	rm -rf ${REF} ${R1} ${R2} ${BAM} ${BAM}.bai
	# remove VCFs and indexes
	rm -f ${VCF} ${VCF}.tbi
	# remove annotated VCFs
	rm -f $(patsubst %.vcf.gz,%.annot.vcf.gz,${VCF}) $(patsubst %.vcf.gz,%.annot.vcf.gz.tbi,${VCF})
	# NOTE: snpEff data is preserved by default. Use 'make clean-snpEff' to remove it.

# Remove only annotated VCFs (keeps main VCF)
clean-annot:
	@echo "Removing annotated VCFs"
	rm -f $(patsubst %.vcf.gz,%.annot.vcf.gz,${VCF}) $(patsubst %.vcf.gz,%.annot.vcf.gz.tbi,${VCF})


# Remove snpEff database/data directory
clean-snpEff:
	@echo "Removing snpEff data directory ${SNEFF_DIR}"
	rm -rf ${SNEFF_DIR}

# Create necessary directories
all: ref read qc align wiggle stats vcf snpeff-db annotate-vcf
refs: ref
reads: read qc align wiggle stats
readsvcf: read qc align wiggle stats vcf
snpeff: snpeff-db annotate-vcf

# Create necessary directories
.PHONY: all ref read qc align wiggle stats vcf snpeff-db annotate-vcf clean clean-annot clean-snpEff
