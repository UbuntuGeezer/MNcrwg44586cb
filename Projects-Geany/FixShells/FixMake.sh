#!/bin/bash
echo " ** FixMake.sh out-of-date **";exit 1
echo " ** FixMake.sh out-of-date **";exit 1
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
# FixMake.sh - fix .sh file with *pathbase* support.
# 5/15/22.    wmk.   (automated) pathbase corrected to TX/HDLG/99999.
#	5/10/22.	wmk.
#
# Modification History.
# ---------------------
# 5/10/22.	wmk.	original code
P1=$1
P2=$2
if [ -z "$P1" ] || [ -z "$P2" ];then
 echo "FixShell <makepath> <makefile> missing parameter(s) - abandoned."
 exit 1
fi
if ! test -f $P1/$P2;then
 echo "FixShell file '$P1/$P2' does not exist - abandoned."
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
if [ -z "$congterr" [;then
 export congterr=TXHDLG99999
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
grep -e "5/4/22." $P1/$P2 > $TEMP_PATH/scratchfile
if [ $? -eq 0 ];then
 echo "FixShell $P2 already fixed - abandoned."
 ~/sysprocs/LOGMSG "  FixShell $P2 already fixed - abandoned."
 exit 0
fi
grep -e "folderbase" $P1/$P2 > $TEMP_PATH/scratchfile
if [ $? -ne 0 ];then
 echo "FixShell $P1/$P2 missing *folderbase* statement - abandoned."
 ~/sysprocs/LOGMSG "  FixShell $P1/$P2 missing *folderbase* statement - abandoned."
 exit 1
fi
projpath=$codebase/Projects-Geany/FixShells
cp -p $P1/$P2 $P1/$P2.back
grep -e ".PHONY" $P1/$P2 > $TEMP_PATH/scratchfile
if [ $? -ne 0 ];then
 echo "Adding .PHONY to Make source..."
 sed -f $projpath/addPHONY.txt -i $P1/$P2
fi
grep -e ".ONESHELL" $P1/$P2 > $TEMP_PATH/scratchfile
if [ $? -ne 0 ];then
 echo "Adding .ONESHELL to Make source..."
 sed -f $projpath/addONESHELL.txt -i $P1/$P2
fi
sed -f $projpath/sedFixShell.txt $P1/$P2 > $TEMP_PATH/$P2
mawk '/# Make/,/USER/{print}' $TEMP_PATH/$P2 > $TEMP_PATH/scratch1.txt
sed -i "/ifndef folderbase/ d;/USER/ d" $TEMP_PATH/scratch1.txt
 mawk '/.PHONY/,/zzzzzz/{print}' $TEMP_PATH/$P2  > $TEMP_PATH/scratch3.txt
 cat $TEMP_PATH/scratch1.txt $projpath/folderbase.if $projpath/pathbase.if \
  $projpath/AWK.if $TEMP_PATH/scratch3.txt > $TEMP_PATH/scratch2.txt
 cp -p $TEMP_PATH/scratch2.txt $P1/$P2
#sed -f $projpath/sedFixShell.txt -i $P1/$P2
# rm $TEMP_PATH/scratch*.txt
#end proc body.
~/sysprocs/LOGMSG "  FixShell $P1/$P2 complete."
echo "  FixShell $P1/$P2 complete."
# end FixShell.sh
