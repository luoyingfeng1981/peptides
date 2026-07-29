For saturated single-residue substitution: Given a parent protein sequence of length L, 
every residue position is iteratively replaced with the other 19 canonical natural amino acids (excluding the native residue at that site). 
This yields a total of L × 19 unique mutant sequences, all retaining the original sequence length L.

For saturated single-residue deletion: For a parent sequence of length L, each residue position is individually removed once, 
generating L distinct truncated variants with a uniform length of L-1.

A parent template can undergo multiple iterative rounds of substitution and deletion mutagenesis; the execution order of these two operations is interchangeable. 
To reduce excessive computational cost, we adopted a tiered screening strategy: 
all newly generated variant sequences are first evaluated via Macrel (our primary prediction tool or other AMP predict tools). 
Only high-scoring candidates—defined as sequences with a Macrel score ≥ 0.9 or those ranking within the top 10% of 
all generated variants by Macrel score—are retained and subjected to subsequent rounds of saturated substitution/deletion mutagenesis.
