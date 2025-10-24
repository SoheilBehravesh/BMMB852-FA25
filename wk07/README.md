*Hello* **Dr. Albert**

# Assignment for Week 7

### Add additional code to your Makefile to also create bigWig coverage tracks. See the WIGGLE: Genome coverage page for code.
Deleted targets and adjustments from the Makefile of Week 6:
a) Indexing the reference has been eliminated, because I will use minimap2, which does not required index file of the FASTA.
b) the N adjusted to 10000, because number of reads and coverage from the N=1440 is less and maybe will be good to understand the comparison between these two reads. Additionaly it will be enable the code to be fast and at the same time have enough number of reads and coverage to check for it. We can also download the whole reads but it will take more than 5-10mins for the whole analysis, so we will stick to N=10000.

Further changes for the week 7 assignment will be included based on answering the following questions.

### In your README.md, demonstrate the use of your Makefile to generate a BAM file for both the original data and the second sequencing data obtained with a different instrument.

### Visualize the GFF annotations and both wiggle and BAM files in IGV.

### Answer the following questions:

#### Briefly describe the differences between the alignment in both files.
#### Briefly compare the statistics for the two BAM files.
#### How many primary alignments does each of your BAM files contain?
#### What coordinate has the largest observed coverage? (hint: samtools depth)
#### Select a gene of interest. How many alignments on the forward strand cover the gene?