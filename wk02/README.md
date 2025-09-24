*Hello* **Dr. Albert**

### Assignment for week 2

#### Tell us a bit about the organism
```bash
wget https://ftp.ensembl.org/pub/current_gff3/callithrix_jacchus/Callithrix_jacchus.mCalJac1.pat.X.115.gff3.gz
gunzip Callithrix_jacchus.mCalJac1.pat.X.115.gff3.gz
```
Callithrix Jacchus, known as the common marmosets, is a small primate species (New World Monkeys) living in South America, mostly in Brazil. what is fascinating for me about this organism is that they have different patterns of reproductive strategy and social organization in comparison with old world primates, such as humans and rhesus monkeys. They give born to 3-4 offsprings in a single conception, and they normally give birth to twins, and can give birth to triplets and qudraplets, compare to singleton in most primates. this means females are polyovulate in each of their cycle. females can ovulate again soon after their conception, which in combination with previous points make them high reproductive species for a primate. overall, their reproductive strategy looks more like rodents. in addition, they heavily rely on alloparenting for raising the offsprings. finally, Their relative brain to body size percentage is more than humans, 2.7% vs 2%, although they have smooth brain compared to the human brain and rhesus macaques that have lots of gyrus and ridges in their brain.

#### How many sequence regions (chromosomes) does the file contain? Does that match with the expectation for this organism?
```bash
cat Callithrix_jacchus.mCalJac1.pat.X.115.gff3 | grep '##sequence' | wc -l
```
352. No, the expectation number of autosomal chromosomes is 22 plus the two sex chromosomes, X and Y. 

#### How many features does the file contain?
```bash
cat Callithrix_jacchus.mCalJac1.pat.X.115.gff3 | grep -v '#' > Marmoset.gff3 #remove everything that starts with a comment to filter it to regions that do not contain the number sign
cat Marmoset.gff3 | cut -f 3 | sort | uniq -c | sort -r -n
```
Here is the outputs:
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
```bash
cat Marmoset.gff3 | grep -v "^#" | cut -f 3 | sort | uniq | wc -l
grep -v "^#" Marmoset.gff3 | wc -l
```
so, there are 22 different feature types with the whole summation of 1435476 number.

#### How many genes are listed for this organism?
based on the above output, there are 22078 genes.

#### Is there a feature type that you may have not heard about before? What is the feature and how is it defined? (If there is no such feature, pick a common feature.)

Yes, I don't know what these features 'biological_region', 'region', and (in this context) 'scRNA' mean. It is suprising that the annotations has 'V/J/C_gene_segment' but not something as 'D-gene_segment' for the antibodies. Now, I asked from our friend chatgpt whar these three features in the gff3 file. and it mentions, 'biological_region' is a broad functional region (sth like regulatory regions such as enhancers which I am really interested in these regions, cause I beleive they contribute alot in the process of evolution), 'region' is a large structural chunck (such as chromosome, conting, scaffold), and 'scRNA' which here means small cytoplasmic RNA (which I first though it is single-cell RNA)

#### What are the top-ten most annotated feature types (column 3) across the genome?
we can check it based on the above answer, but it is always preferrable to do it with coding.
```bash
cat Marmoset.gff3 | cut -f 3 | sort | uniq -c | sort -r -n | head
```
here is the output:
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

#### Having analyzed this GFF file, does it seem like a complete and well-annotated organism?
I think so. It contains all the expected chromosomes. Higher numbers of mRNA compared to genes because of alternative splicing. the number of genes make sense and it is close to 20-22k in our genus. So, it looks fine in my perspective, but I am not sure cause I am not an expert in this field.

#### Share any other insights you might note.
I get really interested with this 'biological_region'. I didn't know that we could get this info from this file. So, if we combine it with other sequencing tchniques, such as RNA/ChIP/ATAC-seq, can we identify these enhancer regions? And if we need to identify which enhancers are regulated by some specific transcription factors, such as Androgen Receptors, probably we need this multi-omic approach. Also can we identify the enhancer regions near some of the genes based on the regions in the genome? to identify which genes could be effected by higher number of enhancers. and then do some phylogeny to compare with other species. it makes me really curious.