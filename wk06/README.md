*Hello* **Dr. Albert**

# Assignment for Week 6

### 1. Transform the script into a Makefile that includes rules for:
#### Obtaining the genome
#### Downloading sequencing reads from SRA

### 2. Your README.md should explain the use of the Makefile in your project.
The Makefile has three sections. The first is to define different parameters in the code such as the genome name, bioproject number, SRR number, URL to download the reads and other defining variables. It is worth to note that the first section can be adjusted, but there shouldn't be any change to the second and third sections The second section is setting up some useful defaults. And the third section contains multiple subsections such as rules to download the reference genome from NCBI and the sequencing reads from SRA using the defined parameters. the targetss in the third section are as follows:
usage: display the usage of the Makefile
ref: download the reference genome and the annotation files from NCBI using efetch
read: download the sequencing reads from SRA using bio command and aria2c for faster downloading
align: align the reads to the reference genome using minimap2 and generate a sorted and indexed BAM file.
stat: show some stats about the genome using seqkit
clean: remove all generated files and directories to start fresh
all: create the necessary files and directories by calling the other targets in order: ref, read, align, stats, and clean.

the make file can be run as dollows:
```bash
make all
```
This command will execute all the targets in the Makefile in the specified order.

Some notes:
The 'N' variable already set to 10k, but if we want 10x coverage such as the previous week assignment, it should be set to 1440 for Zika virus.

One note to be consider is that, for simplicity I put one read in the makefile. But if the read contains multiple SRRs, the following code can be used. However, I tested the makefile once with the foloowing codes for multiple SRRs but it does not work. SRR=SRP070895 which contains multiple SRRs. So I switched to one SRR (SRR3194431) for simplicity.
```bash
download the reads:
	# Get the reads from the source and make a text file with SRR ids
	bio search ${SRR} | jq -r '.[].run_accession' > sra_ids.txt
	cat sra_ids.txt
	# make the output dir
	mkdir -p reads
	# loop over each SRR in sra_ids.txt and run your exact command
	while read -r SRR; do
		fastq-dump -X 1000 -F --outdir ${R1} --split-files "${SRR}"
	done < sra_ids.txt
```
I was wondering what would be wrong with this approach for multiple SRRs. I think the issue here will be that the SRR number for the project that contain multiple reads in this, can not be processsed further, because thsi is not a real SRR number compare to the real read of i.e. SRR3194431. Could this be right?

I also wanted to download the reads from the following code:
```bash

	# -x 5: use 5 connections
	# -c: continue download
	# --summary-interval=10: print summary every 10 seconds
	aria2c -x 5 -c --summary-interval=10 ${URL}
```
first i tried it in the makefile but it failed. the reason could be that the downlaoded file is a gzip format, so I have to define another step to gunzip it and then use it. am i right? sorry for asking this because of the time i couldn't try it out. after submission I will go for it. 

Also, the clean step is makrked with #, because I didn't want to delete the generated files while testing the makefile. but in the final version it should be uncommented.

An important question: about downloading genome assembly from NCBI in the download the genome target
I don't know if that would work or no, so that's why I bringing this up here to check the validity with you. I am thinking of using the genome assembly (GCF) to downlaod the reference genome and the annotation. And then use wildcard '*' to chaange the name of the files. Something like this under the target in Makefile:
```bash
GCF=GCF_000882815
datasets download genome accession ${GCF} --include gff3,gtf,genome
unzip -n ncbi_dataset.zip
mv *.fa ${NAME}.fa
mv *.gff ${NAME}.gff
mv *.gtf ${NAME}.gtf
```
I don't knwo if this approach would work or not. but anyway, will continue the assignment and if you were positive about it, I will add it to the Makefile from the next session.

### 3. Add the following targets to the Makefile:
#### index: Index the genome
#### align: Generate a sorted and indexed BAM file by aligning reads to the genome
I have used minimap2 to align the reads to the genome and based on using minimap2 since indexing adds little additional benefit for it, so I skipped the indexing part. 

### 4. Visualize the resulting BAM files for both simulated reads and reads downloaded from SRA.


### 5. Generate alignment statistics for the BAM file.
#### What percentage of reads aligned to the genome?
#### What was the expected average coverage?
#### What is the observed average coverage?
#### How much does the coverage vary across the genome? (Provide a visual estimate.)
