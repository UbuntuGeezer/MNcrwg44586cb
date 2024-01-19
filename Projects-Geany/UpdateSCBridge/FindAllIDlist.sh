#!/bin/bash
echo " ** FindAllIDlist.sh out-of-date **";exit 1
# FindAllIDlist.sh = Find all property IDs in territories from list.
# 6/7/23.	wmk.
#
# Usage.	bash FindAllIDlist.sh 
#
# Entry. ($)folderbase/Projects-Geany/UpdateSCBridge project defined.
#        ./UpdateSCBridge/LostIDlist.txt has list of property IDs to
#		 	process in FindAllIDlist and run FindAllIDinTerrs against.
#
# Modification History.
# ---------------------
# 6/7/23.	wmk.	*firstchar checks corrected; break on $ first char; OBSOLETE
#			 territory detection; comments tidied.
# Legacy mods.
# 4/26/22.	wmk.	*pathbase* support.
# 5/27/22.	wmk.	*TEMP_PATH* changed to *HOME*/temp.
# 9/23/22.  wmk.    (automated) CB *codebase env var support.
# Legacy mods.
# 7/23/21.	wmk.	original code; adapted from UpdtAllRUDwnld; includes
#			 multihost.
# 3/24/22.	wmk.	description clarified; HOME changed to USER in host test.
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
if [ -z "folderbase" ];then
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
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "   FindAllIDlist initiated from Make."
else
  ~/sysprocs/LOGMSG "   FindAllIDlist initiated from Terminal."
fi
TEMP_PATH=$HOME/temp
#
P1=$1
#local_debug=0	# set to 1 for debugging
local_debug=1
#
if [ $local_debug = 1 ]; then
 pushd ./ > $TEMP_PATH/bitbucket.txt
 cd ~/Documents		# write files to Documents folder
fi
#proc body here
pushd ./ >> $TEMP_PATH/bitbucket.txt
cd $codebase/Projects-Geany/UpdateSCBridge
MY_PROJ='Territories'
echo "  FindAllIDlist beginning processing."

error_counter=0		# set error counter to 0
IFS="&"			# set & as the word delimiter for read.
echo "" > ~/Documents/$P1.greplist.txt
echo "'$codebase/Projects-Geany/UpdateSCBridge/LostIDlist.txt'"
file=$codebase/Projects-Geany/UpdateSCBridge/LostIDlist.txt
i=0
while read -e; do
  #reading each line
  echo -e " processing $REPLY " >> $TEMP_PATH/scratchfile
  len=${#REPLY}
  len1=$((len-1))
  firstchar=${REPLY:0:1}
#  echo -e "  $firstchar\n is first char of line." >> $HOME/temp/scratchfile
  #expr index $string $substring
  if [ "$firstchar" == "#" ]; then			# skip comment
   echo $REPLY >> $TEMP_PATH/scratchfile
  elif [ "$firstcar" == "$" ];then
   break
  else
   TID=${REPLY:0:len}
   skip=0
   if test -f $pathbase/$scpath/Terr$TID/OBSOLETE;then
    skip=1
    echo " ** Territory $TID OBSOLETE - skipping...**"
   fi
   if [ $skip -eq 0 ];then
    ~/sysprocs/LOGMSG "  FindAllIDinTerrs $TID initiated."
    $codebase/Projects-Geany/UpdateSCBridge/FindAllIDinTerrs.sh $TID
   fi
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
# end proc body
~/sysprocs/LOGMSG " FindAllIDlist complete."
echo " 	FindAllIDlist complete."
