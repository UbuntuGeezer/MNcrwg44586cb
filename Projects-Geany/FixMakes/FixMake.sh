#!/bin/bash
echo " ** FixMake.sh out-of-date **";exit 1
echo " ** FixMake.sh out-of-date **";exit 1
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
# FixMake.sh - fix Makefile with *pathbase* support.
#	5/10/22.	wmk.
#
# Modification History.
# ---------------------
# 5/28/22.    wmk.   (automated) TX/HDLG/9999 -> FL/SARA/86777.
# Legacy mods.
# 5/4/22.	wmk.	original code.
# 5/5/22.	wmk.	addONESHELL added.
# 5/6/22.	wmk.	final *mawk* corrected to use TEMP_PATH/P2 file;
#			 initial *mawk* corrected to start at '# Make'.
# 5/10/22.	wmk.	eliminate *sed* with sedfixMake1, it hoses every endif.
# 5/15/22.    wmk.   (automated) pathbase corrected to FL/SARA/86777.
P1=$1
P2=$2
if [ -z "$P1" ] || [ -z "$P2" ];then
 echo "FixMake <makepath> <makefile> missing parameter(s) - abandoned."
 exit 1
fi
if ! test -f $P1/$P2;then
 echo "FixMake file '$P1/$P2' does not exist - abandoned."
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
  ~/sysprocs/LOGMSG "  FixMake - initiated from Make"
  echo "  FixMake - initiated from Make"
else
  ~/sysprocs/LOGMSG "  FixMake - initiated from Terminal"
  echo "  FixMake - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
# proc body here.
# check file contents...
grep -e "5/4/22." $P1/$P2 > $TEMP_PATH/scratchfile
if [ $? -eq 0 ];then
 echo "FixMake $P2 already fixed - abandoned."
 ~/sysprocs/LOGMSG "  FixMake $P2 already fixed - abandoned."
 exit 0
fi
grep -e "folderbase" $P1/$P2 > $TEMP_PATH/scratchfile
if [ $? -ne 0 ];then
 echo "FixMake $P1/$P2 missing *folderbase* statement - abandoned."
 ~/sysprocs/LOGMSG "  FixMake $P1/$P2 missing *folderbase* statement - abandoned."
 exit 1
fi
projpath=$codebase/Projects-Geany/FixMakes
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
sed -f $projpath/sedfixMake.txt $P1/$P2 > $TEMP_PATH/$P2
mawk '/# Make/,/USER/{print}' $TEMP_PATH/$P2 > $TEMP_PATH/scratch1.txt
sed -i "/ifndef folderbase/ d;/USER/ d" $TEMP_PATH/scratch1.txt
 mawk '/.PHONY/,/zzzzzz/{print}' $TEMP_PATH/$P2  > $TEMP_PATH/scratch3.txt
 cat $TEMP_PATH/scratch1.txt $projpath/folderbase.if $projpath/pathbase.if \
  $projpath/AWK.if $TEMP_PATH/scratch3.txt > $TEMP_PATH/scratch2.txt
 cp -p $TEMP_PATH/scratch2.txt $P1/$P2
#sed -f $projpath/sedfixMake.txt -i $P1/$P2
# rm $TEMP_PATH/scratch*.txt
#end proc body.
~/sysprocs/LOGMSG "  FixMake $P1/$P2 complete."
echo "  FixMake $P1/$P2 complete."
# end FixMake.sh
