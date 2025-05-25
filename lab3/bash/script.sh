#!/bin/bash

REFERENCE_GENOME="../data_escherichia_coli/reference_genome/GCF_000005845.2_ASM584v2_genomic.fna"
READ1="../data_escherichia_coli/sequencing_result/SRR31294338_1.fastq"
READ2="../data_escherichia_coli/sequencing_result/SRR31294338_2.fastq"
OUTPUT_DIR="output"

QUALITY_THRESHOLD=90

mkdir -p $OUTPUT_DIR

echo "Indexing the reference genome with bwa..."
bwa index $REFERENCE_GENOME

echo -e "\nMapping paired-end reads..."
bwa mem $REFERENCE_GENOME $READ1 $READ2 > $OUTPUT_DIR/alignment.sam

echo -e "\nConverting SAM to sorted BAM..."
samtools view -Sb $OUTPUT_DIR/alignment.sam | samtools sort -o $OUTPUT_DIR/alignment.sorted.bam

echo -e "\nCalculating mapping statistics..."
samtools flagstat $OUTPUT_DIR/alignment.sorted.bam > $OUTPUT_DIR/flagstat.txt

FLAGSTAT_RESULT="$OUTPUT_DIR/flagstat.txt"
MAPPED_PERCENT=$(grep "mapped (" $FLAGSTAT_RESULT | awk '{print $5}' | tr -d '()%mapped')

if [ $(echo "$MAPPED_PERCENT > $QUALITY_THRESHOLD" | bc) -eq 1 ]; then
  echo -e "\nOK! - Percentage of mapping: $MAPPED_PERCENT%"
else
  echo -e "\nnot OK :( - Percentage of mapping is below the threshold: $MAPPED_PERCENT%"
fi

echo -e "\nVariant calling..."
samtools faidx $REFERENCE_GENOME
samtools index $OUTPUT_DIR/alignment.sorted.bam
freebayes -f $REFERENCE_GENOME $OUTPUT_DIR/alignment.sorted.bam > $OUTPUT_DIR/result.vcf

echo -e "\nDone!"