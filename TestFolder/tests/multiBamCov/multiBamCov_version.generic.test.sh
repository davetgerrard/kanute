

# get --version information and put it in a file. Should be different for each version.

NAME=${1-'multiBamCov'}
VERSION=${2-'current'}
FULLPATH=${3-"$NAME"}
TEST_OUT_NAME='version.out'

if [ ! -d "$kanute_dir/outputs/$NAME/$VERSION" ]; then
	mkdir $kanute_dir/outputs/$NAME/$VERSION
fi
echo "$FULLPATH  > $kanute_dir/outputs/$NAME/$VERSION/$TEST_OUT_NAME"
$FULLPATH 2> $kanute_dir/outputs/$NAME/$VERSION/$TEST_OUT_NAME
