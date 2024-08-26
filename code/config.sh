#!/usr/bin/env bash

source library_string_config.sh

if [ $# -eq 0 ]; then
    echo "No arguments supplied"
else
  echo "args:"
  for i in $*; do 
    echo $i 
  done
  echo ""
fi

# Input
some_fastq=$(find -L ../data -name "*.f*q*" | head -1)
echo "some_fastq: $some_fastq"
index=$(dirname "$(find -L ../data -name "ctable.bin" | head -1)")

# Parameters 

if [ -z "${1}" ]; then
  num_threads=$(get_cpu_count)
else
  if [ "${1}" -gt $(get_cpu_count) ]; then
    echo "Requesting more threads than available. Setting to Max Available."
    num_threads=$(get_cpu_count)
  else
    num_threads="${1}"
  fi
fi

if [ -z "${2}" ]; then
  pattern_fwd="_$(get_read_pattern "$some_fastq" --fwd)"
else
  pattern_fwd="${2}"
fi

if [ -z "${3}" ]; then
  pattern_rev="_$(get_read_pattern "$some_fastq" --rev)"
else
  pattern_rev="${3}"
fi

if [ -z "${4}" ]; then
  output_bam="False"
else
  output_bam="${4}"
fi

if [ -z "${5}" ]; then
  frag_mean=""
else
  frag_mean="--fldMean ${5}"
fi

if [ -z "${6}" ]; then
  frag_sd=""
else
  frag_sd="--fldSD ${6}"
fi

if [ ! -z "${7}" ] && [ "${7}" == "True" ]; then
  mimic_bowtie="--mimicBT2"
else
  mimic_bowtie=""
fi

if [ ! -z "${8}" ] && [ "${8}" == "True" ]; then
  mimic_strict_bowtie="--mimicStrictBT2"
else
  mimic_strict_bowtie=""
fi

if [ -z "${9}" ]; then
  lib_type="A"
else
  lib_type=${!9}
fi


if [ -z "${10}" ]; then
  incompat_prior=""
else
  incompat_prior="--incompatPrior ${10}"
fi

if [ -z "${11}" ]; then
  min_score_fraction=""
else
  min_score_fraction="--minScoreFraction ${11}"
fi


if [ -z "${12}" ]; then
  ma=""
else
  ma="--ma ${12}"
fi


if [ -z "${13}" ]; then
  mp=""
else
  mp="--mp ${13}"
fi

if [ -z "${14}" ]; then
  go=""
else
  go="--go ${14}"
fi

if [ -z "${15}" ]; then
  ge=""
else
  ge="--ge ${15}"
fi

if [ -z "${16}" ]; then
  range_factorization_bins=""
else
  range_factorization_bins="--rangeFactorizationBins ${16}"
fi

if [ ! -z "${17}" ] && [ "${17}" == "True" ]; then
  use_em="--useEM"
else
  use_em=""
fi

if [ -z "${18}" ]; then
  num_bootstraps=""
else
  num_bootstraps="--numBootstraps ${18}"
fi

if [ -z "${19}" ]; then
  num_gibbs_samples=""
else
  num_gibbs_samples="--numGibbsSamples ${19}"
fi

if [ ! -z "${20}}" ] && [ "${20}" == "True" ]; then
  seq_bias="--seqBias"
else
  seq_bias=""
fi

if [ ! -z "${21}" ] && [ "${21}" == "True" ]; then
  gc_bias="--gcBias"
else
  gc_bias=""
fi

if [ ! -z "${22}" ] && [ "${22}" == "True" ]; then
  pos_bias="--posBias"
else
  pos_bias=""
fi

if [ -z "${23}" ]; then
  bias_downsample=""
else
  bias_downsample="--biasSpeedSamp ${23}"
fi

if [ ! -z "${24}" ] && [ "${24}" == "True" ]; then
  write_unampped="--writeUnmappedNames"
else
  write_unampped=""
fi
