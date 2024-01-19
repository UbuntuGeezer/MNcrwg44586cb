#!/bin/bash
echo " ** DoSed.sh out-of-date **";exit 1
echo " ** DoSed.sh out-of-date **";exit 1
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
#DoSed.sh - perform sed modifications of MakeRUNewTerritory.
#	10/15/21.	wmk.
#	Usage.	bash DoSed.sh <terrid>
#		<terrid> = territory ID
# Modification History.
# ---------------------
# 5/8/21.	wmk.	original code.
# 10/14/21.	wmk.	modified to invoke ./InitLetter.sh to set up files;
#					pathRUdefs sed eliminated.
# 10/16/21.	wmk.	superfluous ./InitLetter.sh removed.
P1=$1
if [ -z "$P1" ]; then
 echo " DoSed - territory - must be specified - aborted."
 exit 1
fi
echo "{s/yyy/$P1/g;s/@@/$P2/g;s/zz/$P3/g}" > sedative.txt
sed -f sedative.txt MakeRUNewTerritory.tmp > MakeRUNewTerritory
# end DoSed
