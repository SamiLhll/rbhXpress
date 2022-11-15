 
 # rbhXpress
  
A shell script that uses diamond to compute the reciprocal best hits between two proteomes in a rush.  

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

# Installation :

* download :
```{bash}
wget https://github.com/SamiLhll/rbhXpress/releases/download/v1.2.3/rbhXpress.tar.gz
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

To run the tool and compare the proteomes downloaded from Ensembl for Homo sapiens ([GRCh38](https://ftp.ensembl.org/pub/release-108/fasta/homo_sapiens/pep/)) vs Mus musculus ([GRCm39](https://ftp.ensembl.org/pub/release-108/fasta/mus_musculus/pep/)) using 6 threads, type in your terminal :

```{bash}

bash rbhXpress.sh \
-a Homo_sapiens.GRCh38.pep.all.fa \
-b Mus_musculus.GRCm39.pep.all.fa \
-o Hsap_Mmus.tab \
-t 6

```

It gives the following output :   

```{bash}
---------------------------------------------
             rbhXpress v1.2.3
---------------------------------------------
 - creating databases
 - creating databases : DONE
 - run the blast : a vs b
 - run the blast : b vs a
 - run the blast : DONE
 - select the reciprocal best hits
 - cleaning temporary files
---------------------------------------------
   Done : found 24355 reciprocal best hits.
   Output written in Hsap_Mmus.tab
   Log written in Hsap_Mmus.tab.log
---------------------------------------------
```

The resulting tab separated table written in Hsap_Mmus.tab reports one line per orthologous pair with sequence names of file **a** in first column, and sequence names of file **b** in the second column :

```{bash}
head Hsap_Mmus.tab
```

```{bash}
ENSP00000000233.5	ENSMUSP00000020717.6
ENSP00000000412.3	ENSMUSP00000007602.9
ENSP00000001008.4	ENSMUSP00000032508.5
ENSP00000001146.2	ENSMUSP00000145092.2
ENSP00000002125.4	ENSMUSP00000024887.5
ENSP00000002165.5	ENSMUSP00000055519.6
ENSP00000002501.6	ENSMUSP00000135524.3
ENSP00000002596.5	ENSMUSP00000113919.2
ENSP00000002829.3	ENSMUSP00000141865.2
ENSP00000003084.6	ENSMUSP00000049228.6
```


# External dependencies :

The script uses diamond v2.0.15 ([Buchfink, B., Reuter, K., & Drost, H. (2021)](https://doi.org/10.1038/s41592-021-01101-x)).   
A binary for linux is attached within the releases of this tool.   
Linux users don't have todo anything about it, while macOS users have to install it using Homebrew.


# Runtime :

In the example above, using 6 threads for the two protein datasets of 120k and 67k sequences, it took 1m18s for the script to complete.

