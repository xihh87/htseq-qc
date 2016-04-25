<config.mk
FILES=`{find "$DATA_DIR/" -name '*.fastq.gz'}

FASTQ_TARGETS=`{for f in $FILES; do echo "$RESULTS_DIR/qc/${f#$DATA_DIR/}"; done}
FASTQ_TARGETS=`{for f in $FASTQ_TARGETS; do echo "${f%.fastq.gz}_fastqc.html"; done}

SAM_TARGETS=`{find "$DATA_DIR/" -name '*_R1_001.fastq.gz'}
SAM_TARGETS=`{for f in $SAM_TARGETS; do echo "$RESULTS_DIR/sam/${f#$DATA_DIR/}"; done}
SAM_TARGETS=`{for f in $SAM_TARGETS; do echo "${f%_R1_001.fastq.gz}.sam"; done}

SORTED_SAM_TARGETS=`{for f in $SAM_TARGETS; do echo "$RESULTS_DIR/sorted-sam/${f#$RESULTS_DIR/sam/}"; done}

fastq: $FASTQ_TARGETS
	for f in $FASTQ_TARGETS; do echo "$f"; done

sam: $SAM_TARGETS
	for f in $SAM_TARGETS; do echo "$f"; done

sorted-sam: $SORTED_SAM_TARGETS

results/sorted-sam/%.sam: results/sam/%.sam
	mkdir -p $(dirname $target)
	samtools sort -o $target $prereq

results/sam/%.sam: data/%_R1_001.fastq.gz data/%_R2_001.fastq.gz
	mkdir -p $(dirname $target)
	bwa mem $REF $prereq > $target

qualimap:
	qualima

results/qc/%_fastqc.html: data/%.fastq.gz
	mkdir -p $(dirname $target)
	fastqc $prereq -o $(dirname $target)

init:VN: $DATA_DIR/ $RESULTS_DIR/qc/ config.mk

config.mk:
	cp config.mk.example config.mk

clean:VE:
	rm -r $RESULTS_DIR/qc $RESULTS_DIR/sam

%/:
	mkdir -p $stem
