#!/bin/bash
echo " ** FixMakeEndifs.sh out-of-date **";exit 1
echo " ** FixMakeEndifs.sh out-of-date **";exit 1
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
# FixMakeEndifs.sh - delete lines with (#) folderbase comment.
#	5/28/22.	wmk.
#
# Modification History.
# ---------------------
# 5/10/22.	wmk.	original code; adapted from FixMake.
# 5/15/22.  wmk.   (automated) pathbase corrected to FL/SARA/86777.
# 5/28/22.  wmk.   (automated) TX/HDLG/9999 -> FL/SARA/86777.
#
P1=$1
P2=$2
if [ -z "$P1" ] || [ -z "$P2" ];then
 echo "FixMakeEndifs <makepath> <makefile> missing parameter(s) - abandoned."
 exit 1
fi
if ! test -f $P1/$P2;then
 echo "FixMakeEndifs file '$P1/$P2' does not exist - abandoned."
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
  ~/sysprocs/LOGMSG "  FixMakeEndifs - initiated from Make"
  echo "  FixMakeEndifs - initiated from Make"
else
  ~/sysprocs/LOGMSG "  FixMakeEndifs - initiated from Terminal"
  echo "  FixMakeEndifs - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
# proc body here.
# check file contents...
len=${#P2}
len3=$((len-4))
filext=${P2:len3:4}
if [ "$filext" != ".bak" ];then
grep -e "*# folderbase*" $P1/$P2 > $TEMP_PATH/scratchfile
if [ $? -eq 0 ];then
 echo "FixMakeEndifs $P2 already fixed - skipped."
 ~/sysprocs/LOGMSG "  FixMakeEndifs $P2 already fixed - skipped."
 exit 0
fi
grep -e "# folderbase" $P1/$P2 > $TEMP_PATH/scratchfile
if [ $? -ne 0 ];then
 echo "FixMakeEndifs $P1/$P2 no '# folderbase' statement - skipping."
 ~/sysprocs/LOGMSG "  FixMakeEndifs $P1/$P2 no '# folderbase' statements - skipping."
 exit 1
fi
 projpath=$codebase/Projects-Geany/FixMakes
 cp -p $P1/$P2 $P1/$P2.bak
 sed -f $projpath/sedfixEndif.txt $P1/$P2 > $TEMP_PATH/$P2
 cp -p $TEMP_PATH/$P2 $P1/$P2
#sed -f $projpath/sedfixMake.txt -i $P1/$P2
# rm $TEMP_PATH/scratch*.txt
else
 echo " MakeFixEndifs $P2 - skipping..."
fi
#end proc body.
~/sysprocs/LOGMSG "  FixMakeEndifs $P1/$P2 complete."
echo "  FixMakeEndifs $P1/$P2 complete."
# end FixMakeEndifsEndifs.sh

