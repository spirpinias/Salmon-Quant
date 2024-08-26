#!/usr/bin/env bash
set -ex

source ./config.sh
source ./utils.sh

input_fwd_fastqs=$(find -L ../data -name "*$pattern_fwd")

file_count=$(find -L ../data -name "*$pattern_fwd" | wc -l)

echo "Using threads: $num_threads"
echo "Input R1 Fastqs: $input_fwd_fastqs"

for input_fwd_fastq in $input_fwd_fastqs
do
  file_prefix=$(sed "s/$pattern_fwd//" <<< $input_fwd_fastq)
  file_prefix=$(basename $file_prefix)
  input_rev_fastq=$(get_reverse_file "$input_fwd_fastq")
  
  if [ -z $input_rev_fastq ]; then
    echo "Running in single end mode"
    read_files="-r $input_fwd_fastq"
  else
    read_files="-1 $input_fwd_fastq -2 $input_rev_fastq"
  fi

  if [ "$output_bam" == "True" ]; then
      write_mappings="--writeMappings=/dev/stdout \
      | samtools view -S -b \
      > ../results/$file_prefix/$file_prefix.bam"
  fi

    mkdir -p ../results/$file_prefix

    salmon_cmd="salmon quant \
      -i "${index}" \
      --libType "$lib_type" \
      --threads "${num_threads}" \
      ${read_files} \
      --validateMappings \
      -o ../results/$file_prefix \
      ${frag_mean} \
      ${frag_sd} \
	    ${incompat_prior} \
	    ${min_score_fraction} \
	    ${max_mmp_extension} \
	    ${ma} \
	    ${mp} \
	    ${go} \
	    ${ge} \
	    ${range_factorization_bins} \
	    ${use_em} \
	    ${num_bootstraps} \
	    ${num_gibbs_samples} \
	    ${seq_bias} \
	    ${gc_bias} \
	    ${pos_bias} \
	    ${bias_downsample} \
	    ${write_unampped} \
      ${write_mappings}"

    eval $salmon_cmd

  quant_file=$(find -L ../results -name "quant.sf")
  mv "$quant_file" "../results/$file_prefix/${file_prefix}_quant.sf"
done
