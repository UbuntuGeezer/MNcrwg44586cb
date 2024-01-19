#!/bin/bash
echo " ** FixMakeSpecials1.sh out-of-date **";exit 1
echo " ** FixMakeSpecials1.sh out-of-date **";exit 1
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
# 10/4/22.    wmk.   (automated) fix *pathbase for CB system.
# FixMakeSpecials1.sh - Fix MHP MakeSpecials1
# 9/2122.	wmk.
#
# Usage. bash FixMakeSpecials1 <basepath> <terrid>
#
#	<basepath> = RU or SC path
#	<terrid> = territory ID for SPECIAL territory.
#
# Modification History.
# ---------------------
# 6/4/22.	wmk.	original code.
# 6/6/22.	wmk.	bug fix in *cp* making .bak
# 9/21/22	wmk.	modified for Chromebook.
P1=$1
P2=$2
if [ -z "$P1" ] || [ -z "$P2" ];then
 echo "FixMakeSpecials1  <rawpath> <terrid> missing parameter(s) - abandoned."
 exit 1
fi
# do not process if P2 in range 500 - 700; business & letter
if [ 1 -eq 0 ];then
 if [ $P2 -ge 500 ] && [ $P2 -le 699 ];then
  echo "  FixMakeSpecials1 territory $P2 is letter or business - skipped."
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
  ~/sysprocs/LOGMSG "  FixMakeSpecials1 - initiated from Make"
  echo "  FixMakeSpecials1 - initiated from Make"
else
  ~/sysprocs/LOGMSG "  FixMakeSpecials1 - initiated from Terminal"
  echo "  FixMakeSpecials1 - initiated from Terminal"
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
 grep -e "automated) fix basepath" $RUpath/MakeSpecials
 if [ $? -eq 0 ];then
  echo "$RUPATH/MakeSpecials already fixed - skipped."
  exit 0
 fi
fi
cp -p $RUpath/MakeSpecials $RUpath/MakeSpecials.bak
sed -i -f $projpath/sedfixMakeNonMHP1.txt $RUpath/MakeSpecials
sed -i 's?(pathbase)/Procs-Dev?(codebase)/Procs-Dev?g' $RUpath/MakeSpecials
sed -i 's?(pathbase)/Projects-Geany?(codebase)/Projects-Geany?g' $RUpath/MakeSpecials
mawk -f $projpath/awkaddforcebuild.txt $RUpath/MakeSpecials > $TEMP_PATH/buffer4.txt
cp -pv $TEMP_PATH/buffer4.txt $RUpath/MakeSpecials
mawk -f $projpath/awkaddcodebase.txt $RUpath/MakeSpecials > $TEMP_PATH/buffer5.txt
cp -pv $TEMP_PATH/buffer5.txt $RUpath/MakeSpecials
mawk -f $projpath/awkfixpathbase.txt $RUpath/MakeSpecials > $TEMP_PATH/buffer6.txt
cp -pv $TEMP_PATH/buffer6.txt $RUpath/MakeSpecials
#endprocbody
echo "  FixMakeSpecials1 $P1 $P2 complete."
~/sysprocs/LOGMSG "  FixMakeSpecials1 $P1 $P2 complete."
# end FixMakeSpecials1

