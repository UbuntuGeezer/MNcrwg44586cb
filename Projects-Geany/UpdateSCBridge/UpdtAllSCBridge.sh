#!/bin/bash
echo " ** UpdtAllSCBridge.sh out-of-date **";exit 1
# UpdtAllSCBridge.sh = Update SC downloads from list.
# 7/7/23.	wmk.
#
# Usage.	bash UpdtAllSCBridge.sh mm dd
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
# 2/26/23.	wmk.	modified to integrate with SyncAllData; check for segdefs.csv
#			 in Terrxxx folder and *make Terrxxx_SC.db from segdefs.
# 3/8/23.	wmk.	bug fix unbalanced if,s from segdefs conditional.
# 5/11/23.	wmk.	bug fix makefile corrected in make MakeBuildSCFromSegDefs.
# 5/13/23.	wmk.	*MYPROJ env var support reactivated; *build_log and
#			 BLDMSG used for error handling.
# 7/7/23.	wmk.	pushd/popd to /dev/null.
# Legacy mods.
# 11/23/22.	wmk.	*pathbase corrected; TID len corrected; replace jumpto with
#			 break; remove jumpto function; comments tidied.
# 1/29/23.	wmk.	len1 used for length setting *TID from *REPLY.
# Legacy mods.
# 5/2/22.	wmk.	modified for *pathbase* support
# 5/27/22.	wmk.	*TEMP_PATH* definition added; record *make* errors to
#			 *TEMP_PATH/MakeErrors.txt.
# 9/23/22.  wmk.    (automated) CB *codebase env var support.
# Legacy mods.
# 6/27/21.	wmk.	original code; adapted from UpdtAllRUDwnld; includes
#			 multihost support; mm dd paramters supported.
# 1/2/22.	wmk.	use USER in place of HOME in host check; bug fix where logic
#			 reversed in host check; shell moved to UpdateSCBridge project
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
TEMP_PATH=$HOME/temp
P1=$1
P2=$2
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "   UpdtAllSCBridge initiated from Make."
else
  ~/sysprocs/LOGMSG "   UpdtAllSCBridge initiated from Terminal."
fi
TEMP_PATH=$folderbase/temp
# set default mm dd to 06 19.
if [ -z "$P1" ] || [ -z "$P2" ]; then
 echo " ** WARNING - mm dd not passed into UpdtAllSCBridge **"
 read -p " proceed using 04 04 as default (Y/N)? "
 yn=${REPLY^^}
 if [ "$yn" == "Y" ];then
  P1=04
  P2=04
 else
  echo "UpdtAllSCBridge halted by user."
  ~/sysprocs/LOGMSG "  UpdtAllSCBridge halted by user."
  exit 1
 fi		# end REPLY test
fi
#local_debug=0	# set to 1 for debugging
local_debug=0
#
if [ $local_debug = 1 ]; then
 pushd ./ > $TEMP_PATH/bitbucket.txt
 cd ~/Documents		# write files to Documents folder
fi
#procbodyhere
pushd ./ > /dev/null
cd $codebase/Projects-Geany/UpdateSCBridge
projpath=$codebase/Projects-Geany/UpdateSCBridge
syncpath=$codebase/Projects-Geany/SyncAllData
segspath=$codebase/Projects-Geany/SegDefsMgr
export MY_PROJ=UpdateSCBridge
echo "  UpdtAllSCBridge beginning processing."
#
error_counter=0		# set error counter to 0
IFS="&"			# set & as the word delimiter for read.
file=$projpath/TIDList.txt
i=0
while read -e; do
  #reading each line
  echo -e " processing $REPLY " >> $folderbase/scratchfile
  len=${#REPLY}
  len1=$((len-1))
  firstchar=${REPLY:0:1}
#  echo -e "  $firstchar\n is first char of line." >> $HOME/temp/scratchfile
  #expr index $string $substring
  if [ "$firstchar" == "#" ] || [ $len -eq 0 ];then		# skip comment
   echo $REPLY >> $folderbase/temp/scratchfile
  elif [ "$firstchar" == "\$" ]; then
   break
  else
   TID=${REPLY:0:len1}
   if test -f $pathbase/$scpath/Terr$TID/segdefs.csv;then
    pushd ./ > $TEMP_PATH/scratchfile
    cd $segspath
    ./DoSedSegDefs.sh  $TID SCPA $P1 $P2
    #debugging
    # cat $segspath/MakeBuildSCFromSegDefs
    # echo " debug interrupted process..."
    # exit 0
    # end debugging
    make -f $segspath/MakeBuildSCFromSegDefs
    if ! test $segspath/MakeBuildSCFromSegDefs.sh;then
     echo "  ** MakeBuildSCFromSegDefs FAILED - Terr $TID update failed **"
    else
     $segspath/BuildSCFromSegDefs.sh
    fi
    popd > $TEMP_PATH/scratchfile
   else
    ~/sysprocs/LOGMSG "  UpdateSCDwnld $TID initiated."
    $projpath/DoSed.sh $TID $P1 $P2
    make --silent -f $projpath/MakeUpdateSCBridge
    if [ $? -ne 0 ];then
     ~/sysprocs/BLDMSG "*make* MakeUpdateSCBridge $TID $P1 $P2.. FAILED."
    fi
    echo "UpdateSCBridge $TID complete."
   fi     # end segdefs conditional
  fi	# end is comment conditional
#
i=$((i+1))
done < $file
#jumpto Finish
#Finish:
echo " $i TIDList.txt lines processed."
popd >  /dev/null
if [ $error_counter = 0 ]; then
  rm $TEMP_PATH/scratchfile
else
  echo "  $error_counter errors encountered - check $TEMP_PATH/scratchfile "
fi
# endprocbody
~/sysprocs/LOGMSG " UpdtAllSCBridge complete."
echo " 	UpdtAllSCBridge complete."
