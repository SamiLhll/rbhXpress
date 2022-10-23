 
<img src="https://github.com/SamiLhll/mbhXpress/blob/d6f560933a94f1caafbb4c70a15d23d74746173f/inst/img/mbhXpress_cover.png" alt="mbhXpress" width="400"/>
 
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

A shell script for speedy computing of mutual best hits between two proteomes.  

## Install :


```{bash}

# download :
wget https://github.com/SamiLhll/mbhXpress/releases/download/v1.0.0/mbhXpress.linux.tar.gz

# uncompress :
tar -xzf mbhXpress.linux.tar.gz

# test you can execute the script with :
bash mbhXpress/mbh_express.sh -h

# if not make it executable with :
chmod +x mbhXpress/mbh_express.sh

### OPTIONAL :
# you can an add alias to your ~/.bashrc so you can run the script by simply typing mbhXpress in the terminal.   
# to do it type the following command, replacing <path_to_mbhXpress.sh> by the actual path of this file on your machine :
echo "alias mbhXpress=\"./<path_to_mbhXpress.sh>\"" | tee -a ~/.bashrc
# and finally :
source ~/.bashrc

```

## Usage : 

The tool consist of a shell script and a distribution of diamond blast.   
Run the bashscript in a terminal with the following mandatory arguments :   
-a PROTEOME1 (fasta format)   
-b PROTEOME2 (fasta format)   
-o OUTPUT_NAME (path to the file to write the mutual best hits)   
-t THREADS (number specifying the amount of threads dedicated to the job)   

## Example : 

If I want to run the tool on B.floridae () vs M.yessoensis () using 6 threads I would do :

```{bash}

bash mbhXpress.sh \
-a GCF_000003815.2_Bfl_VNyyK_protein.faa \
-b GCF_002113885.1_ASM211388v2_protein.faa \
-o Bflo_Myes \
-t 6

```
It will give you an output like :   

\---------------------------------------------   
mbhXpress v1.0.0   
\---------------------------------------------   

- creating databases   
 - creating databases : DONE   
 - run the blast : a vs b   
 - run the blast : b vs a   
 - run the blast : DONE   
 - compute significant hits   
 - select the mutual best hits   
 - cleaning temporary files   

\---------------------------------------------   
Done : found 8616 mutual best hits.   
Output written in Bflo_Myes  
\---------------------------------------------   

## External dependencies :

The script uses diamond v2.0.15([Buchfink, B., Reuter, K., & Drost, H. (2021)](https://doi.org/10.1038/s41592-021-01101-x)) which is distributed within the release of this tool.   
No need for the users to do anything about it.


### Runtime :

In the example above, using 6 threads for the two protein datasets of ~40k sequences each, it took 1m12,433s for the script to complete.

