*Hello* **Dr. Albert**

## Assignment for Week 1

##### What version is your samtools command in the bioinfo environment?
```bash
micromamba activate bioinfo
samtools --version
```
It is 1.22.1

##### Show commands needed to create a nested directory structure
```bash
mkdir 
cd
```

##### Show commands that create files in different directories
```bash
touch
ls #for checking if the new file has been created
mv # it does not create files or folders directly, but at least can move new files into a new (sub)directory
```

##### Show how to use relative and absolute paths
```bash
# absolutepath
cd /home/soheil/project/data

# relative path
cd data
```
The difference is that absolute path starts with '/'. Relative path supposes that I am already in */home/soheil/project*.