

# get --version information and put it in a file. Should be different for each version.

NAME=${1-'bowtie'}
VERSION=${2-'current'}
FULLPATH=${3-'$NAME'}
TEST_OUT_NAME='version.out'

if [ ! -d "$kanute_dir/outputs/$NAME/$VERSION" ]; then
	mkdir $kanute_dir/outputs/$NAME/$VERSION
fi
$FULLPATH --version  > $kanute_dir/outputs/$NAME/$VERSION/$TEST_OUT_NAME
