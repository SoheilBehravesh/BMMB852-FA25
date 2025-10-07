set -uex -o pipefail
ACCESSION=AY632535.2

# Get the genome 
efetch -db nuccore -format fasta -id $ACCESSION > $ACCESSION.fa

# Get the annotation
efetch -db nuccore -format gff -id $ACCESSION > $ACCESSION.gff
efetch -db nuccore -format gtf -id $ACCESSION > $ACCESSION.gtf

# Another way to download the whole based on the GENOME accession number in dataset
# GENOME=GCF_000882815
# datasets download genome accession $GENOME --include gff3,gtf,genome
# unzip -n ncbi_dataset.zip