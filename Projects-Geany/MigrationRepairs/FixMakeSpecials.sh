#!/bin/bash
echo " ** FixMakeSpecials.sh out-of-date **";exit 1
echo " ** FixMakeSpecials.sh out-of-date **";exit 1
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
# 10/4/22.    wmk.   (automated) fix *pathbase for CB system.
# FixMakeSpecials.sh - Fix MakeSpecials in territory.
# 9/21/22.	wmk.
#
# Modification History.
# ---------------------
# 6/3/22.	wmk.	original code.
# 9/21/22.	wmk.	modified for Chromebook.
#
P1=$1
P2=$2
if [ -z "$P1" ] || [ -z "$P2" ];then
 echo "FixMakeSpecials  <rawpath> <terrid> missing parameter(s) - abandoned."
 exit 1
fi
# do not process if P2 in range 500 - 700; business & letter
if [ 1 -eq 0 ];then
 if [ $P2 -ge 500 ] && [ $P2 -le 699 ];then
  echo "  FixMakeSpecials territory $P2 is letter or business - skipped."
  exit 0
 fi
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
  ~/sysprocs/LOGMSG "  FixMakeSpecials - initiated from Make"
  echo "  FixMakeSpecials - initiated from Make"
else
  ~/sysprocs/LOGMSG "  FixMakeSpecials - initiated from Terminal"
  echo "  FixMakeSpecials - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#beginprocbody
projpath=$codebase/Projects-Geany/MigrationRepairs
RUpath=$P1/Terr$P2
if ! test -f $RUpath/MakeSpecials;then
 echo "  Terr$P2 no MakeSpecials.. skipped."
 exit 0
fi
if [ 1 -eq 0 ];then
 grep -e "automated) restore path vars" $RUpath/MakeSpecials
 if [ $? -eq 0 ];then
  echo "$RUPATH/MakeSpecials already fixed - skipped."
  exit 0
 fi
fi
cp -f $projpath/awkfixMakeNonMHP.txt  $projpath/sedfixMakeNonMHP.txt 
sed -n '/# MakeSpecials/,/.ONESHELL/p' $RUpath/MakeSpecials > $TEMP_PATH/buffer1.txt
sed -n '/based on MHP/,/junkjunkjunk/p' $RUpath/MakeSpecials > $TEMP_PATH/buffer2.txt
cp -p $RUpath/MakeSpecials $RUpath/MakeSpecials.bak
cat $TEMP_PATH/buffer1.txt $projpath/sedfixMakeNonMHP.txt \
 $TEMP_PATH/buffer2.txt > $RUpath/MakeSpecials
sed -i -f sedadddate.txt $RUpath/MakeSpecials
#endprocbody
echo "  FixMakeSpecials $P1 $P2 complete."
~/sysprocs/LOGMSG "  FixMakeSpecials $P1 $P2 complete."
# end FixMakeSpecials

