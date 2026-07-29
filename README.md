A. Usages

Two Perl scripts are provided to generate saturated single-residue variants for peptide sequences:
1. Single amino-acid substitution mutagenesis
perl AMP-mutation1-single-substitution.pl inputfile outfile_prefix
2. Single amino-acid deletion mutagenesis
perl AMP-mutation2-single-deletion.pl inputfile outfile_prefix

Input requirement：  The input file must store peptide sequences in standard FASTA format.

Output description： Output files are created in the same directory as the input FASTA file:

Output file of all substitution variants output: output_prefix.m1

Output file of all deletion variants : output_prefix.m2

B. Variant Generation Rules
1. Saturated single-residue substitution
For a parent peptide of length L, each site is replaced with the other 19 standard amino acids (excluding the native residue).
This produces L × 19 mutants with unchanged sequence length L.
2. Saturated single-residue deletion
For a parent peptide of length L, each residue is deleted one at a time, generating L truncated variants with length L−1.

C. The Suggestions for iterative mutagenesis workflow

Substitution and deletion can be performed in multiple rounds in any order. 

To lower computational load, we adopt a tiered screening pipeline:
1. Score all newly generated variants using Macrel (primary predictor in our study) or other AMP prediction tools.
2. Keep only high-scoring candidates (Macrel score ≥ 0.9 OR top 10% ranked sequences) for further rounds of mutagenesis.
