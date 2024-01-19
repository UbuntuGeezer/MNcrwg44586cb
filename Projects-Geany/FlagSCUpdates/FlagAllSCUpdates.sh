#!/bin/bash
echo " ** FlagAllSCUpdates.sh out-of-date **";exit 1
echo " ** FlagAllSCUpdates.sh out-of-date **";exit 1
# FlagAllSCUpdates.sh = Update SC downloads from list.
# 1/29/23.	wmk.
#
# Usage.	bash FlagAllSCUpdates.sh mm dd
#
#		mm - month of latest download (default 06)
#		dd - day of latest download (default 19)
#
# Entry. ($)folderbase/Projects-Geany/UpdtSCBridge project defined.
#		 ($)folderbase/Projects-Geany/FixAnySC project defined.
#        ./UpdateSCBridge/TIDList.txt has list of territories to run FixSC against.
#
# Modification History.
# ---------------------
# 1/29/23.	wmk.	len1 used to set *TID correctly from *REPLY.
# Legacy mods.
# 9/23/22.  wmk.    (automated) CB *codebase env var support.
# 10/4/22.  wmk.    (automated) fix *pathbase for CB system.
# 10/5/22.	wmk.	comments tidied.
# 11/23/22.	wmk.	bug fix; len1 replaced with len when setting TID; *sed* -q
#			 corrected to -n; month, day parameters documented; ignore blank
#			 lines; replace jumpto in loop with break; remove junpto definition.
# Legacy mods.
# 5/2/22.	wmk.	original code; cloned from UpdtAllSCBridge.
# 7/1/22.	wmk.	-ne expression fixed checking for error code; bug fix
#			 when reading lines <newline> included in *TID; 'complete'
#		 	 message issued for each TID.
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
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ]; then
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
P1=$1		# month (download)
P2=$2		# day (download)
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "   FlagAllSCUpdates initiated from Make."
else
  ~/sysprocs/LOGMSG "   FlagAllSCUpdates initiated from Terminal."
fi
TEMP_PATH=$folderbase/temp
# set default mm dd to 06 19.
if [ -z "$P1" ] || [ -z "$P2" ]; then
 echo "FlagAllSCUpdates mm dd missing parameter(s) - abandoned."
 read -p "Enter ctrl-c to remain in Terminal:"
 exit 1
fi
#procbodyhere
pushd ./ >> $TEMP_PATH/bitbucket.txt
cd $codebase/Projects-Geany/FlagSCUpdates
altproj=$codebase/Projects-Geany/UpdateSCBridge
projpath=$codebase/Projects-Geany/FlagSCUpdates
MY_PROJ='Territories'
echo "  FlagAllSCUpdates beginning processing."
#
error_counter=0		# set error counter to 0
IFS="&"			# set & as the word delimiter for read.
file=$altproj/TIDList.txt
i=0
while read -e; do
  #reading each line
  echo -e " processing $REPLY " >> $folderbase/scratchfile
  len=${#REPLY}
  len1=$((len-1))
  firstchar=${REPLY:0:1}
#  echo -e "  $firstchar\n is first char of line." >> $HOME/temp/scratchfile
  #expr index $string $substring
  if [ "$firstchar" == "#" ] || [ $len -eq 0 ]; then		# skip comment
   echo $REPLY >> $TEMP_PATH/scratchfile
  elif [ "$firstchar" == "\$" ];then
   break
  else
   TID=${REPLY:0:len1}
   ~/sysprocs/LOGMSG "  FlagSCUpdates $TID $P1 $P2 initiated."
   $projpath/DoSed.sh $TID $P1 $P2
   sed -n "/|| \'/p" $projpath/FlagSCUpdate.sql > $TEMP_PATH/attaches.txt
   make -f $projpath/MakeFlagSCUpdates
   if [ $? -ne 0 ];then
    if ! test -f $TEMP_PATH/MakeErrors.txt;then
     date +%c > $TEMP_PATH/MakeErrors.txt
    fi
    echo "*make* MakeFlagSCUpdates $TID $P1 $P2 failed." >> $TEMP_PATH/MakeErrors.txt
   fi
   echo "FlagSCUpdate $TID complete."
  fi     # end is comment line conditional
#
i=$((i+1))
done < $file
#jumpto Finished
#Finished:
echo " $i TIDList.txt lines processed."
popd >> $TEMP_PATH/scratchfile
if [ $error_counter = 0 ]; then
  rm $TEMP_PATH/scratchfile
else
  echo "  $error_counter errors encountered - check $TEMP_PATH/scratchfile "
fi
# endprocbody
~/sysprocs/LOGMSG " FlagAllSCUpdates complete."
echo " 	FlagAllSCUpdates complete."
