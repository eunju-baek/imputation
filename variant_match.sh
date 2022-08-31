## reference url1 : https://imputation.sanger.ac.uk/?resources=1
## reference url2 : http://samtools.github.io/bcftools/howtos/plugin.fixref.html

# Download reference fasta & vcf
wget https://ftp.ncbi.nlm.nih.gov/snp/organisms/human_9606_b151_GRCh37p13/VCF/All_20180423.vcf.gz
wget https://ftp.ncbi.nlm.nih.gov/snp/organisms/human_9606_b151_GRCh37p13/VCF/All_20180423.vcf.gz.tbi
wget ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/technical/reference/human_g1k_v37.fasta.gz

gunzip All_20180423.vcf.gz

zcat All_20180423.vcf.gz | grep -v '^#' | cut -f 3,4 > reference_allele_All_20180423_GRCh37.txt

# Checking the reference allele mismatches:
bcftools norm --check-ref e -f human_g1k_v37.fasta testQC.vcf -Ou -o test
# >> Reference allele mismatch at 1:909238 .. REF_SEQ:'G' vs VCF:'C'


# Convert vcf to bcf:
bcftools view testQC.vcf > testQC.broken.bcf
plink --bed /BiO/00_original_data/2_2019_UK_biobank/download_genotypes/ukb_cal_chr1_v2.bed --bim /BiO/00_original_data/2_2019_UK_biobank/download_genotypes/ukb_snp_chr1_v2.bim --fam /BiO/00_original_data/2_2019_UK_biobank/download_genotypes/ukb48422_cal_chr1_v2_s488288.fam --a2-allele reference_allele_All_20180423_GRCh37.txt --make-bed --keep ../final/base_with_eve.fam --recode vcf --out ref_chr1



# Swap the alleles:
bcftools +fixref testQC.broken.bcf -Ob -o fixref.bcf  -- -d -f human_g1k_v37.fasta -i All_20180423.vcf.gz



# Sort the bcf:
bcftools sort fixref.bcf -Ob -o fixref.sorted.bcf

# Convert bcf to vcf:
bcftools view fixref.sorted.bcf -Ov > fixref.sorted.vcf


