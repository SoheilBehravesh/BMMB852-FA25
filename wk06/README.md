*Hello* **Dr. Albert**

# Assignment for Week 6

### 1. Transform the script into a Makefile that includes rules for:
#### Obtaining the genome
#### Downloading sequencing reads from SRA

### 2. Your README.md should explain the use of the Makefile in your project.
The Makefile has three sections. The first is to define different parameters in the code such as the genome name, bioproject number, SRR number, URL to download the reads and other defining variables. It is worth to note that the first section can be adjusted, but there shouldn't be any change to the second and third section. The second section is setting up some useful defaults. And the third section contains multiple subsections such as rules to download the reference genome from NCBI and the sequencing reads from SRA using the defined parameters. Or if the reads coming from different SRR numbers, the user can add more rules to download those reads.