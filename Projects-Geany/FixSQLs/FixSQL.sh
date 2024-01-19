#!/bin/bash
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
# FixSQL.sh - fix .sql with *pathbase* support.
#	5/30/22.	wmk.
#
# Usage.  bash FixSQL <sqlpath> <sqlfile> [<extension>]
#
#	<sqlpath> = path to <sqlfile>
#	<sqlfile> = .sql filename (no extension, .sql assumed)
#	<extension> = (optional) filename extension 'sql' or 'psq'
#					'sql' default
#
# Modification History.
# ---------------------
# 5/30/22.	wmk.	modified to use both sedfixSQL, sedfixSQL1.
# Legacy mods.
# 5/7/22.	wmk.	original code; adapted from FixMake.sh
# 5/8/22.	wmk.	check for '(automated) *pathbase* for already fixed.
# 5/9/22.	wmk.	add check for /media/ubuntu before abandoning.
# 5/28/22.	wmk.	parameter error message clarified.
# 5/30/22.	wmk.	modified to use sedfixSQL1 and 5/30/22.
P1=$1
P2=$2
P3=${3,,}
if [ -z "$P1" ] || [ -z "$P2" ];then
 echo "FixSQL <sqlpath> <sqlfile> [.sql | .psq] missing parameter(s) - abandoned."
 exit 1
fi
if [ -z "$P3" ];then
  P3=sql
fi
if [ "$P3" == "sql" ];then
  FN=$P2.$P3
elif [ "$P3" == "psq" ];then
  FN=$P2.$P3
else
  echo "FixSQL unrecognized <extension> $P3 - abandoned."
  exit 1
fi
if ! test -f $P1/$FN;then
 echo "FixSQL file '$P1/$FN' does not exist - abandoned."
 exit 1
fi
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ]; then
  folderbase=/media/ubuntu/Windows/Users/Bill
 else
  folderbase=$HOME
 fi
fi
if [ -z "$codebase" ];then
 codebase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories
fi
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "  FixSQL '$P3' - initiated from Make"
  echo "  FixSQL '$P3' - initiated from Make"
else
  ~/sysprocs/LOGMSG "  FixSQL '$P3' - initiated from Terminal"
  echo "  FixSQL '$P3'- initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
# proc body here.
grep -e "folderbase" $P1/$FN > $TEMP_PATH/scratchfile
code1=$?
grep -e "/media/ubuntu/" $P1/$FN > $TEMP_PATH/scratchfile
code2=$?
grep -e "(automated) *pathbase" $P1/$FN > $TEMP_PATH/scratchfile
code3=$?
grep -e "VeniceNTerritory.db" $P1/$FN > $TEMP_PATH/scratchfile
code4=$?
if [ $code1 -ne 0 ] && [ $code2 -ne 0 ] && [ $code3 -ne 0 ] && [ $code4 -ne 0 ];then
 echo "FixSQL $P1/$FN no old references to fix - abandoned."
 ~/sysprocs/LOGMSG "  FixSQL $P1/$FN no old references to fix - abandoned."
 exit 1
fi
cp -p $P1/$FN $P1/$FN.bak
# check file contents...
projpath=$codebase/Projects-Geany/FixSQLs
grep -e "(automated) *pathbase" $P1/$FN > $TEMP_PATH/scratchfile
if [ $? -eq 0 ];then
 echo "FixSQL $FN *pathbase* already fixed - skipping."
 ~/sysprocs/LOGMSG "  FixSQL $FN *pathbase* already fixed - skipping."
else
 echo "  adding *pathbase*..."
 sed -f $projpath/sedfixSQL.txt $P1/$FN > $TEMP_PATH/buffer.txt
 cp -pv $TEMP_PATH/buffer.txt $P1/$FN
fi
grep -e "(automated) VeniceNTerritory" $P1/$FN > $TEMP_PATH/scratchfile
if [ $? -eq 0 ];then
 echo "FixSQL $FN VeniceNTerritory already fixed - abandoned."
 ~/sysprocs/LOGMSG "  FixSQL $FN VeniceNTerritory already fixed - skipping."
else
 echo "  fixing VeniceNTerritory to Terr86777..."
 sed -f $projpath/sedfixSQL1.txt $P1/$FN > $TEMP_PATH/buffer.txt
 cp -pv $TEMP_PATH/buffer.txt $P1/$FN
fi
#sed -f $projpath/sedfixMake.txt -i $P1/$FN
# rm $TEMP_PATH/scratch*.txt
#end proc body.
~/sysprocs/LOGMSG "  FixSQL $P1/$FN complete."
echo "  FixSQL $P1/$FN complete."
# end FixSQL.sh
