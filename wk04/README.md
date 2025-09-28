*Hello* **Dr. Albert**
# Assignment for week 4

#### Identify the accession numbers for the genome and write the commands to download the data. Make your commands reusable and reproducible.
In the paper, authors derived the human induced pluripotent stem cells to the cortical neural progenitor cells and then infected the cells with the zika virus strain MR-766. That's why the sample organism of the GEO show the host cell as the homo sapiens, not the virus. the GEO number (GSE78711) points to the  project number PRJNA313294 and SRA SRP070895 which are from the human cells. if I align the 8 RNA-seq libraries to human reference genome, I can analyse it for the host cells and if I align it with the MR-766 genome, I can quantify the viral genome infected the human cells. but form the assignment, I assume I should look for the genome of the zika virus strain MR-766 as reference genome.

```bash
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


#### Now use IGV to visualize the genome and the annotations relative to the genome.

##### As a bioinformatician you should develop an ability to evaluate what you see.

#### How big is the genome, and how many features of each type does the GFF file contain? What is the longest gene? What is its name and function? You may need to search other resources to answer this question. Look at other gene names. Pick another gene and describe its name and function.

#### Look at the genomic features, are these closely packed, is there a lot of intragenomic space? Using IGV estimate how much of the genome is covered by coding sequences.

#### Find alternative genome builds that could be used to perhaps answer a different question (find their accession numbers). Considering the focus of the paper, think about what other questions you could answer if you used a different genome build.

#### Write and submit your report to your repository.