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
wget https://hgdownload.soe.ucsc.edu/goldenPath/hg38/chromosomes/chr22.fa.gz
touch README.md
touch Makefile
touch design.csv
```
Running the following line of code will create a folder *src* that contains different folders with already prepared makefiles for different purposes, especially the prepared Makefiles in *src/run*. each of the Makefiles can be modified to fit it to the need of the analysis.
```bash
bio code
```




