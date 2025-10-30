*Hello* **Dr. Albert**
Assignment for Week 8

#### Identify the sample names that connect the SRR numbers to the samples.
This repository provides a reproducible pipeline to:
1) download the Zika MR-766 reference genome and annotations,
2) download one SRA run (SRR) as FASTQ,
3) align reads to the viral reference,
4) generate BigWig coverage tracks, and
5) export alignment statistics.

The main code for these steps are in the Makefile, which ables us to define various of targets based on the aim of each step. 
The *first step* can be run once because it downloads the reference genome, Zika MR-766, then each of the reads could be align to it. The first step assigned as the target 'ref' in the Makefile. 
```bash
# to generate all the necessary files such as reference genome
make ref
```
the reading data comes from the paper done by Tong et al (DOI: 10.1016/j.stem.2016.02.016) on Zika Virus and contains 8 different reads. 4 of them are single end reads and the other 4 is paired end read. The bioproject number for the study is PRJNA313294. Therefore, the other *four steps* (including 2-5) should be run for each of the reads, that's why we have to run these four steps for each of the reads individually. 
#### Create a design.csv file that connects the SRR numbers to the sample names.
Since there are many reads (RNA-seq) from the paper and we need to automate and paralellize the algnment of the reads to the genome, so we with the following code we download the metadata from the study. But it is important to note that creating the metadata from many studies is not that simple. There are two way to do this, one is to get the data connected to one of the read that we used in the Makefile, and the other is to use bio project number to find and download all the reads of that study. 
```bash
# To use the SRA website to get sample names connected to SRR numbers
# bio search SRR1972976 -H --csv > metadata.csv

# Get metadata for a BioProject
bio search PRJNA313294 -H --csv > design.csv
```
#### Create a Makefile that can produce multiple BAM alignment files (you can reuse the one from the previous assignment) where from an SRR you can produce a BAM alignment file named after the sample name.
It has been generated as the Makefile
#### Using GNU parallel run the Makefile on all (or at least 10) samples.
we will use the follwing code to run the steps 2 to 5 for the samples in one go or better to say in parallel. so, the following code will take the makefile and first, download the reads, then run the alignments for each of the reads. Additionally, it generates coverage graphs and tracks for the display. Last, it will save the statistics and coverage for each of the reads in the folder 'stats' for your reference. We can also use --dry-run to preview what the code will execute.
```bash
# the following lines of code, first get the data for each read, then align each of them to the ref genome, and finally make wiggle and stat for each of the reading
cat design.csv | parallel --colsep , --header : --eta -j 4 'make reads SRR={run_accession}'
```
The code also set the column seperato as comma and tells the parallel that the first line in csv dile is a header. the jobs (-j) set up to 4 to run 2 job simultaneously. --eta is for showing the estimated time of completion.
#### Create a README.md file that explains how to run the Makefile
