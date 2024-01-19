#!/bin/bash
# DoSed.sh - DoSed for ReleaseData project.
#	3/5/23.	wmk.
#
# Usage.  bash DoSed.sh <mm> <dd>
#
#	<mm> = month of release
#	<dd> = day of release
#
# Modification History.
# ---------------------
# 3/6/23.	wmk.	modified for CB system; *codebase support.
# Legady mods.
# 10/28/21.	wmk.	original code.
# 5/7/22.	wmk.	*pathbase* support.
# 6/16/22.	wmk.	parameter checking added.
P1=$1
P2=$2
if [ -z "$P1" ] || [ -z "$P2" ];then
 echo "DoSed <mm> <dd> missing parameter(s) - abandoned."
 exit 1
fi
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
echo "s?@@?$P2?g" > sedatives.txt
echo "s?zz?$P1?g" >> sedatives.txt
sed -f sedatives.txt MakeReleaseData.tmp > MakeReleaseData
popd
echo "DoSed complete."
