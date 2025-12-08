*Hello* **Dr. Albert**
# Assignment for week 13 - Generate a Genome-based RNA-seq count matrix

```bash
make ref
make index
cat design.csv | parallel --colsep , --header : --eta -j 4 'make read SRR={srr_id}'
```

```bash
cat design.csv | parallel --colsep , --header : --eta -j 4 'make run SRR={srr_id}'
```

