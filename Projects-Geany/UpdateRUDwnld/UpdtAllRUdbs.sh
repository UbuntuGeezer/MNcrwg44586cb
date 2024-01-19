#!/bin/bash
echo " ** UpdtAllRUdbs.sh out-of-date **";exit 1
echo " ** UpdtAllRUdbs.sh out-of-date **";exit 1
# UpdtAllRUdbs.sh = Update RU downloads from list.
# 	3/28/23.	wmk.
#
# Usage.	bash UpdtAllRUdbs.sh
#
# Entry. ($)folderbase/Projects-Geany/FixAnyRU project defined.
#        ./UpdateRUDwnld/TIDList.txt has list of territories to run
#		 	UpdateRUDwnld makefile against.
#
# Modification History.
# ---------------------
# 2/26/23.	wmk.	rewrite; adapted from UpdateAllSpecRUdbs.
# 3/12/23.	wmk.	bug fix where *codebase not used to switch to project path.
# 3/28/23.	wmk.	parameters eliminated; jumpto references removed.
# Legacy mods.
# 9/23/22.  wmk.    (automated) CB *codebase env var support.
# 10/4/22.  wmk.    (automated) fix *pathbase for CB system.
# Legacy mods.
# 12/6/21.	wmk.	original code; adapted from UpdtAllRUDwnld.
# 4/25/22.	wmk.	generalized for FL/SARA.86777;*pathbase* support.
# Legacy mods.
# 6/6/21.	wmk.	bug fix; equality check ($)HOME, TEMP_PATH
#					ensured set.
# 6/27/21.	wmk.	multihost code improved; superfluous "s removed.
#
# Notes. If the user wants to include a comment in the TIDList.txt file, (i.e. line
# begins with '#'), the entire comment will be read as one word by "read", since 
# IFS is set to "&" by this script. This implies that none of the "ignore" specs,
# nor comments, contain the "&" character.
#
# This script uses the directory $TEMP_FILES to store temporary files. At the end of
# the script, all temporary files in $TEMP_FILES are removed. Temporary files are
# useful for writing information that would normally be output to the terminal, but
# that is considered irrelevant. If the bash scripts are set up so that if they terminate
# abnormally and they do not remove the temporary files, these can prove useful for
# debugging where the script failed.
#P1=${1^^}
#P2=${2^^}
#P3=$3
#if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ];then
# echo "UpdateAllSpecRUdbs <state> <county> <congno> missing parameter(s) - abandoned."
# exit 1
#fi
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
 export pathbase=$folderbase/Territories/FL/SARA/86777
fi
if [ -z "$congterr" ];then
 export congterr=FLSARA86777
fi
#if [ "$P1$P2$P3" != "$congterr" ];then
# echo "*congterr* = :$congterr"
# echo "** $P1$P2$P3 mismatch with *congterr* - UpdateAllSpecRUdbs abandoned **"
# exit 1
#fi
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "   UpdtAllRUdbs initiated from Make."
else
  ~/sysprocs/LOGMSG "   UpdtAllRUdbs initiated from Terminal."
fi
TEMP_PATH=$folderbase/temp
#
#procbodyhere
pushd ./ >> $TEMP_PATH/bitbucket.txt
cd $codebase/Projects-Geany/UpdateRUDwnld
MY_PROJ='Territories'
echo "  UpdtAllRUdbs beginning processing."

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
#  echo -e "  $firstchar\n is first char of line." >> $TEMP_PATH/scratchfile
  #expr index $string $substring
  if [ "$firstchar" == "#" ]; then			# skip comment
   echo $REPLY >> $TEMP_PATH/scratchfile
  elif [ $len -eq 0 ];then					# skip empty line
   echo "blank line" >> $TEMP_PATH/scratchfile
  elif [ "$firstchar" == "\$" ];then			# $ terminates list
   break
  else
   TID=${REPLY:0:len}
   bash ~/sysprocs/LOGMSG "  UpdateRUDwnld $TID initiated."
   ./DoSed.sh $TID
   make -f MakeUpdateRUDwnld
  fi     # end is comment line conditional

i=$((i+1))
done < $file
echo " $i TIDList.txt lines processed."
popd >> $TEMP_PATH/scratchfile
if [ $error_counter = 0 ]; then
  rm $TEMP_PATH/scratchfile
else
  echo "  $error_counter errors encountered - check $TEMP_PATH/scratchfile "
fi
# endprocbody
~/sysprocs/LOGMSG " UpdtAllRUdbs complete." >> $system_log
echo " 	UpdtAllRUdbs complete."
