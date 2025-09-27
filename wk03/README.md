*Hello* **Dr. Albert**

# Assignment for Week 3

#### Use IGV to visualize your genome and the annotations relative to the genome.


```bash
cd ~/wk03

# we get the fasta file as the sequence file of our organism to have the genome (what the identity is/ what the sequence is)
wget https://ftp.ensembl.org/pub/current_fasta/callithrix_jacchus/dna/Callithrix_jacchus.mCalJac1.pat.X.dna.toplevel.fa.gz

# unzip it
gunzip Callithrix_jacchus.mCalJac1.pat.X.dna.toplevel.fa.gz

# change the name of the file to a more easy to read

mv Callithrix_jacchus.mCalJac1.pat.X.dna.toplevel.fa marmoset.fa
```
#### How big is the genome?

using tools such as seqkit to look over the details stored in the file, such as the size of the genome

```bash
seqkit stats abaum.fa
```
It is really big with 352 number of sequences with the length summation of around 3 billion bp (2829711198)

look at it with a different tool
```bash
cat marmoset.fa | grep ">"
```
since the fasta starts with a > sign, so we want to look for that lines and from the output it will tell us how many sequences are in the file

#### how many features of each type does the GFF file contain?

first let's get the gff file of the marmoset
```bash
wget https://ftp.ensembl.org/pub/current_gff3/callithrix_jacchus/Callithrix_jacchus.mCalJac1.pat.X.115.gff3.gz
gunzip Callithrix_jacchus.mCalJac1.pat.X.115.gff3.gz
mv Callithrix_jacchus.mCalJac1.pat.X.115.gff3 marmoset.gff3
```
how many lines does the file have?
```bash
cat marmoset.gff3 | wc -l
```
1476374 lines

To look over how many features of each type the gff file contains, we use the following code

```bash
cat marmoset.gff3 | grep -v '#' > marmoset.gff
cat marmoset.gff | cut -f 3 | sort | uniq -c | sort -r -n | head
```
22 different features. the amount next to each feature shows how many of each feature exist in the file:
617853 exon
556002 CDS
79696 biological_region
48570 mRNA
44437 five_prime_UTR
25122 three_prime_UTR
22078 gene
16815 ncRNA_gene
11321 lnc_RNA
4204 transcript
3083 snRNA
1501 snoRNA
1295 pseudogenic_transcript
1295 pseudogene
937 Y_RNA
540 miRNA
352 region
213 rRNA
97 V_gene_segment
49 scRNA
12 J_gene_segment
4 C_gene_segment

#### From your GFF file, separate the intervals of type "gene" or "transcript" into a different file. Show the commands you used to do this.

```bash
grep -P '\tgene\t' marmoset.gff > marmosetgene.gff
```
so what this line of code does is use 'gerp' to look for the a pattern. '-P' lets us to use '\t' to match the character. since we want the genes that are sorrounded by both sides (not the ones like ncRNA-gene features) so it will tell the system to go and search line by line and match the 'gene' word that seperated by tab in both sides, and then turn the ones you found matching to a different file.

#### Visualize the simplified GFF in IGV as a separate track. Compare the visualization of the original GFF with the simplified GFF.

in comparison to the simplified version, when I click on somwhere on blue ribbon of the orifinal file, the text would show different features in the information window. For example, the simplified version just shows the sequences of the genes, but on top of it when I click on that similar region on the original version, it shows the information of mRNA, CDS, genes, and region all in one window related to that region. Also the simplified version does not contain annotation of other regions such as 'biological_regions'.

#### Zoom in to see the sequences, expand the view to show the translation table in IGV. Note how the translation table needs to be displayed in the correct orientation for it to make sense.
the arrrow's direction of the regions on the GFF file (in the main panel) should have the same direction of the arrow's direction in the track panel next to the translation sequence.


#### Visually verify that the first coding sequence of a gene starts with a start codon and that the last coding sequence of a gene ends with a stop codon.
First we should check the arrow of the direction of the annotated sequences and the translation part, and then look into each of the original reading frames in order to find the green and red (markers for start and stop codon) that are at the exact location of the start and end of our gene.

#### Taking the Screen Shot
```bash
# Feature name
LOC=VP30

# Screenshot directory
PNG=~/work/png/

# Make a snapshot directory
mkdir -p ${PNG}

# Set the snapshot directory
echo snapshotDirectory ${PNG}

# Go to the feature
echo goto VP30

# Take a screenshot
echo snapshot ${LOC}.png

bash snapit.sh | nc localhost 60151
```
![alt text](IGVViewScSh.png)