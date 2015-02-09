

# get --version information and put it in a file. Should be different for each version.

NAME=${1-'multiBamCov'}
VERSION=${2-'current'}
FULLPATH=${3-"$NAME"}
TEST_OUT_NAME='simpleBamSimpleBed.counts'

if [ ! -d "$kanute_dir/outputs/$NAME/$VERSION" ]; then
	mkdir $kanute_dir/outputs/$NAME/$VERSION
fi
$FULLPATH -bams $kanute_dir/inputs/simple.bam -bed $kanute_dir/inputs/simple.bed >  $kanute_dir/outputs/$NAME/$VERSION/$TEST_OUT_NAME
