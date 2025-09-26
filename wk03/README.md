cd ~
mkkdir BMMB852-FA25
cd BMMB852-FA25
mkdir igv
cd igv
we get the fasta file as the sequence file of our organism to have the genome (what the identity is/ what the sequence is)
wget https://ftp.ensemblgenomes.ebi.ac.uk/pub/bacteria/current/fasta/bacteria_0_collection/acinetobacter_baumannii_aye_gca_000069245/dna/Acinetobacter_baumannii_aye_gca_000069245.ASM6924v1.dna.toplevel.fa.gz
unzip it
gunzip Acinetobacter_baumannii_aye_gca_000069245.ASM6924v1.dna.toplevel.fa.gz
change the name of the file to a more easy to read
mv Acinetobacter_baumannii_aye_gca_000069245.ASM6924v1.dna.toplevel.fa abaum.fa
using tools such as seqkit to look over the details stored in the file
seqkit stats abaum.fa
look at it with a different tool
cat aubaum.fa | greap ">"
since the fasta starts with a > sign, so we want to look for that lines and from the outputit will tell us how many plasmids and chromosomes are in the sequenced reference genome

now we want to get the annotation file (gff) to have the features of the genome (where the identity is/where the genes are)
wget https://ftp.ensemblgenomes.ebi.ac.uk/pub/bacteria/current/gff3/bacteria_0_collection/acinetobacter_baumannii_aye_gca_000069245/Acinetobacter_baumannii_aye_gca_000069245.ASM6924v1.62.gff3.gz

gunzip gunzip Acinetobacter_baumannii_aye_gca_000069245.ASM6924v1.62.gff3.gz 

mv Acinetobacter_baumannii_aye_gca_000069245.ASM6924v1.62.gff3 abaum.gff
