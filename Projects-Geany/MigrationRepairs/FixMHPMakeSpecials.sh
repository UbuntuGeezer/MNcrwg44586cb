#!/bin/bash
echo " ** FixMHPMakeSpecials.sh out-of-date **";exit 1
echo " ** FixMHPMakeSpecials.sh out-of-date **";exit 1
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
# 10/4/22.    wmk.   (automated) fix *pathbase for CB system.
# FixMHPMakeSpecials.sh - Fix MHP MakeSpecials makefiles.
#	9/21/22.
#
# Modification History.
# ---------------------
# 6/3/22.	wmk.	original code.
# 9/21/22.	wmk.	modified for Chromebook.
P1=$1
P2=$2
if [ -z "$P1" ] || [ -z "$P2" ];then
 echo "FixMHPMakeSpecials <mhpname> <terrid> missing parameter(s) - abandoned."
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
 export pathbase=$folderbase/Territories/FL/SARA/86777
fi
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "  FixMHPMakeSpecials - initiated from Make"
  echo "  FixMHPMakeSpecials - initiated from Make"
else
  ~/sysprocs/LOGMSG "  FixMHPMakeSpecials - initiated from Terminal"
  echo "  FixMHPMakeSpecials - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#beginprocbpdy
projpath=$codebase/Projects-Geany/MigrationRepairs
RUpath=$pathbase/RawData/RefUSA/RefUSA-Downloads/Terr$P2
grep -e "automated) restore path vars" $RUpath/MakeSpecials
if [ $? -eq 0 ];then
 echo "$RUPATH/MakeSpecials already fixed - skipped."
 exit 0
fi
sed  "s?<db-name>?$P1?g" $projpath/awkfixMakeMHP.txt > $projpath/sedfixMakeMHP.txt 
sed -n '/# MakeSpecials/,/.ONESHELL/p' $RUpath/MakeSpecials > $TEMP_PATH/buffer1.txt
sed -n '/based on MHP/,/junkjunkjunk/p' $RUpath/MakeSpecials > $TEMP_PATH/buffer2.txt
cp -p $RUpath/MakeSpecials $RUpath/MakeSpecials.bak
cat $TEMP_PATH/buffer1.txt $projpath/sedfixMakeMHP.txt \
 $TEMP_PATH/buffer2.txt > $RUpath/MakeSpecials
sed -i -f sedadddate.txt $RUpath/MakeSpecials
#endprocbody
echo "  FixMHPMakeSpecials $P1 $P2 complete."
~/sysprocs/LOGMSG "  FixMHPMakeSpecials $P1 $P2 complete."
# end FixMHPMakeSpecials
