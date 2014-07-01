 module load apps/bowtie2/2.2.3
echo $kanute_dir
bowtie2 -x $kanute_dir/inputs/tinyGenome -U $kanute_dir/inputs/single_read_1.fastq > $kanute_dir/outputs/bowtie2/single_read1.out
