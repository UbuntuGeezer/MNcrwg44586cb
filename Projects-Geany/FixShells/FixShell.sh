#!/bin/bash
echo " ** FixShell.sh out-of-date **";exit 1
echo " ** FixShell.sh out-of-date **";exit 1
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
# FixShell.sh - fix .sh file with *pathbase* support.
#	5/30/22.	wmk.
#
# Modification History.
# ---------------------
# 5/15/22.	wmk.	original code; adapted from FixMake.sh
# 5/28/22.	wmk.	missing parameters message corrected; FL/SAR/86777.
# 5/30/22.	wmk.	TX > FL; *pathbase*; *thisproj* qualifier since
#			 .sh files can be invoked directly from elsewhere.
P1=$1
P2=$2
if [ -z "$P1" ] || [ -z "$P2" ];then
 echo "FixShell <shpath> <shfile> missing parameter(s) - abandoned."
 exit 1
fi
if [ "$P1" != "./" ];then
 len=${#P1}
 len1=$((len-1))
 lastchr=${P1:len1:1}
 if [ "$lastchr" == "/" ];then
  len1=$((len-1))
  srcpath=${P1:0:len1}
 else
  srcpath=$P1
 fi
else
 srcpath=.
fi
P1=$srcpath
#echo "P1 = : '$P1'"
if ! test -f $P1/$P2.sh;then
 echo "FixShell file '$P1/$P2.sh' does not exist - abandoned."
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
  ~/sysprocs/LOGMSG "  FixShell - initiated from Make"
  echo "  FixShell - initiated from Make"
else
  ~/sysprocs/LOGMSG "  FixShell - initiated from Terminal"
  echo "  FixShell - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
# proc body here.
# check file contents...
grep -e "5/30/22." $P1/$P2.sh > $TEMP_PATH/scratchfile
if [ $? -eq 0 ];then
 echo "FixShell $P2.sh already fixed - abandoned."
 ~/sysprocs/LOGMSG "  FixShell $P2.sh already fixed - abandoned."
 exit 0
fi
cp -p $P1/$P2.sh $P1/$P2.bak
grep -e "folderbase" $P1/$P2.sh > $TEMP_PATH/scratchfile
if [ $? -ne 0 ];then
 echo "FixShell $P1/$P2.sh missing *folderbase* statement - abandoned."
 ~/sysprocs/LOGMSG "  FixShell $P1/$P2.sh missing *folderbase* statement - abandoned."
 exit 1
fi
projpath=$codebase/Projects-Geany/FixShells
grep -e "TX/HDLG" $P1/$P2.sh > $TEMP_PATH/scratchfile
if [ $? -eq 0 ];then
 sed -i -f $projpath/sedfixShell1.txt $P1/$P2.sh
fi
sed -i -f $projpath/sedfixShell.txt $P1/$P2.sh
#grep -e "pathbase" $P1/$P2.sh > $TEMP_PATH/scratchfile
#if [ $? -ne 0 ];then
# echo "FixShell $P1/$P2.sh missing *pathbase* statement - abandoned."
# ~/sysprocs/LOGMSG "  FixShell $P1/$P2.sh missing *folderbase* statement - abandoned."
# exit 1
#fi
#
# if no *pathbase*= statement, add it.
grep -e "pathbase=$folderbase/Territories
if [ $? -ne 0 ];then
 mawk -f $projpath/awkfixShell1.txt $P1/$P2.sh > $TEMP_PATH/buffer.txt
#echo " review $TEMP_PATH/buffer.txt"
#exit 0
 cat $projpath/pathbaseblock.txt >> $TEMP_PATH/buffer.txt
 mawk -f $projpath/awkfixShell3.txt $P1/$P2.sh >> $TEMP_PATH/buffer.txt 
#echo " review $TEMP_PATH/buffer.txt"
#exit 0
 cp -pv $TEMP_PATH/buffer.txt  $P1/$P2.sh
fi
#sed -f $projpath/sedfixShell.txt -i $P1/$P2.sh
# rm $TEMP_PATH/scratch*.txt
#end proc body.
~/sysprocs/LOGMSG "  FixShell $P1/$P2.sh complete."
echo "  FixShell $P1/$P2.sh complete."
# end FixShell.sh
