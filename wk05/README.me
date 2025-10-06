*Hello* **Dr. Albert**
# Assignment for Week 5

micromamba activate bioinfo
set -uex -o pipefail

# different ways to getting the SRA data
# 1) Download 1000 read pairs with fastq-dump into the reads directory
# fastq-dump -X 1000 -F --outdir reads --split-files SRR5790106
# Download a subset of 1000 reads using a URL
# URL=https://ftp.sra.ebi.ac.uk/vol1/fastq/SRR579/006/SRR5790106/SRR5790106.fastq.gz
# mkdir -p reads
# curl ${URL} --silent | gunzip -c | head -n 4000 > reads/myreads.fq
# 2) Download the file directily 
# wget ${URL} # you can also use curl ${URL}
# 3) Download the file with aria2
# -x 5: use 5 connections
# -c: continue download
# --summary-interval=10: print summary every 10 seconds
# aria2c -x 5 -c --summary-interval=10 ${URL}

# Obtain run metadata based on SRR number
# The metadata includes the URL to the reads!
# bio search SRR5790106
# Obtain run metadata based on PRJN number
# bio search PRJNA392446 # Produces JSON output
# bio search PRJNA392446 -H --csv # Produces CSV output

# Generate statistics on the reads
# seqkit stats reads/myreads.fq

# Generate a FastQC report.
fastqc reads/SRR1553607*.fastq

# Other recommended tools for generating qulaity control on FASTQ files are: fastp / cutadapt / trimmomatic 

# Set the trace
set -uex

# SRR number
SRR=SRR519926

# Number of reads to sample
N=10000

# The output read names
R1=reads/${SRR}_1.fastq
R2=reads/${SRR}_2.fastq

# Trimmed read names
T1=reads/${SRR}_1.trimmed.fastq
T2=reads/${SRR}_2.trimmed.fastq

# The adapter sequence
ADAPTER=AGATCGGAAGAGCACACGTCTGAACTCCAGTCA

# The reads directory
READS=reads

# The reports directory
REPORTS=reports

# ----- Only actions are below ----

# Make the necessary directories
mkdir -p ${READS} ${REPORTS}

# Download the FASTQ file
fastq-dump -X ${N} --split-files -O ${READS} ${SRR}

# Run fastqc
fastqc -o ${REPORTS} ${R1} ${R2}

# Run fastp and trim for quality
# There is a substantial difference between 
# --cut_tail vs --cut_right
# both trim in a window but one goes from 
# the right and the other from the left
fastp --adapter_sequence=${ADAPTER} \
      --cut_tail \
      -i ${R1} -I ${R2} -o ${T1} -O ${T2} 

# Run fastqc
fastqc -o ${REPORTS} ${T1} ${T2}

# Assumes that you have installed multiqc like so
# conda create -y -n menv multiqc 

# Run the multiqc from the menv environment on the reports directory
# The output of the tool is in the multiqc_report.html 
# the tool can summarize multiple fastqc reports into a single plot
micromamba run -n menv multiqc -o ${REPORTS} ${REPORTS}