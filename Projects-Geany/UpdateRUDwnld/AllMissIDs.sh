#!/bin/bash
echo " ** AllMissIDs.sh out-of-date **";exit 1
echo " ** AllMissIDs.sh out-of-date **";exit 1
# AllMissIDs.sh = Update RU downloads from list.
# 	4/1/23.	wmk.
#
# Usage.	bash AllMissIDs.sh [<tidlist>]
#
#	<tidlist> = (optional) list of territories to process.
#				TIDList.txt default
#
# Entry. ($)folderbase/Projects-Geany/FixAnyRU project defined.
#        ./UpdateRUDwnld/TIDList.txt has list of territories to run
#		 	UpdateRUDwnld makefile against.
#
# Modification History.
# ---------------------
# 3/28/23.	wmk.	original code; adapted from UpdtAllRUdbs.sh
# 4/1/23.	wmk.	skip OBSOLETE territories.
# Legacy mods.
# 2/26/23.	wmk.	rewrite; adapted from UpdateAllSpecRUdbs.
# 3/12/23.	wmk.	bug fix where *codebase not used to switch to project path.
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
P1=$1
if [ -z "$P1" ];then
 P1=TIDList.txt
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
 export pathbase=$folderbase/Territories/FL/SARA/86777
fi
if [ -z "$congterr" ];then
 export congterr=FLSARA86777
fi
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "   AllMissIDs initiated from Make."
else
  ~/sysprocs/LOGMSG "   AllMissIDs initiated from Terminal."
fi
TEMP_PATH=$folderbase/temp
#
#procbodyhere
pushd ./ >> $TEMP_PATH/bitbucket.txt
cd $codebase/Projects-Geany/UpdateRUDwnld
echo "  AllMissIDs beginning processing."
error_counter=0		# set error counter to 0
IFS="&"			# set & as the word delimiter for read.
file=$P1
i=0
if test -f $TEMP_PATH/MissingIDs.txt;then rm $TEMP_PATH/MissingIDs.txt;fi
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
   if test -f $pathbase/$rupath/Terr$TID/OBSOLETE;then
    echo "  Territory $TID OBSOLETE - skipping..."
   else
    ls -lh $pathbase/$rupath/Terr$TID/MissingIDs.csv >> $TEMP_PATH/MissingIDs.txt
   fi		# end skip
  fi     # end is comment line conditional
#
 i=$((i+1))
done < $file
echo " $i TIDList.txt lines processed."
mawk '{if($5 != "0")print substr($8,index($8,"s/Terr")+2) " " $5}' $TEMP_PATH/MissingIDs.txt
popd >> $TEMP_PATH/scratchfile
if [ $error_counter = 0 ]; then
  rm $TEMP_PATH/scratchfile
else
  echo "  $error_counter errors encountered - check $TEMP_PATH/scratchfile "
fi
# endprocbody
~/sysprocs/LOGMSG " AllMissIDs $P1 complete." >> $system_log
echo " 	AllMissIDs $P1 complete."
