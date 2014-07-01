 source /usr/share/Modules/init/bash	# to use module load within the scirpt
# map a single read to a simple genome using bowtie2
# expect only one mapping
# as bowtie output contains version information in headers, need to post-prcoess using 'samtools view' to get just the mapping.
# PROBLEM module command not available to bash script.
 module load apps/bowtie2/2.2.3
module load apps/samtools/0.1.19
bowtie2 -x $kanute_dir/inputs/tinyGenome -U $kanute_dir/inputs/single_read_1.fastq | samtools view -S  - > $kanute_dir/outputs/bowtie2/single_read1.sam
