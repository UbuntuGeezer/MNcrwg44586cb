#!/bin/bash
echo " ** DoSed.sh out-of-date **";exit 1
#DoSed.sh - perform sed modifications of MakeUpdateSCBridge and pathSCDefs.inc.
#	6/7/23.	wmk.
#
#	Usage.	bash DoSed.sh <terrid> mm dd
#		<terrid> = territory ID
#		mm = month of Diff .db to check
#		dd = day of Diff .db to check
#
#	Exit.	MakeUpdateSCBridge.tmp edited to MakeUpdateSCBridge
#			($)incroot/PathSCdefs.i edited to PathSCdefs.inc
#			FixSCMenu.in edited to FixSCMenu.inc
#			UpdateSCBridge.psq > UpdateSCBridge.sql
#			MakeTerrUpdtSpecBridge.tmp > MakeTerrUpdtSpecBridge
#			UpdtSpecBridge.psq > UpdtSpecBridge.sql
#
#
# Modification History.
# ---------------------
# 12/26/22.	wmk.	MakeTerrUpdtSpecSCBridge, UpdtSpecSCBridge support.
# 6/7/23.	wmk.	OBSOLETE territory detection.
# Legacy mods.
# 4/25/22.	wmk.	modified for general use;*pathbase* support.
# 5/2/22.	wmk.	GetTIDList.psq added to edit list; UpdateSCBridge.psq
#			 added to *sed* list for *pathbase* support.
# 9/23/22.   wmk.  (automated) CB *codebase env var support.
# Legacy mods.
# 3/30/21.	wmk.	original shell.
# 5/27/21.	wmk.	modified to use env var HOME to determine Territories path.
# 6/18/21.	wmk.	multihost support generalized.
# 6/26/21.	wmk.	superfluous "s removed; exit documentation added.
P1=$1
P2=$2
P3=$3
if [ -z "$folderbase" ];then
 if [ "$USER" = "ubuntu" ]; then
   terrbase=/media/ubuntu/Windows/Users/Bill
   folderbase=/media/ubuntu/Windows/Users/Bill
 else
   terrbase=$HOME
   folderbase=$HOME
 fi
fi
if [ -z "$codebase" ];then
 codebase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$pathbase" ];then
 pathbase=$folderbase/Territories/FL/SARA/86777
fi
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ]; then
 echo " DoSed - territory mm dd - must be specified - aborted."
 exit 1
fi
if test -f $pathbase/$rupath/Terr$P1/OBSOLETE;then
 echo " ** Territory $P1 OBSOLETE - UpdateSCBridge/DoSed exiting..**"
 exit 2
fi
TN="Terr"
incroot=$codebase/include
echo "{s/yyy/$P1/g;s/@@/$P2/g;s/zz/$P3/g}" > sedative.txt
echo "s?%folderbase?$pathbase?g" >> sedative.txt
sed -f sedative.txt MakeUpdateSCBridge.tmp > MakeUpdateSCBridge
sed -f sedative.txt GetSCUpdateList.psq > GetSCUpdateList.sql
sed -f sedative.txt GetTIDList.psq > GetTIDList.sql
sed -f sedative.txt MakeTerrUpdtSpecBridge.tmp > MakeTerrUpdtSpecBridge
sed -f sedative.txt TerrUpdtSpecBridge.psq > TerrUpdtSpecBridge.sql
sed "{s?xxx?$P1?g;s?MM?$P2?g;s?DD?$P3?}" \
	 UpdateSCBridge.psq  > UpdateSCBridge.sql
echo "s/yyy/$P1/g" > sedative.txt
sed -f sedative.txt $incroot/pathSCdefs.i > pathSCdefs.inc
echo "s/www/$P1/g" > sedative.txt
sed -f sedative.txt FixSCMenu.in > FixSCMenu.inc
echo "  DoSed complete."
