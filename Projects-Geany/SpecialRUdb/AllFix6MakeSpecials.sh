#!/bin/bash
echo " ** AllFix6MakeSpecials.sh out-of-date **";exit 1
echo " ** AllFix6MakeSpecials.sh out-of-date **";exit 1
# AllFix6MakeSpecials.sh - Fix all Terr6xx MakeSpecials.
#	6/5/23.	wmk.
#
# Usage. AllFixMakeSpecials.sh
#
# Entry. All6Terrs.txt has list of all 6xx territory numbers.
#	  blank lines or empty starting with # are skipped.
#
# Exit. *pathbase*/../RefUSA-Downloads/Terr6xx/MakeSpecials files fixed.
#
# Modification History.
# ---------------------
# 6/5/23.	wmk.	OBSOLETE territory detection added; comments tidied.
# Legacy mods.
# 5/14/22.	wmk.	original code.
# 9/23/22.  wmk.    (automated) CB *codebase env var support.
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ];then
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
#
projpath=$codebase/Projects-Geany/SpecialRUdb
file=$projpath/All6Terrs.txt
while read -e;do
 TID=$REPLY
 len=${#REPLY}
 firstchar=${TID:0:1}
 if [ "$firstchar" == "#" ] || [ $len -eq 0 ];then
  echo " skipping $TID ..."
 else
  if test -f $pathbase/$rupath/Terr$TID/OBSOLETE;then
   echo " ** Territory $TID OBSOLETE - All6MakeSpecials skipping.."
  else
   echo " executing Fix6MakeSpecials $TID ..."
   $projpath/Fix6MakeSpecials.sh $TID
  fi
 fi
done < $file
echo "AllFix6MakeSpecials complete."
# end AllFix6MakeSpecials.
