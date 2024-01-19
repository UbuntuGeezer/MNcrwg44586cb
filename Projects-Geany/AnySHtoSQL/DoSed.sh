#!/bin/bash
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
# DoSed.sh - Run sed to convert <file>.sh > <file>.sq > <file>.sql
#	6/6/22.	wmk.
#
# Usage. bash DoSed1.sh <filepath> <filebase>
#
#	<filepath> = path to file to convert
#	<filebase> = base name of file to convert
#
# Exit.	<filepath>/<filebase>.sh > .sq > .sql.
#
# Modification History.
# ----------------------
# 5/31/22.	wmk.	*pathbase* support.
# 6/6/22.	wmk.	P1 P2 check added.
# Legacy mods.
# 12/2/21.	wmk.	original code.
# 12/26/21.	wmk.	folderbase fixed for multihost.
#
P1=$1		# <filepath>
P2=$2		# <filebase>
if [ -z "$P1" ] || [ -z "$P2" ];then
 echo "DoSed <shfilepath> <filebase> missing parameter(s) - abandoned."
 exit 1
fi
if [ -z "$folderbase" ];then
 if [ "$USER" = "ubuntu" ]; then
  export folderbase="$folderbase"
 else 
  export folderbase=$HOME
 fi
fi
if [ -z "$codebase" ];then
 codebase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories
fi
if [ -z "$system_log" ]; then
 system_log=$folderbase"/ubuntu/SystemLog.txt"
fi
#
#
projpath=$codebase/Projects-Geany/AnySHtoSQL
echo "s?<filepath>?$P1?g" > $projpath/sedatives.txt
echo "s?<filebase>?$P2?g" >> $projpath/sedatives.txt
sed -f $projpath/sedatives.txt  $projpath/MakeAnySHtoSQL.tmp >  $projpath/MakeAnySHtoSQL
echo "DoSed complete."
# end DoSed.sh
