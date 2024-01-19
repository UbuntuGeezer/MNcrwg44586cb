#!/bin/bash
echo " ** DoSed2.sh out-of-date **";exit 1
#DoSed2.sh - perform sed modifications of GetTIDList.psq.
#	6/7/23.	wmk.
#
#	Usage.	bash DoSed2.sh  mm dd
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
# 11/22/22.	wmk.	*codebase support.
# 6/7/23.	wmk.	bug fix parameter P1 <spec-db> eliminated.
# Legacy mods.
# 5/27/22.	wmk.	*pathbase* support; pathbase correcred.
# 9/23/22.  wmk.    (automated) CB *codebase env var support.
# Legacy mods.
# 3/30/21.	wmk.	original shell.
# 5/27/21.	wmk.	modified to use env var HOME to determine Territories path.
# 6/18/21.	wmk.	multihost support generalized.
# 6/26/21.	wmk.	superfluous "s removed; exit documentation added.
# 1/3/22.	wmk.	comments corrected; USER replaces HOME in host check.
#
# DoSed2 edits any files than only need @ @  z z changed to the new download
# month and day. GetTIDList.psq,...
#
P1=$1
P2=$2
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
 export pathbase=$folderbase/Territories/FL/SARA/86777
fi
if [ -z "$P1" ] || [ -z "$P2" ]; then
 echo " DoSed2 - mm dd - must be specified - aborted."
 exit 1
fi
TN="Terr"
echo "s?@@?$P1?g;s?zz?$P2?g" >> sedatives.txt
sed -f sedatives.txt GetTIDList.psq > GetTIDList.sql
sed -f sedatives.txt GetSCUpdateList.psq > GetSCUpdateList.sql
sed -f sedatives.txt MakeGetSCUpdateList.tmp > MakeGetSCUpdateList
echo "GetTIDList.sql built."
echo "  DoSed2 complete."
# end DoSed2.sh
