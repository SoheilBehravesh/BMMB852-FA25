*Hello* **Dr. Albert**
Assignment for Week 8

#### Identify the sample names that connect the SRR numbers to the samples.
the reading data comes from the paper done by Tong et al (DOI: 10.1016/j.stem.2016.02.016) on Zika Virus and contains 8 different reads. 4 of them are single end reads and the other 4 is paired end read. the bioproject number of the study is PRJNA313294. 

```bash
make all
```
#### Create a design.csv file that connects the SRR numbers to the sample names.
Since there are many reads from the paper and we need to automate and paralellize the algnment of the reads to the genome, so we with the following code we download the metadata from the study. But it is important to note that creating the metadata from many studies is not that simple. There are two way to do this, one is to get the data connected to one of the read that we used in the Makefile, and the other is to use bio project number to find and download all the reads of that study. 
```bash
# To use the SRA website to get sample names connected to SRR numbers
# bio search SRR1972976 -H --csv > metadata.csv

# Get metadata for a BioProject
bio search PRJNA313294 -H --csv > design.csv
```
#### Create a Makefile that can produce multiple BAM alignment files (you can reuse the one from the previous assignment) where from an SRR you can produce a BAM alignment file named after the sample name.
It has been generated as the Makefile
#### Using GNU parallel run the Makefile on all (or at least 10) samples.
Since there are many reads or RNA-seq genetared by the study so we want to run the alignements of the samples in one go or better to say in parallel. so, the following code will take the makefile and run the alignments for each of the reads. We can use --dry-run to preview what the code will execute.
```bash
# to generate all the necessary files such as reference genome
make all

# the following lines of code, first get the data for each read, then align each of them to the ref genome, and finally make wiggle and stat for each of the reading
$ parallel --colsep ',' --header : --eta -j 4   'make -s S
RR={run_accession} reads'   :::: design.csv
```
the jobs (-j) set up to 4 to run 2 job simultaneously. --eta is for showing the estimated time of completion. 
#### Create a README.md file that explains how to run the Makefile
