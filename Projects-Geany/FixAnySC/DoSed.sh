#!/bin/bash
#DoSed.sh - perform sed modifications of MakeFixAnySC.
#	6/5/23.	wmk.
#
#	Usage.	bash DoSed.sh <terrid>
#
# Modification History.
# ---------------------
# 4/5/22.	wmk.	original code.
# 9/23/22.  wmk.    (automated) CB *codebase env var support.
# 6/5/23.	wmk.	parameter checking added.
P1=$1
if [ -z "$P1" ];then
 echo "DoSed  <terrid> missing parameter(s) - abandoned."
 exit 1
fi
TN="Terr"
echo "s/yyy/$P1/g" > sedative.txt 
sed -f sedative.txt MakeFixAnySC.tmp > MakeFixAnySC
echo "  DoSed complete."
