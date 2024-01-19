#!/bin/bash
echo " ** ExtractAllBas.sh out-of-date **";exit 1
# ExtractAllBas.sh - Extract all .bas modules from Module1.xba.
# 8/19/23.	wmk.
#
# Usage. bash  ExtractAllBas.sh
#
# Entry. *folderbase/GitHub/Libraries-Project/MNcrwg44586/Basic/Module1/extractallnames.txt
#	to extract.
#
# Dependencies.
#
# Modification History.
# ---------------------
# 8/19/23.	wmk.	original shell (template)
#
# Notes. 
#
# set parameters P1..Pn here..
#
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ]; then
  export folderbase=/media/ubuntu/Windows/Users/Bill
 else
  export folderbase=$HOME
 fi
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories/MN/CRWG/44586
fi
if [ -z "$codebase" ];then
 export codebase=$folderbase/GitHub/TerritoriesCB/MNcrwg44586
fi
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "  ExtractAllBas - initiated from Make"
  echo "  ExtractAllBas - initiated from Make"
else
  ~/sysprocs/LOGMSG "  ExtractAllBas - initiated from Terminal"
  echo "  ExtractAllBas - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 . ~/GitHub/TerritoriesCB/Procs-Dev/SetToday.sh
#TODAY=2022-04-22
fi
#procbodyhere
pushd ./ > /dev/null
projpath=$codebase/Projects-Geany/EditBas
# loop on extracallnames.txt list
file=$folderbase/GitHub/Libraries-Project/MNcrwg44586/Basic/Module1/extractallnames.txt
while read -e; do
 echo "processing $REPLY ..."
 $projpath/DoSed.sh $REPLY Module1
 make -f $projpath/MakeExtractBas
done < $file
popd > /dev/null
#endprocbody
echo "  ExtractAllBas complete."
~/sysprocs/LOGMSG "  ExtractAllBas complete."
# end ExtractAllBas.sh
