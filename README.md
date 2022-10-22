# mbhXpress

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

shell script to compute mutual best hits of fasta proteomes using diamond blastp :


# usage : 

mbhXpress v1.0.0 - usage :   
-a PROTEOME1   
-b PROTEOME2   
-o OUTPUT_NAME   
-t THREADS   

To it run for example on B.floridae vs Mizuhopecten yessoensis using 6 threads you can run the following output.

```{bash}

bash mbhXpress.sh \
-a DATA/GCF_000003815.2_Bfl_VNyyK_protein.faa \
-b DATA/GCF_002113885.1_ASM211388v2_protein.faa \
-o Bflo_Myes \
-t 6

```
It will give you an output like :   

#---------------------------------------------   
mbhXpress v1.0.0   
#---------------------------------------------   
 - creating databases   
 - creating databases : DONE   
 - run the blast : a vs b   
 - run the blast : b vs a   
 - run the blast : DONE   
 - compute significant hits   
 - select the mutual best hits   
 - cleaning temporary files   
#---------------------------------------------   
Done : found 8616 mutual best hits.   
Output written in Bflo_Myes.tab   
#---------------------------------------------   

# external dependencies :

The script uses diamond (v2.0.15 is provided along with the script) :   

Buchfink, B., Reuter, K., & Drost, H. (2021). Sensitive protein alignments at tree-of-life scale using DIAMOND (Version 2.0.11) [Computer software]. https://doi.org/10.1038/s41592-021-01101-x


# runtime :

Using 6 threads for two protein datasets of ~40k sequences each, I get the results in 1m12,433s

