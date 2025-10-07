# Set the trace
set -uex -o pipefail

# SRR number
SRR=SRR3194431

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
# micromamba run -n menv multiqc -o ${REPORTS} ${REPORTS}