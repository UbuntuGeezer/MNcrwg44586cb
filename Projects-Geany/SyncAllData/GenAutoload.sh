#!/bin/bash
echo " ** GenAutoload.sh out-of-date **";exit 1
echo " ** GenAutoload.sh out-of-date **";exit 1
# GenAutoload.sh - Generate autoload.csv from PToodList.
#	3/28/23.	wmk.
mawk '{print substr($1,5,3)}' PToodList.txt > autoload.csv
# end GenAutoload.sh
