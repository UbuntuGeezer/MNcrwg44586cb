#!/bin/bash
echo " ** DoSed.sh out-of-date **";exit 1
echo " ** DoSed.sh out-of-date **";exit 1
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
#DoSed.sh - perform sed modifications of MakeFixAnyRU.
#	6/18/22.	wmk.
#	Usage.	bash DoSed.sh <terrid>
#
# Modification History.
# ---------------------
# 4/16/21.	wmk.	original code.
# 6/18/22.	wmk.	P1 checked.
P1=$1
if [ -z "$P1" ];then
 echo "DoSed <terrid> missing parameter - abandoned."
 exit 1
fi
TN="Terr"
echo "s/yyy/$P1/g" > sedative.txt 
sed -f sedative.txt MakeFixAnyRU.tmp > MakeFixAnyRU
echo "  DoSed complete."
