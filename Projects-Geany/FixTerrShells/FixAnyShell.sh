#!/bin/bash
echo " ** FixAnyShell.sh out-of-date **";exit 1
echo " ** FixAnyShell.sh out-of-date **";exit 1
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
# FixAnyShell.sh - fix *.sh files with *pathbase* support.
# 5/28/22.    wmk.   (automated) pathbase corrected to TX/HDLG/99999.
#	5/15/22.	wmk.
#
# Usage.  bash FixAnyShell <basepath>
#
#	<basepath> = path to any folder containing subfolders
#
# Exit. all *.sh* files in <baspath> subfolders fixed.
#		 FL/SARA/86777 > TX/HDLG/99999
#		 FLSARA86777 > FLSARA86777
#
# Modification History.
# ---------------------
# 5/15/22.    wmk.   original code; adapted from FixTerrShell.sh
# 5/15/22.    wmk.   (automated) pathbase corrected to FL/SARA/86777.
P1=$1
if [ -z "$P1" ];then
 echo "FixAnyShell <basepath> missing parameter(s) - abandoned."
 exit 1
fi
srcpath=$P1
if ! test -d $srcpath;then
 echo "FixAnyShell folder '$srcpath' does not exist - abandoned."
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
if [ -z "$congterr" ];then
 export congterr=FLSARA86777
fi
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "  FixAnyShell - initiated from Make"
  echo "  FixAnyShell - initiated from Make"
else
  ~/sysprocs/LOGMSG "  FixAnyShell - initiated from Terminal"
  echo "  FixAnyShell - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
srcpath=$P1
FS=*.sh
projpath=$codebase/Projects-Geany/FixTerrShells
geanypath=$codebase/Projects-Geany
#srcpath=$P2$subfolder (set above)
# proc body here.
cd $srcpath
echo $PWD
ls -rlh | mawk '/drw../{print $9}' > $TEMP_PATH/DirList.txt
#ls $FS > $TEMP_PATH/MakeList.txt
if [ $? -ne 0 ];then
 echo " FixTerrSQ No subfolders found in $srcpath.. skipping"
 exit 0
fi
#cat $TEMP_PATH/SQLList.txt
#exit 0
# check file contents...
file=$TEMP_PATH/DirList.txt
while read -e;do
 len=${#REPLY}
 dn=${REPLY:0:len}
 echo "processing $dn ..."
 $geanypath/FixShells/FixAllShells.sh $P1/$dn
done < $file
#end proc body.
~/sysprocs/LOGMSG "  FixAnyShell $P1/$FN complete."
echo "  FixAnyShell $P1 complete."
# end FixAnyfaShell.sh
