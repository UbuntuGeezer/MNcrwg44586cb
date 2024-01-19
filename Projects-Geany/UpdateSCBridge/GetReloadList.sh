#!/bin/bash
echo " ** GetReloadList.sh out-of-date **";exit 1
# GetReloadList.sh = Update SC downloads from list.
#	6/7/23.	wmk.
#
# Usage.	bash GetReloadList.sh mm dd
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
# 11/22/22.	wmk.	original code; adapted from UpdtAllSCBridge.
# 6/7/23.	wmk.	*firstchar tests corrected; OBSOLETE territory detection.
# Legacy mods.
# 5/2/22.	wmk.	modified for *pathbase* support
# 5/27/22.	wmk.	*TEMP_PATH* definition added; record *make* errors to
#			 *TEMP_PATH/MakeErrors.txt.
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
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
#jumpto function definition
function jumpto
{
    label=$1
    cmd=$(sed -n "/$label:/{:a;n;p;ba};" $0 | grep -v ':$')
    eval "$cmd"
    exit
}
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
 export pathbase=$folderbase/Territories
fi
TEMP_PATH=$HOME/temp
P1=$1
P2=$2
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "   GetReloadList initiated from Make."
else
  ~/sysprocs/LOGMSG "   GetReloadList initiated from Terminal."
fi
TEMP_PATH=$folderbase/temp
# set default mm dd to 06 19.
if [ -z "$P1" ] || [ -z "$P2" ]; then
 P1=06
 P2=30
fi
#local_debug=0	# set to 1 for debugging
local_debug=1
#
if [ $local_debug = 1 ]; then
 pushd ./ > $TEMP_PATH/bitbucket.txt
 cd ~/Documents		# write files to Documents folder
fi
#procbodyhere
pushd ./ >> $TEMP_PATH/bitbucket.txt
cd $codebase/Projects-Geany/UpdateSCBridge
projpath=$codebase/Projects-Geany/UpdateSCBridge
MY_PROJ='Territories'
echo "  GetReloadList beginning processing."
#
error_counter=0		# set error counter to 0
IFS="&"			# set & as the word delimiter for read.
file=$projpath/TIDList.txt
if test -f $TEMP_PATH/ReloadList.txt;then
 rm $TEMP_PATH/ReloadList.txt
fi
terr=Terr
i=0;j=0
touch $TEMP_PATH/ReloadList.txt
while read -e; do
  #reading each line
  echo -e " processing $REPLY " >> $folderbase/scratchfile
  len=${#REPLY}
  len1=$((len-1))
  firstchar=${REPLY:0:1}
#  echo -e "  $firstchar\n is first char of line." >> $HOME/temp/scratchfile
  #expr index $string $substring
  if [ "$firstchar" == "#" ]; then			# skip comment
   echo $REPLY >> $folderbase/temp/scratchfile
  elif [ "$firstchar" == "$" ]; then
	break
  else
   TID=${REPLY:0:len1}
   terr_path=$terr$TID
   skip=0
   if test -f $pathbase/$scpath/$terr_path/OBSOLETE;then
    skip=1
    echo " ** Territory $TID OBSOLETE - skipping..**"
   fi
   if [ $skip -eq 0 ];then
    if ! test -f $pathbase/$scpath/$terr_path;then
   	 echo $TID >> $TEMP_PATH/ReloadList.txt
   	 j=$((j+1))
    fi
   fi	# skip=0
  fi     # end is comment line conditional
#
i=$((i+1))
done < $file
#jumpto Finish
#Finish:
echo " $i TIDList.txt lines processed."
echo " $j ReloadList entries."
if [ $j -gt 0 ];then
 echo "  *cat* $TEMP_PATH/ReloadList.txt for list of territories to reload."
fi
popd >> $TEMP_PATH/scratchfile
if [ $error_counter = 0 ]; then
  rm $TEMP_PATH/scratchfile
else
  echo "  $error_counter errors encountered - check $TEMP_PATH/scratchfile "
fi
# endprocbody
~/sysprocs/LOGMSG " GetReloadList complete."
echo " 	GetReloadList complete."
