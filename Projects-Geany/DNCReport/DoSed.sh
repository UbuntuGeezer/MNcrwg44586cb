#!/bin/bash
echo " ** DoSed.sh out-of-date **";exit 1
echo " ** DoSed.sh out-of-date **";exit 1
# 5/17/23.    wmk.
#DoSed.sh - perform sed modifications of ..
#	5/17/23.	wmk.
#	Usage.	bash DoSed.sh <terrid>
echo "DoSed.sh - nothing to do, exiting."
exit 0
#
P1=$1
TN="Terr"
echo "s/yyy/$P1/g" > sedative.txt 
sed -f sedative.txt MakeFixAnySC.tmp > MakeFixAnySC
echo "  DoSed complete."
# end DoSed.sh
