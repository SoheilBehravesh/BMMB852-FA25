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
ACC=NC_007793.1
# NCBI Genome number
GEN=GCF_000013465.1

# The user-friendly name for the genome
NAME=staphylcoc_aur

# Parameters set for the specific reads
# Bioproject number
BPN=PRJNA887926 
# SRR numbers
SRR=SRR21835896
# URL to download the reads
URL=https://trace.ncbi.nlm.nih.gov/Traces/?run=${SRR}

# The directory that holds the index.
IDX_DIR = $(dir ${REF})/idx
# The name of the index
IDX ?= ${IDX_DIR}/$(notdir ${REF})
# A file in the index directory.
IDX_FILE ?= ${IDX}.1.ht2


# Reference genome
REF=ref/${NAME}.fa
#Reads
R=reads/${SRR}*.fastq
# Read 1
R1=reads/${SRR}_1.fastq
# Read 2
R2=reads/${SRR}_2.fastq
# How many reads to download
N=300000

# BAM files
BAM=bam/${SRR}.bam
# The temporary bedgraph files
BG=bam/${SRR}.bedgraph
# The temporary bedgraph files (used by bedGraphToBigWig)
BGR=bam/${SRR}.bedgraph
# The BW wiggle files (bigWig)
WIG=bam/${SRR}.bw

# fasta index (samtools faidx) for the reference
FAI=${REF}.fai


# Number of CPUS
NCPU ?= 2
# Additional flags to pass to HISAT.
HISAT2_FLAGS ?= --threads ${NCPU} --sensitive


usage:
	@echo "Usage:"
	@echo " # make ref                # Download and index the reference genome"
	@echo " # make bam TECH=<tech> BAM_URL=<address>   # Download BAM file, extract region, index, run samtools stats, and generate bigwig "
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

read:
	# Make the reads directory if it already not exists
	mkdir -p $(dir ${R1})
	# Download the reads
	fastq-dump --outdir reads --split-files ${SRR}

# Reads must exist.
${R1}:
	@echo "# file not found: R1=${R1}"
	@exit -1

${REF}:
	@echo "# file not found: REF=${REF}"
	@exit -1

# Build the index for the reference genome.
${IDX_FILE}: 
	@if [ ! -f ${REF} ]; then
		echo "# file not found: REF=${REF}";
		exit -1
	fi
	mkdir -p $(dir $@)

	# Unzip the reference if it is gzipped.
	if [ "$(suffix ${REF})" = ".gz" ]; then
		# Unzip if the file is only found in compressed format.
		[ ! -f "$${REF%.*}" ] && gunzip -k "$$REF"
		hisat2-build --threads ${NCPU} $(basename ${REF}) ${IDX};
	else
		hisat2-build --threads ${NCPU} ${REF} ${IDX};
	fi

# Create the index.
index: ${IDX_FILE}
	@echo "# hisat2 index: ${IDX}"

# Remove the index.
index!:
	rm -rf ${IDX_FILE}

# If R2 is empty, use the single-end command.
ifeq (${R2},)
CMD = hisat2 ${HISAT2_FLAGS} ${RG} -x ${IDX} -U ${R1}
else
CMD = hisat2 ${HISAT2_FLAGS} ${RG} -x ${IDX} -1 ${R1} -2 ${R2}
endif

# Perform the alignment.
${BAM}: ${R1} ${R2}
	@if [ ! -f ${IDX_FILE} ]; then
		echo "# hisat2 index not found: IDX=${IDX}";
		exit -1
	fi
	@mkdir -p $(dir $@)
	${CMD} | samtools sort -@ ${NCPU} > $@

# Create the BAM index file.
${BAM}.bai: ${BAM}
	samtools index ${BAM}

# Generate the alignment.
align: ${BAM}.bai
	@ls -lh ${BAM}

# Create the fasta index file.
${FAI}: ${REF}
	samtools faidx ${REF}

${BGR}: ${BAM}
	mkdir -p $(dir ${BGR})
	LC_ALL=C; bedtools genomecov -ibam ${BAM} -split -bg | sort -k1,1 -k2,2n > ${BGR}

# Creates the bigwig file.
${WIG}: ${FAI} ${BGR}
	mkdir -p $(dir ${WIG})
	bedGraphToBigWig ${BGR} ${FAI} ${WIG}

# Generate the wiggle file.
wig: ${WIG}
	@ls -lh ${WIG}

run: align wig
	@echo "# All done!"

.PHONY: ref index read run