#!/usr/bin/perl
use strict;
use warnings;

# ==============================================================================
# Program: Generate truncated sequences by single residue deletion for protein FASTA
# Input: Standard protein FASTA file
# Output: {prefix}.m2, each record is the sequence after deleting one single site
# Arguments:
#   $ARGV[0]  Input protein FASTA file path
#   $ARGV[1]  Output file prefix
# Output header format: >seqName#positionIndex (0-based position index to delete)
# Filter rule: Only output truncated sequences with length >= 10
# ==============================================================================

my $MIN_OUT_LEN = 10; # Minimum length threshold for retained truncated sequences

# Check input argument count
if (@ARGV != 2) {
    die "ERROR: Incorrect number of arguments!\nUsage: perl $0 input_protein.fasta out_prefix\n";
}
my ($in_fasta, $out_prefix) = @ARGV;
my $out_file = "$out_prefix.m2";

# Open input and output file handles with error capture
open my $fh_in, '<', $in_fasta or die "ERROR: Cannot open input file $in_fasta : $!";
open my $fh_out, '>', $out_file or die "ERROR: Cannot create output file $out_file : $!";

my $seq_name; # Store current FASTA sequence ID

# Read FASTA file line by line
while (my $line = <$fh_in>) {
    chomp $line;
    # Match FASTA header line starting with ">"
    if ($line =~ /^>(\S+)/) {
        $seq_name = $1;
        next;
    }
    # Skip empty lines and sequence lines without valid header
    next if !defined $seq_name || $line =~ /^\s*$/;

    my $ori_seq = $line;
    my $seq_len = length $ori_seq;
    my @residues = split //, $ori_seq; # Split protein sequence into single residues array

    # Iterate every position to perform single-residue deletion (0-based index)
    for my $del_idx (0 .. $seq_len - 1) {
        my $prefix_seq = '';
        $prefix_seq = join '', @residues[0 .. $del_idx - 1] if $del_idx > 0;

        my $suffix_seq = '';
        $suffix_seq = join '', @residues[$del_idx + 1 .. $seq_len - 1] if $del_idx < $seq_len - 1;

        my $del_seq = $prefix_seq . $suffix_seq;

        # Only output truncated sequences meeting the minimum length requirement
        if (length($del_seq) >= $MIN_OUT_LEN) {
            print $fh_out ">$seq_name#$del_idx\n$del_seq\n";
        }
    }
}

# Close file handles
close $fh_in;
close $fh_out;

print "Finished! Truncated deletion sequences saved to: $out_file\n";