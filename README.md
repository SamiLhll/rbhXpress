 
 # mbhXpress <a><img src='https://github.com/SamiLhll/mbhXpress/blob/d6f560933a94f1caafbb4c70a15d23d74746173f/inst/img/mbhXpress_cover.png' align="right" height="138.5" /></a>
  
A shell script that rapidly computes the mutual best hits between two proteomes.  

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

# Installation :

download :
```{bash}
wget https://github.com/SamiLhll/mbhXpress/releases/download/v1.2.0/mbhXpress.tar.gz
```
uncompress :
```{bash}
tar -xzf mbhXpress.tar.gz
```
On MacOSX you'll need to install your own version of diamond blast.   
You can do it using Homebrew as following :
```{bash}
brew install diamond
```
(OPTIONAL) you can an add alias to your ~/.bashrc so you can run the script by typing mbhXpress in the terminal.   
to do it type the following command, replacing *<path_to_mbhXpress.sh>* by the actual path of this file on your machine :
```{bash}
echo "alias mbhXpress=\"./<path_to_mbhXpress.sh>\"" | tee -a ~/.bashrc
source ~/.bashrc
```


# Usage : 

The tool consist of a shell script and a distribution of diamond blast.   
Run the bashscript in a terminal with the following mandatory arguments :   

-a PROTEOME1 (fasta format)   
-b PROTEOME2 (fasta format)   
-o OUTPUT_NAME (path to the file to write the mutual best hits)   
-t THREADS (number specifying the amount of threads dedicated to the job)   

# Example : 

To run the tool and compare the proteomes downloaded from NCBI for the lancelet B.floridae ([Simakov et al.2020](https://doi.org/10.1038/s41559-020-1156-z)) against the scallop M.yessoensis ([Wang et al. 2017](https://doi.org/10.1038/s41559-017-0120)) using 6 threads, type in your terminal :

```{bash}

bash mbhXpress.sh \
-a GCF_000003815.2_Bfl_VNyyK_protein.faa \
-b GCF_002113885.1_ASM211388v2_protein.faa \
-o Bflo_Myes.txt \
-t 6

```
It gives the following output :   

```{bash}
---------------------------------------------
             mbhXpress v1.2.0
---------------------------------------------
 - creating databases
 - creating databases : DONE
 - run the blast : a vs b
 - run the blast : b vs a
 - run the blast : DONE
 - select the mutual best hits
 - cleaning temporary files
---------------------------------------------
   Done : found 8616 mutual best hits.
   Output written in Bflo_Myes
   Log written in LOG.Bflo_Myes
---------------------------------------------
```

# External dependencies :

The script uses diamond v2.0.15 ([Buchfink, B., Reuter, K., & Drost, H. (2021)](https://doi.org/10.1038/s41592-021-01101-x)).   
A linux version is distributed within the release of this tool.   
Linux users don't have todo anything about it, while macOSX users have to install it using Homebrew.


# Runtime :

In the example above, using 6 threads for the two protein datasets of ~40k sequences each, it took 1m12,433s for the script to complete.

