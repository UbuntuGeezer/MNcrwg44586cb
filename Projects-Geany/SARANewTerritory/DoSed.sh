#!/bin/bash
echo " ** DoSed.sh out-of-date **";exit 1
echo " ** DoSed.sh out-of-date **";exit 1
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
#DoSed.sh - perform sed modifications of MakeSCNewTerritory.
#	8/10/21.	wmk.
#	Usage.	bash DoSed.sh <terrid>
#		<terrid> = territory ID
#
# 	Exit.	MakeSCNewTerritory modified with territory ID and download date.
#		pathSCdefs.i modified with territory ID.
#
# Modification History.
# ---------------------
# 5/8/21.	wmk.	original code.
# 8/10/21.	wmk.	comments added.
P1=$1
if [ -z "$P1" ]; then
 echo " DoSed - territory - must be specified - aborted."
 exit 1
fi
echo "{s/yyy/$P1/g;s/@@/$P2/g;s/zz/$P3/g}" > sedative.txt
sed -f sedative.txt MakeSCNewTerritory.tmp > MakeSCNewTerritory
echo "s/xxx/$P1/g" > sedative.txt
sed -f sedative.txt pathSCdefs.i > pathSCdefs.inc
