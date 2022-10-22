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
script_full_path=$(dirname "$0")
run_id=($(date --rfc-3339='ns'| cut -d " " -f2 | sed -e 's/:/_/g' -e 's/\./_/g' -e 's/\+//g'))

echo "---------------------------------------------"
echo "             mbhXpress v1.0.0"
echo "---------------------------------------------"
######################### RUN

# create the blast databases :
echo " - creating databases"
$script_full_path/bin/diamond makedb --in $PROTEOME1 -d "$run_id.p1" &> /dev/null
$script_full_path/bin/diamond makedb --in $PROTEOME2 -d "$run_id.p2" &> /dev/null

echo " - creating databases : DONE"

# Run the blast :
echo " - run the blast : a vs b"
$script_full_path/bin/diamond blastp -q $PROTEOME2 -d "$run_id.p1" -o "$run_id.p2_p1" -k 1 --threads $THREADS &> /dev/null
echo " - run the blast : b vs a"
$script_full_path/bin/diamond blastp -q $PROTEOME1 -d "$run_id.p2" -o "$run_id.p1_p2" -k 1 --threads $THREADS &> /dev/null

echo " - run the blast : DONE"

# select only the significant hits, then select the highest bitscore for the query :
echo " - compute significant hits"

awk '($11 <= 1e-10) { print $1"\t"$2"\t"$12}' $run_id.p2_p1 | \
awk '$3>max[$1]{max[$1]=$3; row[$1]=$1"\t"$2} END {for (i in row) print row[i]}' > $run_id.p2_p1.s

awk '($11 <= 1e-10) { print $1"\t"$2"\t"$12}' $run_id.p1_p2 | \
awk '$3>max[$1]{max[$1]=$3; row[$1]=$1"\t"$2} END {for (i in row) print row[i]}' > $run_id.p1_p2.s

# select the Mutual Best hits :
echo " - select the mutual best hits"

comm -12 <(awk '{print $2"\t"$1}' $run_id.p2_p1.s | sort -k1) <(awk '{print $1"\t"$2}' $run_id.p1_p2.s | sort -k1) \
> $OUTPUT_NAME

# remove intermediate files :
echo " - cleaning temporary files"
rm $run_id.*

# write output message :
amount_mbh=($(wc -l $OUTPUT_NAME))
echo "---------------------------------------------"
echo "   Done : found $amount_mbh mutual best hits."
echo "   Output written in $OUTPUT_NAME"
echo "---------------------------------------------"
######################### DONE
