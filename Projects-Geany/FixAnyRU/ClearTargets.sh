#!/bin/bash
echo " ** ClearTargets.sh out-of-date **";exit 1
echo " ** ClearTargets.sh out-of-date **";exit 1
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
# ClearTargets - Clear targets for project to force rebuild.
#	4/25/22.	wmk.
#
# Usage. bash ClearTargets.sh <terrid> <state> <county> <congno>
#
# Modification History.
# ---------------------
# 4/25/22.	wmk.	modified for general use with *pathbase* env var.
# Legacy mods.
# 9/19/21.	wmk.	original code.
P1=$1
TID=$1
P2=${2^^}
P3=${3^^}
P4=$4
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ] || [ -z "$P4" ];then
 echo "ClearTargets <terrid> <state> <county> <congno> missing parameter(s) - abandoned."
 exit 1
fi
if [ -z "$folderbase" ];then
 if [ "$USER" = "ubuntu" ]; then
  export folderbase=/media/ubuntu/Windows/Users/Bill
 else 
  export folderbase=$HOME
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
if [ "$P2$P3$P4" != "$congterr" ];then
 echo "*congterr* = :$congterr"
 echo "** $P2$P3$P4 mismatch with *congterr* - FlashBacks abandoned **"
 exit 1
fi
P1=${P1,,}
echo "  ClearTargets $P1 initiated."
dirbase=Terr
fname=Fix
fnend=RU
cd $codebase/Projects-Geany/FixAnyRU
MY_PROJ='Territories'
echo "  ClearTargets beginning processing."
TEMP_PATH=$HOME/temp
case $P1 in
"tidlist")
 error_counter=0		# set error counter to 0
 IFS="&"			# set & as the word delimiter for read.
 file=TIDList.txt
 i=0
 while read -e; do
  #reading each line
  echo -e " processing $REPLY " >> $TEMP_PATH/scratchfile
  len=${#REPLY}
  len1=$((len-1))
  firstchar=${REPLY:0:1}
#  echo -e "  $firstchar\n is first char of line." >> $HOME/temp/scratchfile
  #expr index $string $substring
  if [ "$firstchar" = "#" ]; then			# skip comment
   echo $REPLY >> $HOME/temp/scratchfile
  else
   TID=${REPLY:0:len}
   targpath=$pathbase/RawData/RefUSA/RefUSA-Downloads/$dirbase$TID
   echo "$targpath/$fname$TID$fnend.sh"
   echo "$targpath/$fname$TID$fnend.sq"
   if test -f $targpath/$fname$TID$fnend.sh;then rm $targpath/$fname$TID$fnend.sh;fi
   if test -f $targpath/$fname$TID$fnend.sq;then rm $targpath/$fname$TID$fnend.sq;fi
   bash ~/sysprocs/LOGMSG "  ClearTargets $TID initiated."
  fi     # end is comment line conditional
 i=$((i+1))
 done < $file
 echo " $i TIDList.txt lines processed."
 if [ $error_counter = 0 ]; then
   rm $TEMP_PATH/scratchfile
 else
   echo "  $error_counter errors encountered - check $TEMP_PATH/scratchfile "
 fi;;
*)
 targpath=$pathbase/RawData/RefUSA/RefUSA-Downloads/$dirbase$TID
 echo "$targpath/$fname$TID$fnend.sh"
 echo "$targpath/$fname$TID$fnend.sq"
 if test -f $targpath/$fname$TID$fnend.sh;then rm $targpath/$fname$TID$fnend.sh;fi
 if test -f $targpath/$fname$TID$fnend.sq;then rm $targpath/$fname$TID$fnend.sq;fi;;
esac
~/sysprocs/LOGMSG "  ClearTargets complete."
echo "  ClearTargets complete."
# end ClearTargets.sh
