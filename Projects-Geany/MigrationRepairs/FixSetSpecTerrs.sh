#!/bin/bash
echo " ** FixSetSpecTerrs.sh out-of-date **";exit 1
echo " ** FixSetSpecTerrs.sh out-of-date **";exit 1
# FixSetSpecTerrs.sh - Fix SetSpecTerrs in territory.
# 12/16/22.	wmk.
#
# Modification History.
# ---------------------
# 12/16/22.	wmk.	original code; adapted from FixSyncTerrs.sh.
# Legacy mods.
# 6/3/22.	wmk.	original code.
# 9/21/22.	wmk.	modified for Chromebook.
# 9/23/22.  wmk.    (automated) CB *codebase env var support.
# 10/4/22.  wmk.    (automated) fix *pathbase for CB system.
#
P1=$1
P2=$2
if [ -z "$P1" ] || [ -z "$P2" ];then
 echo "FixSetSpecTerrs  <rawpath> <terrid> missing parameter(s) - abandoned."
 exit 1
fi
# do not process if P2 in range 500 - 700; business & letter
if [ $P2 -ge 500 ] && [ $P2 -le 699 ];then
 echo "  FixSetSpecTerrs territory $P2 is letter or business - skipped."
 exit 0
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
 export pathbase=$folderbase/Territories/FL/SARA/86777
fi
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "  FixSetSpecTerrs - initiated from Make"
  echo "  FixSetSpecTerrs - initiated from Make"
else
  ~/sysprocs/LOGMSG "  FixSetSpecTerrs - initiated from Terminal"
  echo "  FixSetSpecTerrs - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#beginprocbpdy
projpath=$codebase/Projects-Geany/MigrationRepairs
RUpath=$P1/Terr$P2
if ! test -f $RUpath/SetSpecTerrs;then
 echo "  Terr$P2 no SetSpecTerrs.. skipped."
 exit 0
fi
grep -e "automated) restore path vars" $RUpath/SetSpecTerrs
if [ $? -eq 0 ];then
 echo "$RUPATH/SetSpecTerrs already fixed - skipped."
 exit 0
fi
cp -f $projpath/awkfixMakeNonMHP.txt  $projpath/sedfixMakeNonMHP.txt 
sed -n '/# SetSpecTerrs/,/.ONESHELL/p' $RUpath/SetSpecTerrs > $TEMP_PATH/buffer1.txt
sed -n '/based on MHP/,/junkjunkjunk/p' $RUpath/SetSpecTerrs > $TEMP_PATH/buffer2.txt
cp -p $RUpath/SetSpecTerrs $RUpath/SetSpecTerrs.bak
cat $TEMP_PATH/buffer1.txt $projpath/sedfixMakeNonMHP.txt \
 $TEMP_PATH/buffer2.txt > $RUpath/SetSpecTerrs
sed -i -f sedadddate.txt $RUpath/SetSpecTerrs
#endprocbody
echo "  FixSetSpecTerrs $P1 $P2 complete."
~/sysprocs/LOGMSG "  FixSetSpecTerrs $P1 $P2 complete."
# end FixSetSpecTerrs

