NAME='tophat2'
TEST_LIST_FILE='test.list'
#readarray TEST_LIST < $TEST_LIST_FILE
IFS=$'\r\n' GLOBIGNORE='*' :; TEST_LIST=($(cat $TEST_LIST_FILE))
#TEST_SCRIPT='bowtie2_version.generic.test.sh'
VERSION_FILE=${1-'tophat2.versions'}

IFS=$'\t'

while read VERSION FULL_PATH; do
  echo "VERSION=$VERSION FULL_PATH=$FULL_PATH "
	for TEST_SCRIPT in ${TEST_LIST[@]}
	do
	echo "  bash $TEST_SCRIPT $NAME $VERSION $FULL_PATH" 
	bash $TEST_SCRIPT $NAME $VERSION $FULL_PATH
	done
done < $VERSION_FILE
