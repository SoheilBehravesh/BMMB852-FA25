set -uex -o pipefail
ACCESSION=AY632535.2
GENOME=GCF_000882815
# Get the genome 
efetch -db nuccore -format fasta -id $ACCESSION > $ACCESSION.fa

# Get the annotation
datasets download genome accession $GENOME --include gff3,gtf,genome
unzip -n ncbi_dataset.zip