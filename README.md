 
 # rbhXpress
  
A shell script that uses diamond to compute the reciprocal best hits between two proteomes.  

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

# Installation :

* download :
```{bash}
wget https://github.com/SamiLhll/rbhXpress/releases/download/v1.2.2/rbhXpress.tar.gz
```
* uncompress :
```{bash}
tar -xzf rbhXpress.tar.gz
```
On MacOS you'll need to install your own version of diamond blast.   
You can do it using Homebrew as following :

```{bash}
brew install diamond
```

(OPTIONAL) you can an add alias to your ~/.bashrc so you can run the script by typing rbhXpress in the terminal.   
to do it type the following command, replacing *<path_to_rbhXpress.sh>* by the actual path of this file on your machine :

```{bash}
echo "alias rbhXpress=\"./<path_to_rbhXpress.sh>\"" | tee -a ~/.bashrc
source ~/.bashrc
```


# Usage : 

The tool consist of a shell script and a binary of diamond blast.   
Run the bashscript in a terminal with the following mandatory arguments :   

-a PROTEOME1 (fasta format, also works with simlinks)   
-b PROTEOME2 (fasta format, also works with simlinks)   
-o OUTPUT_NAME (path to the file to write the mutual best hits)   
-t THREADS (number specifying the amount of threads dedicated to the job)   

# Example : 

To run the tool and compare the proteomes downloaded from NCBI for the lancelet Branchiostoma floridae ([Simakov et al.2020](https://doi.org/10.1038/s41559-020-1156-z)) against the deep-sea tube worm Paraescarpia echinospica ([Sun et al. 2021](https://doi.org/10.1093/molbev/msab203)) using 6 threads, type in your terminal :

```{bash}

bash rbhXpress.sh \
-a GCF_000003815.2_Bfl_VNyyK_protein.faa \
-b Pec_ragoo_v1.0.pep.fasta \
-o Bflo_Pech.txt \
-t 6

```

It gives the following output :   

```{bash}
---------------------------------------------
             rbhXpress v1.2.1
---------------------------------------------
 - creating databases
 - creating databases : DONE
 - run the blast : a vs b
 - run the blast : b vs a
 - run the blast : DONE
 - select the reciprocal best hits
 - cleaning temporary files
---------------------------------------------
   Done : found 6833 reciprocal best hits.
   Output written in Bflo_Pech.txt
   Log written in Bflo_Pech.txt.log
---------------------------------------------
```

The resulting tab separated table written in Bflo_Pech.txt reports one line per orthologous pair with sequence names of file **a** in first column, and sequence names of file **b** in the second column :

```{bash}
head Bflo_Pech.txt
```

```{bash}
NP_007761.1	PE_Scaf9739_0.3
NP_007765.1	PE_Scaf9739_0.0
XP_035657338.1	PE_Scaf5545_2.9
XP_035657343.1	PE_Scaf1142_1.4
XP_035657346.1	PE_Scaf6666_2.9
XP_035657360.1	PE_Scaf2739_0.6
XP_035657364.1	PE_Scaf7376_3.8
XP_035657370.1	PE_Scaf326_2.2
XP_035657384.1	PE_Scaf12405_1.2
XP_035657407.1	PE_Scaf289_1.3
```


# External dependencies :

The script uses diamond v2.0.15 ([Buchfink, B., Reuter, K., & Drost, H. (2021)](https://doi.org/10.1038/s41592-021-01101-x)).   
A binary for linux is attached within the releases of this tool.   
Linux users don't have todo anything about it, while macOS users have to install it using Homebrew.


# Runtime :

In the example above, using 6 threads for the two protein datasets of ~40k sequences each, it took 1m12,433s for the script to complete.

