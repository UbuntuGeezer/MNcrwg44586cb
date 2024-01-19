#!/bin/bash
echo " ** DoSed1.sh out-of-date **";exit 1
#DoSed1.sh - perform sed modifications of MakeUpdtSpecSCBridge and pathSCDefs.inc.
#	6/7/23	wmk.
#
#	Usage.	bash DoSed1.sh <special-db> mm dd
#		<special-db> = name of Special db to update
#		mm = month of Diff .db to check
#		dd = day of Diff .db to check
#
#	Exit.	MakeUpdateSCBridge.tmp edited to MakeUpdateSCBridge
#			($)incroot/PathSCdefs.i edited to PathSCdefs.inc
#			FixSCMenu.in edited to FixSCMenu.inc
#
#
# Modification History.
# ---------------------
# 5/27/22.	wmk.	*pathbase* support.
# 9/23/22.  wmk.    (automated) CB *codebase env var support.
# 6/7/23.	wmk.	comments tidied.
# Legacy mods.
# 3/30/21.	wmk.	original shell.
# 5/27/21.	wmk.	modified to use env var HOME to determine Territories path.
# 6/18/21.	wmk.	multihost support generalized.
# 6/26/21.	wmk.	superfluous "s removed; exit documentation added.
# 1/3/22.	wmk.	comments corrected; USER replaces HOME in host check.
P1=$1
P2=$2
P3=$3
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ]; then
  export folderbase=/media/ubuntu/Windows/Users/Bill
 else
  export folderbase=$HOME
 fi
fi
TEMP_PATH=$HOME/temp
if [ -z "$codebase" ];then
 codebase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories
fi
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ]; then
 echo " DoSed1 - <special-db> mm dd - must be specified - aborted."
 exit 1
fi
TN="Terr"
echo "s?<special-db>?$P1?g" > sedatives.txt
echo "s?@@?$P2?g;s?zz?$P3?g" >> sedatives.txt
sed -f sedatives.txt MakeUpdtSpecSCBridge.tmp > MakeUpdtSpecSCBridge
sed -f sedatives.txt UpdtSpecSCBridge.psq > UpdtSpecSCBridge.sql
echo "  DoSed11 complete."
