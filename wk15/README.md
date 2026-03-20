*Hello* **Dr. Albert**
# Assignment for week 15 - Epigenomic mapping regulates cell identity in bladder cancer
### Info on the paper used for reproducing the data
Link to the paper: Epigenomic mapping identifies an enhancer repertoire that regulates cell identity in bladder cancer through distinct transcription factor networks Oncogene. 2023 Mar 22;42(19):1524–1542
SRA BioProject ID: PRJNA798359
subset of data: SRR17653520

We aim to reproduce the findings from the paper. First, in order to focus and develope the analysis, we will work on one million reads (N=1M) from a single sample (SRR17653520). And we just align the reads to chromosome 22 (https://hgdownload.soe.ucsc.edu/goldenPath/hg38/chromosomes/chr22.fa.gz)

Prepare the environment and necessary files
```bash
micromamba activate bioinfo
touch README.md
touch Makefile
touch design.csv
```
Running the following line of code will create a folder *src* that contains different folders with already prepared makefiles for different purposes, especially the prepared Makefiles in *src/run*. each of the Makefiles can be modified to fit it to the need of the analysis.
```bash
bio code
```
Now, let's start using the pre prepared Makefiles. The first step is to download the reference data (FASTA) which is for now is only chromosome 22. We are going to use the *curl.mk* makefile.
```bash
URL=https://hgdownload.soe.ucsc.edu/goldenPath/hg38/chromosomes/chr22.fa.gz
make -f src/run/curl.mk URL=${URL} run
```
The downloaded reference is a gzip file, but for the downstream analysis, the samtools needs a bgzip file. Therefore, we have to recompress the gzip file to bgzip file by the *bgzip.mk* makefile.
```bash
REF=refs/chr22.fa.gz
make -f src/run/bgzip.mk FILE=${REF} run
```
Now, we have to index the reference genome by *bwa* to align the reads (which will be downloaded in the next step) to the reference genome, chromosome 22 here.
```bash
make -f src/run/bwa.mk REF=${REF} index
```

