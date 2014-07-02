 source /usr/share/Modules/init/bash    # to use module load within the scirpt

# map a single read to a simple genome using bowtie
# expect only one mapping
# as bowtie output contains version information in headers, need to post-prcoess using 'samtools view' to get just the mapping.
# PROBLEM module command not available to bash script.
# module load apps/bowtie2/2.2.3
module load apps/samtools/0.1.19

NAME=${1-'bowtie'}
VERSION=${2-'current'}
FULLPATH=${3-'$NAME'}
TEST_OUT_NAME='single_read2.sam'

if [ ! -d "$kanute_dir/outputs/$NAME/$VERSION" ]; then
        mkdir $kanute_dir/outputs/$NAME/$VERSION
fi
$FULLPATH -S  $kanute_dir/inputs/tinyGenome  $kanute_dir/inputs/single_read_1.fastq | samtools view -S  - | cut -f1,2,3,4,6 > $kanute_dir/outputs/$NAME/$VERSION/$TEST_OUT_NAME
