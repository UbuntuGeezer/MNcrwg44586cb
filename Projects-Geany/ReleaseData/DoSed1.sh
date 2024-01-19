#!/bin/bash
# DoSed1.sh - DoSed1 for ReleaseData project.
# 3/5/22.	wmk.
#
# Usage.  bash DoSed1.sh <terrid>
#
#	<terrid> = territory ID for PUB_NOTES_xxx.html
#
# Exit.	MakeMvPubNotes.tmp -> MakeMvPubNotes
#
# Modification History.
# ---------------------
# 3/5/23.	wmk.	modified for CB system; *codebase support.
# Legacy mods.
# 1/1/22.	wmk.	original code; adapted from DoSed
# 5/7/22.	wmk.	*pathbase* support.
P1=$1
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ]; then
   export folderbase="/media/ubuntu/Windows/Users/Bill"
 else 
  export folderbase=$HOME
 fi
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories/FL/SARA/86777
fi
if [ -z "$codebase" ];then
 export codebase=$folderbase/GitHub/TerritoriesCB
fi
pushd ./
cd $codebase/Projects-Geany/ReleaseData
echo "s?yyy?$P1?g" > sedatives.txt
sed -f sedatives.txt MakeMvPubNotes.tmp > MakeMvPubNotes
popd
echo "DoSed11 complete."
