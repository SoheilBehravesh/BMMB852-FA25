*Hello* **Dr. Albert**
# Assignment for Week 5

### Continue from last week:
#### Review the scientific publication you studied previously.
#### Identify the BioProject and SRR accession numbers for the sequencing data associated with the publication.
PRJNA313294 and SRP070895

### Write a Bash script:
#### Reuse and expand your code from last week.
#### Create a bash shell script with the code from last week.
```bash
micromamba activate bioinfo
cd ~/BMMB852-FA25/wk05
touch get_genome.sh
```
get_genome.sh script has been created from the last week code to get the genome based on accession number plus gff, gft, and again genome from genome dataset. 
```bash
bash get_goneme.sh
```
#### Add commands to download at least one sequencing dataset using the SRR number(s).
Using the following code to check the sequence read archives from the project or the SRP number
```bash
bio search PRJNA313294
# or
# bio search SRP070895
``` 
Now, run the following code to extract the SRR nunmbers
```bash
bio search SRP070895 | jq -r '.[].run_accession' > sra_ids.txt
cat sra_ids.txt

# we can also do it this way:
# Obtain run metadata based on SRR number
# The metadata includes the URL to the reads!
# bio search SRP070895
# Obtain run metadata based on PRJN number
# bio search PRJNA313294 # Produces JSON output
# bio search PRJNA313294 -H --csv # Produces CSV output
```

different ways to getting the SRA data:
```bash
# 1) Download 1000 read pairs with fastq-dump into the reads directory that specified by the SRR number
#fastq-dump -X 1000 -F --outdir reads --split-files SRR5790106
# Download a subset of 1000 reads using a URL
# URL=https://ftp.sra.ebi.ac.uk/vol1/fastq/SRR579/006/SRR5790106/SRR5790106.fastq.gz
# mkdir -p reads
# curl ${URL} --silent | gunzip -c | head -n 4000 > reads/myreads.fq
# 2) Download the file directily 
# wget ${URL} # you can also use curl ${URL}

# 3) Download the file with aria2 (More preferable)
# -x 5: use 5 connections
# -c: continue download
# --summary-interval=10: print summary every 10 seconds
# aria2c -x 5 -c --summary-interval=10 ${URL}
```
However, below the 1st way to donwloadoing the srr data is modified to reduce the time and lines of code, and enhance the script
```bash
# make the output dir
mkdir -p reads

# loop over each SRR in sra_ids.txt and run your exact command
while read -r SRR; do
  fastq-dump -X 1000 -F --outdir reads --split-files "$SRR"
done < sra_ids.txt
```
Now if we list the files in the reads directory, we will see the downloaded files. 4 out of 8 are pair ended that's why we saw 2 seperate files as we set the parameter to split files, the other remaining 4 are single ended so we saw only one file.

#### Download only a subset of the data that would provide approximately 10x genome coverage. Briefly explain how you estimated the amount of data needed for 10x coverage.
ok, the formula is as follows:
Coverage (C) = (N * L) / G or N = (C * G) / L (in single end reads)
N = (C * G) / (L * 2) (in paired end reads)
Where: C = coverage, N = number of reads, L = read length, G = genome size (for Zika MR766 = 10,794 bp)
for tthe assignment, for a single ended read:
```bash
bio search SRR3194431
```
The result of the first will bee 5008.8/66.5 million = 75.3 ~ 75 bp
So, N = (10 * 10794) / 75 = 1439.92 ~ 1440 reads
So, we need to download -x 1440 to get approximately 10x genome coverage

### Quality assessment:

#### Generate basic statistics on the downloaded reads (e.g., number of reads, total bases, average read length).
```bash
seqkit stats reads/SRR3194431_1.fastq
```
number of reads=1000, total bases=75467, average read length=75.5
#### Run FASTQC on the downloaded data to generate a quality report.
```bash
bash fastqc.sh
```
#### Evaluate the FASTQC report and summarize your findings.
The quality score is good, the per base sequence quality is high, the per sequence quality scores is also good, the per base sequence content is not good as the A and T are higher than G and C and earcly cycles sho the proportion far from 25% but the internet says that's a known artifact in RNA-seq data because of existing random-hexame priming and 5' bias. the per sequence GC content is not good as it is not a normal distribution but this might resulted because the human transcriptomes are not uniform, the sequence length distribution is not good, the duplication levels is passed, the overrepresented sequences is not good as it shows some overrepresented sequences, the adapter content is good as it shows no adapter content. Overall, it looks like the quality of the reads is good but not the best.
### Compare sequencing platforms:
#### Search the SRA for another dataset for the same genome, but generated using a different sequencing platform (e.g., if original data was Illumina select PacBio or Oxford Nanopore).
https://www.ncbi.nlm.nih.gov/sra/?term=PRJNA798536
SRX13837383: WGS of Zika virus
1 OXFORD_NANOPORE (MinION) run: 3.6M spots, 1.7G bases, 1.5Gb downloads
Design: Zika virus-specific primers were designed and used for library preparation.
Submitted by: Seoul National University College of Medicine
Study: Zika virus Raw sequence reads
PRJNA798536 • SRP355884 • All experiments • All runs
show Abstract
Sample: Viral sample from Zika virus
SAMN25079586 • SRS11715301 • All experiments • All runs
Organism: Zika virus
#### Briefly compare the quality or characteristics of the datasets from the two platforms.
It is also single ended sequence
```bash
mkdir -p nanopore
cd nanopore
# copy fastqc.sh into nanopore directory and change the SRR to SRR17673905
bash fastqc.sh
```
the new reported QC for the seuence from nanopore is not good as illumina. It has more warnings and fails. For example, per-base quality was passed with illumina with high Q across cycles, but with nanopore it failed with variable ! across length. Or here we get warning for per-sequence quality scores, while it was passed with illumina. for the per-sequence GC content, here it fails but with illumina we received warning. overall, the seuqnce by illumina has clean short reads while here it was heterogenous with low quality.
