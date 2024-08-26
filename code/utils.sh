#!/usr/bin/env bash

function get_reverse_file () {
  local input_fwd_fastq=$1
  local input_rev_fastq=$(sed "s/$pattern_fwd/$pattern_rev/" <<< $input_fwd_fastq)

  input_rev_basename=$(basename $input_rev_fastq)
  
  input_rev_fastq=$(find -L ../data -name "$input_rev_basename")
  echo $input_rev_fastq
}
