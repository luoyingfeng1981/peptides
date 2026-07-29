#!/usr/bin/perl
use strict;
use warnings;
# ==============================================================================
# Program: Generate all single-point amino acid substitutions for protein FASTA sequences
# Input: Standard protein FASTA file
# Output: {prefix}.m1, each substitution stored as an independent FASTA record
# Arguments:
#   $ARGV[0]  Input protein FASTA file path
#   $ARGV[1]  Output file prefix
# Output header format: >seqName-positionIndex-mutatedAA (0-based position index)
# ==============================================================================
# Mapping table: 20 standard amino acids, ID number -> single letter code
my %aa_map = (
    1  => 'A', # Alanine
    2  => 'F', # Phenylalanine
    3  => 'C', # Cysteine
    4  => 'D', # Aspartic acid / Aspartate
    5  => 'N', # Asparagine
    6  => 'E', # Glutamic acid / Glutamate
    7  => 'Q', # Glutamine
    8  => 'G', # Glycine
    9  => 'H', # Histidine
    10 => 'L', # Leucine
    11 => 'I', # Isoleucine
    12 => 'K', # Lysine
    13 => 'M', # Methionine
    14 => 'P', # Proline
    15 => 'R', # Arginine
    16 => 'S', # Serine
    17 => 'T', # Threonine
    18 => 'V', # Valine
    19 => 'W', # Tryptophan
    20 => 'Y', # Tyrosine
);
my $TOTAL_AA_TYPE = 20; # Total number of standard amino acid types

# Check input argument count
if (@ARGV != 2) {
    die "ERROR: Incorrect number of arguments!\nUsage: perl $0 input_protein.fasta out_prefix\n";
}
my ($in_fasta, $out_prefix) = @ARGV;
my $out_file = "$out_prefix.m1";

# Open input and output file handles
open my $fh_in, '<', $in_fasta or die "ERROR: Cannot open input file $in_fasta : $!";
open my $fh_out, '>', $out_file or die "ERROR: Cannot create output file $out_file : $!";

my $seq_name; # Store current FASTA sequence ID

# Read FASTA file line by line
while (my $line = <$fh_in>) {
    chomp $line;
    # Match FASTA header line starting with >
    if ($line =~ /^>(\S+)/) {
        $seq_name = $1;
        next;
    }
    # Skip empty lines and sequence lines without valid header
    next if !defined $seq_name || $line =~ /^\s*$/;

    my $ori_seq = $line;
    my $seq_len = length $ori_seq;
    my @residues = split //, $ori_seq; # Split protein sequence into single residues array

    # Iterate every substitution position (0-based index)
    for my $pos_idx (0 .. $seq_len - 1) {
        my $prefix_seq = '';
        $prefix_seq = join '', @residues[0 .. $pos_idx - 1] if $pos_idx > 0;

        my $suffix_seq = '';
        $suffix_seq = join '', @residues[$pos_idx + 1 .. $seq_len - 1] if $pos_idx < $seq_len - 1;

        # Substitute current position with all 20 amino acids
        for my $aa_id (1 .. $TOTAL_AA_TYPE) {
            my $mut_aa = $aa_map{$aa_id};
            my $mut_seq = $prefix_seq . $mut_aa . $suffix_seq;
            # Skip the same substitutions (unchanged sequence after substitution)
            if ($ori_seq ne $mut_seq) {
                print $fh_out ">$seq_name-$pos_idx-$mut_aa\n$mut_seq\n";
            }
        }
    }
}

# Close file handles
close $fh_in;
close $fh_out;

print "Finished! Mutated sequences saved to: $out_file\n";
