#!/bin/bash
# Preprocess script for the Messidor-Original data set.

# Assumes that the data set resides in ./data/messidor.

#messidor_download_url="http://webeye.ophth.uiowa.edu/abramoff/messidor-2.zip"
messidor_dir="./content/PCO102/data/messidor2"
#messidor_path="$messidor_dir/messidor-2.zip"
grades_path="./content/PCO102/data/abramoff-messidor-2-refstandard-jul16.csv"
default_output_dir="$messidor_dir/bin2"

check_parameters()
{
  if [ "$1" -ge 3 ]; then
    echo "Illegal number of parameters".
    exit 1
  fi
  if [ "$1" -ge 1 ]; then
    for param in $2; do
      if [ $(echo "$3" | grep -c -- "$param") -eq 0 ]; then
        echo "Unknown parameter $param."
        exit 1
      fi
    done
  fi
  return 0
}

strip_params=$(echo "$@" | sed "s/--\([a-z]\+\)\(=\(.\+\)\)\?/\1/g")
check_parameters "$#" "$strip_params" "output"

# Copying labels file from vendor to data directory.
cp "$grades_path" "$messidor_dir/labels.csv"

# Preprocess the data set and categorize the images by labels into
#  subdirectories.
python preprocess_messidor2.py --data_dir="$messidor_dir" || exit 1

echo "Preparing data set..."
mkdir -p "$output_dir/0" "$output_dir/1"

echo "Moving images to new directories..."
find "$messidor_dir/0" -iname "*.jpg" -exec mv {} "$output_dir/0/." \;
find "$messidor_dir/1" -iname "*.jpg" -exec mv {} "$output_dir/1/." \;

echo "Done!"
exit

# References:
# [1] http://www.adcis.net/en/Download-Third-Party/Messidor.html
# https://github.com/mikevoets/jama16-retina-replication
