#!/usr/bin/env bash

#######################################################
# mbhXpress v1.0.0
# Sami El Hilali
# 2022_octobre_22
#######################################################

# This scrips takes two protein sets (fasta) and blast (diamond blastp)
# each one against the other to get the mutual best hits

####### PARSE parameters

while getopts a:b:o:t:h option
do
	case "${option}"
	in
	a) PROTEOME1=${OPTARG};;
	b) PROTEOME2=${OPTARG};;
	o) OUTPUT_NAME=${OPTARG};;
	t) THREADS=${OPTARG};;
	h) echo "mbhXpress v1.0.0 - usage :";
	   echo "-a PROTEOME1";
	   echo "-b PROTEOME2";
	   echo "-o OUTPUT_NAME";
	   echo "-t THREADS";
	   exit;;
	?) echo "mbhXpress v1.0.0 - usage :";
	   echo "-a PROTEOME1";
	   echo "-b PROTEOM2";
	   echo "-o OUTPUT_NAME";
	   echo "-t THREADS";
	   exit;;
	esac
done

#########################
# exit if a command fails
set -e
########

# More options :
if [ "$(uname)" == "Darwin" ]; then
  diamond_path="diamond";
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
  diamond_path="$(dirname "$0")/bin/diamond";
fi

run_id=($(echo "$RANDOM"))
> LOG.$OUTPUT_NAME
echo "---------------------------------------------" | tee -a LOG.$OUTPUT_NAME
echo "             mbhXpress v1.0.0" | tee -a LOG.$OUTPUT_NAME
echo "---------------------------------------------" | tee -a LOG.$OUTPUT_NAME

######################### RUN

# create the blast databases :
echo " - creating databases" | tee -a LOG.$OUTPUT_NAME
$diamond_path makedb --in $PROTEOME1 -d "$run_id.p1" &> LOG.$OUTPUT_NAME
$diamond_path makedb --in $PROTEOME2 -d "$run_id.p2" &> LOG.$OUTPUT_NAME

echo " - creating databases : DONE" | tee -a LOG.$OUTPUT_NAME

# Run the blast :
echo " - run the blast : a vs b" | tee -a LOG.$OUTPUT_NAME
$diamond_path blastp -q $PROTEOME2 -d "$run_id.p1" -o "$run_id.p2_p1" -k 1 --threads $THREADS &> LOG.$OUTPUT_NAME
echo " - run the blast : b vs a" | tee -a LOG.$OUTPUT_NAME
$diamond_path blastp -q $PROTEOME1 -d "$run_id.p2" -o "$run_id.p1_p2" -k 1 --threads $THREADS &> LOG.$OUTPUT_NAME

echo " - run the blast : DONE" | tee -a LOG.$OUTPUT_NAME

# select only the significant hits, then select the highest bitscore for the query :
echo " - compute significant hits" | tee -a LOG.$OUTPUT_NAME

awk '($11 <= 1e-10) { print $1"\t"$2"\t"$12}' $run_id.p2_p1 | \
awk '$3>max[$1]{max[$1]=$3; row[$1]=$1"\t"$2} END {for (i in row) print row[i]}' > $run_id.p2_p1.s

awk '($11 <= 1e-10) { print $1"\t"$2"\t"$12}' $run_id.p1_p2 | \
awk '$3>max[$1]{max[$1]=$3; row[$1]=$1"\t"$2} END {for (i in row) print row[i]}' > $run_id.p1_p2.s

# select the Mutual Best hits :
echo " - select the mutual best hits" | tee -a LOG.$OUTPUT_NAME

comm -12 <(awk '{print $2"\t"$1}' $run_id.p2_p1.s | sort -k1) <(awk '{print $1"\t"$2}' $run_id.p1_p2.s | sort -k1) \
> $OUTPUT_NAME

# remove intermediate files :
echo " - cleaning temporary files" | tee -a LOG.$OUTPUT_NAME
rm $run_id.*

# write output message :
amount_mbh=($(wc -l $OUTPUT_NAME))
echo "---------------------------------------------" | tee -a LOG.$OUTPUT_NAME
echo "   Done : found $amount_mbh mutual best hits." | tee -a LOG.$OUTPUT_NAME
echo "   Output written in $OUTPUT_NAME" | tee -a LOG.$OUTPUT_NAME
echo "---------------------------------------------" | tee -a LOG.$OUTPUT_NAME
######################### DONE
