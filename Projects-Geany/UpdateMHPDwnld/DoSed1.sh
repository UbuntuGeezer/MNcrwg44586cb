#!/bin/bash
#DoSed1.sh - perform sed modifications of MakeRUMHP.
#	6/6/23.	wmk.
#
#	Usage.	bash DoSed1.sh <terrid> <db-name>
#		<terrid> = territory ID
#		<db-name> = Special database name (e.g. BayIndies)
#
#	Exit.	MakeRUHMP.tmp edited to MakeRUMHP
#			($)incroot/PathRUdefs.i edited to PathRUdefs.inc
#			AddMHPTable.sq edited to AddMHPTable.sql with terrid
#
# Modification History.
# ---------------------
# 6/6/23.	wmk.	OBSOLETE territory detection; comments tidied.
# Legacy mods.
# 7/4/21.	wmk.	original shell; adapted from UpdateMNPDwnld/DoSed.
# 7/6/21.	wmk.	Usage documentation updated.
# 9/23/22.  wmk.    (automated) CB *codebase env var support.
#
# P1 is territory ID; P2 = MHP dbname (e.g. BayIndies)
P1=$1
P2=$2
if [ "$HOME" == "/home/ubuntu" ]; then
   export terrbase=/media/ubuntu/Windows/Users/Bill
   export folderbase=/media/ubuntu/Windows/Users/Bill
else
   export terrbase=$HOME
   export folderbase=$HOME
fi
if [ -z "$codebase" ];
 export codebase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories/FL/SARA/86777
fi
if [ -z "$P1" ]; then
 echo " DoSed1 - <terrid> - must be specified - aborted."
 exit 1
fi
if [ -z "$P2" ];then
 echo " DoSed1 - <db-name> - must be specified - aborted."
 exit 1
fi
if test -f $pathbase/Terr$P1/OBSOLETE;then
 echo " ** Territory $P1 OBSOLETE - UpdateMHPDwnld/DoSed1 exiting...**"
 exit 2
fi
TN="Terr"
incroot="$codebase/include"
echo "s?xxx?$P1?g" > sedative.txt
sed -f sedative.txt $incroot/pathRUdefs.i > pathRUdefs.inc
sed -f sedative.txt AddMHPTable.psq > AddMHPTable.sql
echo "s?yyy?$P1?g" > sedatives.txt
echo "s?vvvv?$P2?g" >> sedatives.txt
sed -f sedatives.txt MakeRUMHP.tmp > MakeRUMHP
echo "  DoSed1 complete."
