## reference url1 : https://imputation.sanger.ac.uk/?resources=1
## reference url2 : http://samtools.github.io/bcftools/howtos/plugin.fixref.html

# Download reference fasta & vcf
wget https://ftp.ncbi.nlm.nih.gov/snp/organisms/human_9606_b151_GRCh37p13/VCF/All_20180423.vcf.gz
wget https://ftp.ncbi.nlm.nih.gov/snp/organisms/human_9606_b151_GRCh37p13/VCF/All_20180423.vcf.gz.tbi
wget ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/technical/reference/human_g1k_v37.fasta.gz

gunzip All_20180423.vcf.gz

zcat All_20180423.vcf.gz | grep -v '^#' | cut -f 3,4 > reference_allele_All_20180423_GRCh37.txt



bgzip -c test_vcf.vcf > input_test.vcf.gz
bcftools index input_test.vcf.gz

bcftools +fixref -Oz input_test.vcf.gz -- -f human_g1k_v37.fasta

bcftools norm --check-ref -s -f human_g1k_v37.fasta input_test.vcf.gz > output.vcf

bgzip -c output.vcf > output.vcf.gz
bcftools index output.vcf.gz

bcftools +fixref -Oz output.vcf.gz -- -f human_g1k_v37.fasta
