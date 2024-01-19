#!/bin/bash
echo " ** FindRealBadSQLs.sh out-of-date **";exit 1
echo " ** FindRealBadSQLs.sh out-of-date **";exit 1
# FindRealBadSQLs.sh - Find makefiles still using cat for .sh makes.
# 2/2/23.	wmk.
#
# Usage. bash  FindBacMakes.sh  [terrstart terrend]
#
#	terrstart = (optional) starting territory ID for scan
#   terrend = (optional, mandatory if terrstart present) ending territory for scan
#
# Entry. *scpath = RawData/SCPA/SCPA-Downloads
#		 *rupath = RawData/RefUSA/RefUSA-Downloads
#
# Dependencies.
#
# Modification History.
# ---------------------
# 2/2/23.	wmk.	original shell (template)
#
# Notes. A makefile will be considered "real bad" if it contains either:
#	the sequence 'FROM.*NVenAll'
#	OR "ATTACH.*VeniceNTerritory"
#	OR "folderbase)/Territories"
#
# set parameters P1..Pn here..
#
P1=$1
P2=$2
if [ ! -z "$P1" ];then
 if [ -z "$P2" ];then
  echo "  FindRealBadSQLs [terrstart] [terrend] missing parameter(s) - abandoned."
  exit 1
 fi
 if [ $P2 -lt $P1 ];then
  echo "  FindRealBadSQLs [terrstart] [terrend] terrend < terrstart - abandoned."
  exit 1
 fi
else
 P1=101
 P2=900
fi
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ]; then
  folderbase=/media/ubuntu/Windows/Users/Bill
 else
  folderbase=$HOME
 fi
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories/FL/SARA/86777
fi
if [ -z "$codebase" ];then
 export pathbase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "  FindRealBadSQLs - initiated from Make"
  echo "  FindRealBadSQLs - initiated from Make"
else
  ~/sysprocs/LOGMSG "  FindRealBadSQLs - initiated from Terminal"
  echo "  FindRealBadSQLs - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 . ~/GitHub/TerritoriesCB/Procs-Dev/SetToday.sh
#TODAY=2022-04-22
fi
#procbodyhere
pushd ./ > $TEMP_PATH/scratchfile
cd $pathbase/$scpath
if [ $P1 -eq 101 ] && [ $P2 -eq 900 ];then
 echo "  Scanning $scpath..."
 grep -rle "FROM.*NVenAll" --include "*.sql"
 grep -rle "ATTACH.*VeniceNTerritory"  --include "*.sql"
 grep -rle "folderbase/Territories"  --include "*.sql"
 cd $pathbase/$rupath
 echo "  Scanning $rupath.."
 grep -rle "FROM.*NVenAll" --include "*.sql"
 grep -rle "ATTACH.*VeniceNTerritory"  --include "*.sql"
 grep -rle "folderbase/Territories"  --include "*.sql"
else	# process range P1 .. P2
 seq $P1 $P2 > $TEMP_PATH/terrrange.txt
 file=$TEMP_PATH/terrrange.txt
 while read -e;do
  if test -d $pathbase/$scpath/Terr$REPLY;then
   echo "Scanning $scpath/Terr$REPLY..." 
   cd $pathbase/$scpath/Terr$REPLY
   grep -rle "FROM.*NVenAll" --include "*.sql"
   grep -rle "ATTACH.*VeniceNTerritory"  --include "*.sql"
   grep -rle "folderbase/Territories"  --include "*.sql"
  fi
  if test -d $pathbase/$rupath/Terr$REPLY;then 
   echo "Scanning $rupath/Terr$REPLY..." 
   cd $pathbase/$rupath/Terr$REPLY
   grep -rle "FROM.*NVenAll" --include "*.sql"
   grep -rle "ATTACH.*VeniceNTerritory"  --include "*.sql"
   grep -rle "folderbase/Territories"  --include "*.sql"
  fi
 done < $file
fi
popd > $TEMP_PATH/scratchfile
#endprocbody
echo "  FindRealBadSQLs complete."
~/sysprocs/LOGMSG "  FindRealBadSQLs complete."
# end FindBacMakes.sh
