#!/usr/bin/env bash

#######################################################
# rbhXpress v1.2.3
# Sami El Hilali
# 2022_november_15
#######################################################

# This scrips takes two protein sets (fasta) and performs a blast (diamond blastp)
# of each one against the other to get the reciprocal best hits

####### PARSE parameters

while getopts a:b:o:t:h option
do
	case "${option}"
	in
	a) PROTEOME1=${OPTARG};;
	b) PROTEOME2=${OPTARG};;
	o) OUTPUT_NAME=${OPTARG};;
	t) THREADS=${OPTARG};;
	h) echo "rbhXpress v1.2.3 - usage :";
	   echo "-a PROTEOME1";
	   echo "-b PROTEOME2";
	   echo "-o OUTPUT_NAME";
	   echo "-t THREADS";
	   exit;;
	?) echo "rbhXpress v1.2.3 - usage :";
	   echo "-a PROTEOME1";
	   echo "-b PROTEOM2";
	   echo "-o OUTPUT_NAME";
	   echo "-t THREADS";
	   exit;;
	esac
done

#########################
#### exit if :
# A command fails :
set -e
# The PROTEOME1 doesn't exist :
if [ ! -f "$PROTEOME1" ]; then
    echo "$PROTEOME1 does not exist.";
    exit;
fi
# The PROTEOME2 doesn't exist :
if [ ! -f "$PROTEOME2" ]; then
    echo "$PROTEOME2 does not exist."
    exit;
fi
########

# More options :
if [ "$(uname)" == "Darwin" ]; then
  diamond_path="diamond";
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
  diamond_path="$(dirname "$0")/bin/diamond";
fi

run_id=($(echo "$RANDOM"))
> $OUTPUT_NAME.log
echo "---------------------------------------------" | tee -a $OUTPUT_NAME.log
echo "             rbhXpress v1.2.3" | tee -a $OUTPUT_NAME.log
echo "---------------------------------------------" | tee -a $OUTPUT_NAME.log

######################### RUN

# create the blast databases :
echo " - creating databases" | tee -a $OUTPUT_NAME.log
$diamond_path makedb --in $PROTEOME1 -d "$run_id.p1" --ignore-warnings &> $OUTPUT_NAME.log
$diamond_path makedb --in $PROTEOME2 -d "$run_id.p2" --ignore-warnings &> $OUTPUT_NAME.log

echo " - creating databases : DONE" | tee -a $OUTPUT_NAME.log

# Run the blast :
echo " - run the blast : a vs b" | tee -a $OUTPUT_NAME.log
$diamond_path blastp -q $PROTEOME2 -d "$run_id.p1" -o "$run_id.p2_p1" -k 1 -e 1E-10 --threads $THREADS --ignore-warnings &> $OUTPUT_NAME.log
echo " - run the blast : b vs a" | tee -a $OUTPUT_NAME.log
$diamond_path blastp -q $PROTEOME1 -d "$run_id.p2" -o "$run_id.p1_p2" -k 1 -e 1E-10 --threads $THREADS --ignore-warnings &> $OUTPUT_NAME.log

echo " - run the blast : DONE" | tee -a $OUTPUT_NAME.log

# select the reciprocal best hits :
echo " - select the reciprocal best hits" | tee -a $OUTPUT_NAME.log

cut -f1,2,12 $run_id.p2_p1 | awk '$3>max[$1]{max[$1]=$3; row[$1]=$1"\t"$2} END {for (i in row) print row[i]}' > $run_id.p2_p1.s
cut -f1,2,12 $run_id.p1_p2 | awk '$3>max[$1]{max[$1]=$3; row[$1]=$1"\t"$2} END {for (i in row) print row[i]}' > $run_id.p1_p2.s

comm -12 <(awk '{print $2"\t"$1}' $run_id.p2_p1.s | sort -k1) <(awk '{print $1"\t"$2}' $run_id.p1_p2.s | sort -k1) \
> $OUTPUT_NAME

# remove intermediate files :
echo " - cleaning temporary files" | tee -a $OUTPUT_NAME.log
rm $run_id.*

# write output message :
amount_rbh=($(wc -l $OUTPUT_NAME))
echo "---------------------------------------------" | tee -a $OUTPUT_NAME.log
echo "   Done : found $amount_rbh reciprocal best hits." | tee -a $OUTPUT_NAME.log
echo "   Output written in $OUTPUT_NAME" | tee -a $OUTPUT_NAME.log
echo "   Log written in $OUTPUT_NAME.log" | tee -a $OUTPUT_NAME.log
echo "---------------------------------------------" | tee -a $OUTPUT_NAME.log

######################### DONE
