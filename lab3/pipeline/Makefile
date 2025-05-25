SHELL := /bin/bash

REFERENCE=../data_escherichia_coli/reference_genome/GCF_000005845.2_ASM584v2_genomic.fna
READ1=../data_escherichia_coli/sequencing_result/SRR31294338_1.fastq
READ2=../data_escherichia_coli/sequencing_result/SRR31294338_2.fastq
QC_DIR=QC_report
OUTPUT_DIR=output
RESULTS_DIR=results
QUALITY_THRESHOLD=90

SAMTOOLS=samtools
BWA=bwa
FREEBAYES=freebayes


all: prepare quality_check final_result

prepare:
	@mkdir -p $(OUTPUT_DIR) $(RESULTS_DIR)

$(OUTPUT_DIR)/reference_genome.fna: $(REFERENCE)
	@echo "Indexing the reference genome..."
	$(BWA) index $(REFERENCE)

$(OUTPUT_DIR)/alignment.sam: $(OUTPUT_DIR)/reference_genome.fna $(READ1) $(READ2)
	@echo -e "\nMapping the reads..."
	$(BWA) mem $(REFERENCE) $(READ1) $(READ2) > $(OUTPUT_DIR)/alignment.sam

$(OUTPUT_DIR)/alignment.sorted.bam: $(OUTPUT_DIR)/alignment.sam
	@echo -e "\nConverting SAM to BAM and sorting..."
	$(SAMTOOLS) view -Sb $(OUTPUT_DIR)/alignment.sam | samtools sort -o $(OUTPUT_DIR)/alignment.sorted.bam

$(OUTPUT_DIR)/flagstat.txt: $(OUTPUT_DIR)/alignment.sorted.bam
	@echo -e "\nEvaluating the quality of mapping..."
	$(SAMTOOLS) flagstat $(OUTPUT_DIR)/alignment.sorted.bam > $(OUTPUT_DIR)/flagstat.txt

quality_check: $(OUTPUT_DIR)/flagstat.txt
	@echo -e "\nAnalyzing the results of flagstat..."
		@MAPPED_PERCENT=$(shell grep -m 1 'mapped' $(OUTPUT_DIR)/flagstat.txt | sed -E 's/.*\(([0-9]+\.[0-9]+)%.*\)/\1/') && \
	echo "$$MAPPED_PERCENT%" && \
		if echo "$$MAPPED_PERCENT < $(QUALITY_THRESHOLD)" | bc -l | grep -q 1; then \
				echo -e "\nnot OK :( - Percentage of mapping is below the threshold: $$MAPPED_PERCENT%"; \
		else \
				echo -e "\nOK! - Percentage of mapping: $$MAPPED_PERCENT%"; \
		fi

call_variants: $(OUTPUT_DIR)/alignment.sorted.bam $(OUTPUT_DIR)/reference_genome.fna
	@echo -e "\nCalling of genetic variants..."
	$(SAMTOOLS) faidx $(REFERENCE)
	$(SAMTOOLS) index $(OUTPUT_DIR)/alignment.sorted.bam
	$(FREEBAYES) -f $(REFERENCE) $(OUTPUT_DIR)/alignment.sorted.bam > $(RESULTS_DIR)/result.vcf
	@echo -e "\nGenetic variants was preserved in $(RESULTS_DIR)/result.vcf"

final_result: quality_check call_variants
	@echo -e "\nGetting results..."
	@mv $(OUTPUT_DIR)/flagstat.txt $(RESULTS_DIR)/flagstat.txt
	@echo -e "\nResults was preserved in $(RESULTS_DIR)/"

qc: $(READ1) $(READ2)
	@mkdir -p $(QC_DIR)
	@$(FASTQC) $(READ1) $(READ2) -o $(QC_DIR)

clean:
	@echo "Cleaning (deleting outputs and results)..."
	@rm -rf $(OUTPUT_DIR) $(RESULTS_DIR)

visualize:
	@echo "Generating enhanced pipeline visualization..."
	@echo "digraph pipeline {" > pipeline.dot
	@echo "  rankdir=LR;" >> pipeline.dot
	@echo "  node [shape=box style=filled fontname=Helvetica fontsize=10];" >> pipeline.dot

	@echo "  prepare       [label=\"Prepare directories\\nCreate folders\", fillcolor=lightblue];" >> pipeline.dot
	@echo "  index_ref     [label=\"Index Reference Genome\", fillcolor=lightgreen];" >> pipeline.dot
	@echo "  map_reads     [label=\"Map Paired-End Reads\", fillcolor=lightyellow];" >> pipeline.dot
	@echo "  sam_to_bam    [label=\"SAM → Sorted BAM\", fillcolor=lightyellow];" >> pipeline.dot
	@echo "  flagstat      [label=\"Mapping Quality Check\\n(samtools flagstat)\", fillcolor=orange];" >> pipeline.dot
	@echo "  variant_call  [label=\"Call Genetic Variants\\n(freebayes)\", fillcolor=plum];" >> pipeline.dot
	@echo "  final_result  [label=\"Move Final Results\", fillcolor=grey];" >> pipeline.dot
	@echo "  clean         [label=\"Clean Temporary Files\", fillcolor=red fontcolor=white];" >> pipeline.dot

	@echo "  prepare       -> index_ref;" >> pipeline.dot
	@echo "  index_ref     -> map_reads;" >> pipeline.dot
	@echo "  map_reads     -> sam_to_bam;" >> pipeline.dot
	@echo "  sam_to_bam    -> flagstat;" >> pipeline.dot
	@echo "  flagstat      -> variant_call;" >> pipeline.dot
	@echo "  variant_call  -> final_result;" >> pipeline.dot
	@echo "  final_result  -> clean;" >> pipeline.dot

	@echo "}" >> pipeline.dot
	@dot -Tpng pipeline.dot -o pipeline.png
	@echo "Enhanced pipeline visualization saved to pipeline.png"
