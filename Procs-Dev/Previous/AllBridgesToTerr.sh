#!/bin/bash
# AllBridgesToTerr.sh = Create territories from TIDList Bridge records.
# 8/2/22.	wmk.
#
# Usage.	bash AllBridgesToTerr.sh
#
# Entry. ($)folderbase/Projects-Geany/AllBridgesToTerr project defined.
#        ./AllBridgesToTerr/TIDList.txt has list of territories to run
#		 BridgesToTerr against.
#
# Modification History.
# ---------------------
# 5/13/22.	wmk.	*pathbase* support; *projpath* var introduced for correct
#		 	 *make* pathing.
# 8/2/22.	wmk.	modified to terminate on line beginning with '$'.
# Legacy mods.
# 6/7/21.	wmk.	original code; adapted from UpdtAllRUDwnld; includes
#				    multihost support.
# 7/5/21.	wmk.	multihost code generalized; fix to TEMP_PATH assignment.
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
  export folderbase="/media/ubuntu/Windows/Users/Bill"
 else 
  export folderbase=$HOME
 fi
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories/FL/SARA/86777
fi
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log="$folderbase/ubuntu/SystemLog.txt"
  ~/sysprocs/LOGMSG "   AllBridgesToTerr initiated from Make."
else
  ~/sysprocs/LOGMSG "   AllBridgesToTerr initiated from Terminal."
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
cd $pathbase/Projects-Geany/BridgesToTerr
MY_PROJ='Territories'
echo "  AllBridgesToTerr beginning processing."
if [ -z $TEMP_PATH ]; then
  TEMP_PATH=$HOME/temp
fi
#echo "TEMP_PATH = '$TEMP_PATH'"

error_counter=0		# set error counter to 0
IFS="&"			# set & as the word delimiter for read.
projpath=$pathbase/Projects-Geany/BridgesToTerr
file=$projpath/TIDList.txt
while read -e; do
  #reading each line
  echo -e " processing $REPLY " >> $TEMP_PATH/scratchfile
  len=${#REPLY}
  len1=$((len-1))
  firstchar=${REPLY:0:1}
#  echo -e "  $firstchar\n is first char of line." >> $HOME/temp/scratchfile
  #expr index $string $substring
  if [ "$firstchar" == "#" ]; then			# skip comment
   echo $REPLY >> $HOME/temp/scratchfile
  elif [ "$firstchar" == "\$" ]; then
   echo " $i TIDList.txt lines processed."
   if [ $error_counter = 0 ]; then
     rm $TEMP_PATH/scratchfile
   else
     echo "  $error_counter errors encountered - check $TEMP_PATH/scratchfile "
   fi
   bash ~/sysprocs/LOGMSG " AllBridgesToTerr complete." >> $system_log
   echo " 	AllBridgesToTerr complete."
   exit 0
  else
   TID=${REPLY:0:len}
   ~/sysprocs/LOGMSG "  BridgesToTerr $TID initiated."
   echo " processing $TID ..."
   cd $projpath;$projpath/DoSed.sh $TID
   make -f $projpath/MakeBridgesToTerr
  fi     # end is comment line conditional

i=$((i+1))
done < $file
echo " $i TIDList.txt lines processed."
if [ $error_counter = 0 ]; then
  rm $TEMP_PATH/scratchfile
else
  echo "  $error_counter errors encountered - check $TEMP_PATH/scratchfile "
fi
bash ~/sysprocs/LOGMSG " AllBridgesToTerr complete." >> $system_log
echo " 	AllBridgesToTerr complete."
#end AllBridgesToTerr proc.
