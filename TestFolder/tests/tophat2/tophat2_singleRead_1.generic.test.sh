 source /usr/share/Modules/init/bash    # to use module load within the scirpt

# map a single read to a simple genome using tophat2 via bowtie2 
# expect only one mapping
# as bowtie output contains version information in headers, need to post-prcoess using 'samtools view' to get just the mapping.
module load apps/samtools/0.1.19

NAME=${1-'tophat2'}
VERSION=${2-'current'}
FULLPATH=${3-'$NAME'}
TEST_OUT_NAME='single_read1.sam'
#kanute_dir is an environment variable
if [ ! -d "$kanute_dir/outputs/$NAME/$VERSION" ]; then
        mkdir $kanute_dir/outputs/$NAME/$VERSION
fi
$FULLPATH -x $kanute_dir/inputs/tinyGenome -U $kanute_dir/inputs/single_read_1.fastq | samtools view -S  - > $kanute_dir/outputs/$NAME/$VERSION/$TEST_OUT_NAME
