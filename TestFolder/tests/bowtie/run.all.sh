NAME='bowtie'
TEST_LIST_FILE='test.list'
#readarray TEST_LIST < $TEST_LIST_FILE
IFS=$'\r\n' GLOBIGNORE='*' :; TEST_LIST=($(cat $TEST_LIST_FILE))
#TEST_SCRIPT='bowtie2_version.generic.test.sh'
VERSION_FILE=${1-'bowtie.versions'}

IFS=$'\t'

while read VERSION FULL_PATH; do
  echo "VERSION=$VERSION FULL_PATH=$FULL_PATH "
	#	bowtie2_version.generic.test.sh bowtie2 2.0.2   /opt/gridware/apps/bowtie2/2.0.2/bowtie2
	#echo "	bash $TEST_SCRIPT $NAME $VERSION $FULL_PATH"
	for TEST_SCRIPT in ${TEST_LIST[@]}
	do
	echo "  bash $TEST_SCRIPT $NAME $VERSION $FULL_PATH" 
	bash $TEST_SCRIPT $NAME $VERSION $FULL_PATH
	done
done < $VERSION_FILE
