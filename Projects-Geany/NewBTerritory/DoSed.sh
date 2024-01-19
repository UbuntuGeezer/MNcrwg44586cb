#!/bin/bash
echo " ** DoSed.sh out-of-date **";exit 1
echo " ** DoSed.sh out-of-date **";exit 1
#DoSed.sh - perform sed modifications of MakeNewBTerritory.
#	9/24/21.	wmk.
#	Usage.	bash DoSed.sh <terrid>
#		<terrid> = territory ID
#
# Modification History.
# ---------------------
# 9/24/21.	wmk.	original code; from MakeNewTerritory.
P1=$1
if [ -z "$P1" ]; then
 echo " DoSed - territory - must be specified - aborted."
 exit 1
fi
echo "{s/yyy/$P1/g}" > sedative.txt
sed -f sedative.txt MakeNewBTerr.tmp > MakeNewBTerr
# end DoSed
