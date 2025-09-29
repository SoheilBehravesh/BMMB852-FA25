*Hello* **Dr. Albert**
# Assignment for week 4

### Identify the accession numbers for the genome and write the commands to download the data. Make your commands reusable and reproducible.
In the paper, authors derived the human induced pluripotent stem cells to the cortical neural progenitor cells and then infected the cells with the zika virus strain MR-766. That's why the sample organism of the GEO show the host cell as the homo sapiens, not the virus. the GEO number (GSE78711) points to the  project number PRJNA313294 and SRA SRP070895 which are from the human cells. if I align the 8 RNA-seq libraries to human reference genome, I can analyse it for the host cells and if I align it with the MR-766 genome, I can quantify the viral genome infected the human cells. but form the assignment, I assume I should look for the genome of the zika virus strain MR-766 as reference genome.

```bash
micromamba activate bioinfo
cd ~/BMMB852-FA25/wk04/
makdir data
cd data

# Now there are 3 ways to download the compelte genome:

# I've got the following genebank id and its related refseq from genebank. the paper actually cited the paper which isolate the genome in 1952, but I could not find the specific sequence of that paper.

# 1
# Get FASTA file for accession number AY632535 in FASTA format.
efetch -db nuccore -format fasta -id AY632535.2 > AY632535.2.fa

# 2nd way to get the genome in FASTA format
bio fetch NC_012532.1 -format fasta > NC_012532.1.fa

# efetch -db nucleotide -format fasta -id LC002520.1 > zikv_mr766_LC002520.fasta
# efetch -db nucleotide -format fasta -id KU955594.1 > zikv_mr766_KU955594.fasta
# to doenload the independant deposit

# the following genome is found in the dataset of ncbi. 5 genome assemblies will shown, and from them one is form MR766 strain. this genome I think is different from the #1 and #2, so I will download both reference genome for comparison.
#3 Download genome assembly for accession number.
datasets download genome accession GCF_000882815 --include gff3,gtf,genome
unzip -n ncbi_dataset.zip
# to check the files you can:
# cd ~/BMMB852-FA25/wk04/data/ncbi_dataset/data/GCF_000882815.3/
# ls -l 

#genome summary
# Get summary for genome for accession number.
datasets summary genome accession GCF_000882815.3 | jq
#The release date for this genome number is 2009
```
### Now use IGV to visualize the genome and the annotations relative to the genome.
##### As a bioinformatician you should develop an ability to evaluate what you see.

### How big is the genome, and how many features of each type does the GFF file contain? What is the longest gene? What is its name and function? You may need to search other resources to answer this question. Look at other gene names. Pick another gene and describe its name and function.
```bash
cd ~/BMMB852-FA25/wk04/data/ncbi_dataset/data/GCF_000882815.3/
mv GCF_000882815.3_ViralProj36615_genomic.fna zikv_mr766.fa
mv genomic.gff zikv_mr766.gff 
seqkit stats zikv_mr766.fa
```
*how big is the genome?*
there is just one sequence with the length of 10794

*how many features of each type does the GFF file contain?*
```bash
cat zikv_mr766.gff | wc -l
```
there are 27 lines in the file

```bash
cat zikv_mr766.gff | grep -v '#' > zikv_mr766.gff # to remove the lines starts with # sign
cat zikv_mr766.gff | cut -f 3 | sort | uniq -c | sort -r -n | head
```
there are 6 different fewatures existed in the gff file.
14  mature_protein_region_of_CDS
1   three_prime_UTR
1   region
1   gene
1   five_prime_UTR
1   CDS

*What is the longest gene? What is its name and function?*
```bash
grep -P '\tgene\t' zikv_mr766.gff > zikv_mr766_gene.gff
cat zikv_mr766_gene.gff | more
```
ther is just one gene in the annotated file. the POLY gene starts from the nucleotide number 107 to 10366. this is a protein coding gene and encode genome polyprotein. This gene has 3419 aa. the protein encoded by this gene has different sections that each has its own function. for example, capsid protein C that its location is from 12 to 102, plays a role in virus budding and binding to the host cell membrane and also inhibit RNA silecing by interfering with host Dicer. Or envelope protein E binds to host cell receptors and mediates fusion between viral and cellular membrane.
Following are the names of the protein that encoded by this POLY gene:
capsid protein C
membrane glycoprotein precursor prM
envelope protein E
nonstructural protein NS1
nonstructural protein NS2A
nonstructural protein NS2B
nonstructural protein NS3
nonstructural protein NS4A
nonstructural protein NS4B
RNA-dependent RNA polymerase NS5
anchored capsid protein ancC
protein pr
membrane glycoprotein M
protein 2K
### Look at the genomic features, are these closely packed, is there a lot of intragenomic space? Using IGV estimate how much of the genome is covered by coding sequences.
the length of the genome is 10794, and the POLY gene is from 107 to 10366 (orf2) 
so 106nt for 5'UTR
10260 nt for POLY gene (coding sequence)
428nt 3'UTR

### Find alternative genome builds that could be used to perhaps answer a different question (find their accession numbers). 
the code for the alternative sequences written in the first question. However, if we are looking for the other strains, we could look for the Natal RGN strain with the accession number of GCA_002366285.1. 

### Considering the focus of the paper, think about what other questions you could answer if you used a different genome build.
what woould be the difference between the strains? we could also conduct a population study and look at the evolution of the virus by comparing the genome contributed to the different outbreak of the virus. For example how the capsid protein C or E would be different in different phylogenies? how does the variation at the ppopulation level would contribute to the evolution of the virus? what is the difference between the sequence of the virus that infect humans vs mosquito vs monkey?

### Write and submit your report to your repository.