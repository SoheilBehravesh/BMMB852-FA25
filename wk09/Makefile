









vcf:
# Flags for the mpileup command
	F1=-d 100 --annotate 'INFO/AD,FORMAT/DP,FORMAT/AD,FORMAT/ADF,FORMAT/ADR,FORMAT/SP'

# Flags for the call command
	F2=--ploidy 2 --annotate 'FORMAT/GQ' 

# Variant calling process.
	bcftools mpileup ${F1} -O u -f ${REF} ${BAM} | \
	bcftools call ${F2} -mv -O u | \
	bcftools norm -f ${REF} -d all -O u | \
	bcftools sort -O z > ${VCF}