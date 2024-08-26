# Salmon: mapping-based quantification

Salmon can quantitate transcripts from alignments (alignment-based mode) or can take raw reads along with a transcriptome reference and perform quantification directly (mapping-based). This module performs mapping-based quantitation.

## Input Data

**Fastq Files**

RNA sequencing reads. In the **data** directory, tool searches for \*.f\*q\* files. 

**Genome Directory**

If a reference directory is not supplied, it is inferred by the location of "ctable.bin".

## App Panel Parameters

### Main Parameters

Salmon Index
- Previously generated salmon transcript index

Threads
- Number of threads to allocate to Salmon

Pattern fwd
- Pattern for forward sequence in paired end reads. i.e., sample_S1_L001_R1_001.fastq.gz would be "_R1_001.fastq.gz". Note, in this example, if you have multiple lanes for a single sample that you wish to process together you will need to concatenate them together before processing with Salmon.

Pattern rev
- Pattern for reverse sequence in paired end reads. The sample prefix (i.e, sample_S1_L001 in the previous example) will be used with this pattern to determine the matching paired end fastq. If this is not found, Salmon will proceed in single end mode.

Output Mapping BAM file
- Write alignments to .bam file based on fastq prefix. (--writeMappings)

Ouptut folder
- output folder for contain Salmon quant files.

Fragment Length Mean: 
- Only necessary for single-end reads since fragment length cannot be estimated. Mean fragment length of the sequencing library. Will affect the effective length correction, and hence the estimated effective lengths of the transcripts and the TPMs. (--fldMean)

Fragment Length SD: 
- Only necessary for single-end reads since fragment length cannot be estimated. Standard Deviation of fragment length in sequencing library. Will affect the effective length correction, and hence the estimated effective lengths of the transcripts and the TPMs. (--fldSD)

Mimic Bowtie: 
- Sets the parameters related to mapping and selective alignment to mimic alignment using Bowtie2 (--mimicBT2)

Mimic Strict Bowtie: 
- Sets the parameters related to mapping and selective alignment to mimic alignment using Bowtie2 disallowing indels. (--mimicStrictBT2)

### Auxilary Parameters
*Note* The following parameters likely do not need to change.

Incompatibility Prior: 
- A priori probability of a fragment mapping to the reference in a manner incompatible with the library type being the correct mapping. By default, Salmon sets a small but non-zero probability. If an incompatible mapping is the only mapping for a fragment, Salmon will assign this fragment to the transcript. RSEM assigns incompatible fragments a 0 probability (i.e., incompatible mappings will be discarded). If you want only compatible mappings will be considered, you can set Incompatibility Prior to 0.0. (--incompatPrior)

Library Type: 
- If set to Automatic, automatically determine library type. Otherwise, for paired end reads "inward" (reads face each other), "outward" (reads face away from each other) or "matching" (reads face same direction). Strandedness determines whether the protocol was stranded or unstranded. If the protocol is stranded, then "forward" indicates that read 1 comes from the forward strand and "reverse" indicates that the read 1 comes from the reverse strand. (--libType)

Min Score Fraction
- Controls the minimum allowed score for a mapping to be considered valid. The maximum possible score for a fragment is `read_len \* ma` (or `(left_read_len + right_read_len) \* ma` for paired-end reads) where `ma` is the integer value given to a match between query and reference. The argument to --minScoreFraction determines what fraction of the maximum score a mapping must achieve to be retained. I.e. set to .7 to discard matches with less than 70% of the maximum possible match score. (--minScoreFraction)

Match Value: 
- Controls the score given to a match in the alignment between the query (read) and the reference. Should be a positive (typically small) integer. (--ma)

Mismatch Penalty: 
- Controls the score given to a mismatch in the alignment between the query (read) and the reference. Should be a negative (typically small) integer. (--mp)

Gap Open Penalty: 
- Controls the score penalty attributed to an alignment for each new gap that is opened. Should be a positive (typically small) integer. (--go)

Gap Extension Penalty: 
- Controls the score penalty attributed to the extension of a gap in an alignment. Should be a positive (typically small) integer (--ge)

Range Factorization
- The [range-factorization](https://academic.oup.com/bioinformatics/article/33/14/i142/3953977) feature allows using a data-driven likelihood factorization, which can improve quantification accuracy on certain classes of “difficult” transcripts. The argument to this option is a positive integer x, that determines fidelity of the factorization. The larger x, the closer the factorization to the un-factorized likelihood, but the larger the resulting number of equivalence classes. A value of 1 corresponds to salmon's traditional rich equivalence classes. 4 is a reasonable parameter for this option (was used in the range-factorization paper). (--rangeFactorizationBins)

Use EM
- Use the “standard” EM algorithm to optimize abundance estimates instead of the variational Bayesian EM algorithm. See [documentation](https://salmon.readthedocs.io/en/latest/salmon.html#useem) for details. (--useEM)

Num Bootstraps
- Perform x boostrap samplings before estimating abundance. (--numBootstraps)

Num Gibbs Samples
- Perform x Gibbs samplings before estimating abundance. (--numGibbsSamples)

Sequence Bias Estimation
- Will learn and correct for sequence-specific biases in the input data (--seqBias)

GC Bias Estimation
- Will learn and correct for fragment-level GC biases in the input data. (--gcBias)

Positional Bias Estimation
- Will enable modeling of a position-specific fragment start distribution. (--posBias)

Bias Downsampling
- Evaulating bias can be slow if all fragments are considered. This will only consider every X fragment in the sample. I.e, choose 5 to pick 1/5 of the total fragments. (--biasSpeedSamp)

Write Unmapped Names
- Write out the names of reads that do not map to the transcriptome. (--writeUnmappedNames)

## Outputs

**_quant.sf**: Salmon's main output file. This file is a plain-text, tab-separated file with a single header line (which names all of the columns). The columns appear in the following order: 

- Name — This is the name of the target transcript provided in the input transcript database (FASTA file).

- Length — This is the length of the target transcript in nucleotides.

- EffectiveLength — This is the computed effective length of the target transcript. It takes into account all factors being modeled that will effect the probability of sampling fragments from this transcript, including the fragment length distribution and sequence-specific and gc-fragment bias (if they are being modeled).

- TPM — This is salmon's estimate of the relative abundance of this transcript in units of Transcripts Per Million (TPM). TPM is the recommended relative abundance measure to use for downstream analysis.

- NumReads — This is salmon's estimate of the number of reads mapping to each transcript that was quantified. It is an “estimate” insofar as it is the expected number of reads that have originated from each transcript given the structure of the uniquely mapping and multi-mapping reads and the relative abundance estimates for each transcript.

**cmd_info.json**: Main command line parameters used by Salmon. 

**aux_info**: 

- **meta_info.json** with number of observed and mapped fragments, details of the bias modeling etc.

- **ambig_info.tsv** Number of uniquely-mapping reads and total number of ambiguously-mapping reads for each transcript.
- **lib_format_counts.json** Number of fragments that had at least one mapping compatible with the designated library format, as well as the number that didn't. Also records strand bias and possible library type mappings. 
- **fld.gz** Fragment length distribution
- **obs5_seq.gz, obs3_seq.gz, exp5_seq.gz, exp3_seq.gz** Sequence-specific bias files
- **expected_gc.gz, observed_gc.gz** Fragment-GC bias files
- **eq_classes.txt** Equivalence class file

## Source

https://salmon.readthedocs.io/en/latest/salmon.html

## Cite

Roberts, Adam, and Lior Pachter. “Streaming fragment assignment for real-time analysis of sequencing experiments.” Nature Methods 10.1 (2013): 71-73.

Roberts, Adam, et al. “Improving RNA-Seq expression estimates by correcting for fragment bias.” Genome Biology 12.3 (2011): 1.

Patro, Rob, et al. “Salmon provides fast and bias-aware quantification of transcript expression.” Nature Methods (2017). Advanced Online Publication. doi: 10.1038/nmeth.4197..

Love, Michael I., Hogenesch, John B., Irizarry, Rafael A. “Modeling of RNA-seq fragment sequence bias reduces systematic errors in transcript abundance estimation.” Nature Biotechnology 34.12 (2016). doi: 10.1038/nbt.368.2..
