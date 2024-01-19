#!/bin/bash
echo " ** DoSed.sh out-of-date **";exit 1
echo " ** DoSed.sh out-of-date **";exit 1
#DoSed.sh - perform sed modifications of MakeBridgesToTerr.
#	3/9/23.	wmk.
#	Usage.	bash DoSed.sh <terrid>
#
# Modification History.
# ---------------------
# 9/23/22.  wmk.    (automated) CB *codebase env var support.
# 10/4/22.  wmk.    (automated) fix *pathbase for CB system.
# 10/5/22.	wmk.	comments tidied.
# 3/9/23.	wmk.	parameter check added.
# Legacy mods.
# 4/11/21.	wmk.	original code.
P1=$1
if [ -z "$P1" ];then
 echo "DoSed <terrid> missing parameter(s) - abandoned."
 exit 1
fi
TN="Terr"
echo "s/yyy/$P1/g" > sedative.txt
sed -f sedative.txt  MakeBridgesToTerr.tmp > MakeBridgesToTerr
echo "  DoSed complete."
