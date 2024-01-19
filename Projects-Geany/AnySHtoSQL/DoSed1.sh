#!/bin/bash
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
# DoSed1.sh - Run sed to convert <file>.sh > <file>.sq > <file>.sql
#	12/26/21.	wmk.
#
# Usage. bash DoSed1.sh <filepath> <filebase>
#
#	<filepath> = path to file to convert
#	<filebase> = base name of file to convert
#
# Exit.	<filepath>/<filebase>.sh > .sq > .sql.
#
# Modification History.
# ---------------------
# 12/2/21.	wmk.	original code.
# 12/26/21.	wmk.	multihost folderbase fixed.
if [ "$USER" = "ubuntu" ]; then
 folderbase="$folderbase"
else 
 folderbase=$HOME
fi
if [ -z "$system_log" ]; then
 system_log=$folderbase"/ubuntu/SystemLog.txt"
fi
#
P1=$1
P2=$2
#
projbase=$codebase/Projects-Geany/AnySHtoSQL
echo "s?<filepath>?$P1?g" > $projbase/sedatives.txt
echo "s?<filebase>?$P2?g" >> $projbase/sedatives.txt
sed -f $projbase/sedatives.txt $projbase/MakeAnySHtoSQL.tmp > $projbase/MakeAnySHtoSQL
echo "DoSed1 complete."
# end DoSed1.sh
sed -f sedatives.tmp $pathbase/FL/SARA/86777/RawData/RefUSA/RefUSA-Downloads/Terr279/RegenSpecDB.sh > /media/ubuntu/Windows/Users/Bill/Territories/Procs-Dev/RegenSpecDB.sq
# pathbase block.
# 5/30/22.
if [ -z "$codebase" ];then
 codebase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$pathbase" ];then
 if [ ! -z "$congpath" ];then
  export pathbase=$folderbase/Territories
 else
  export pathbase=$folderbase/Territories
 fi
fi
# end pathbase block.
