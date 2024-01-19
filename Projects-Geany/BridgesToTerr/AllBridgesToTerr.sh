#!/bin/bash
echo " ** AllBridgesToTerr.sh out-of-date **";exit 1
echo " ** AllBridgesToTerr.sh out-of-date **";exit 1
# AllBridgesToTerr.sh = Create territories from TIDList Bridge records.
# 2/1/23.	wmk.
#
# Usage.	bash AllBridgesToTerr.sh
#
# Entry. ($)folderbase/Projects-Geany/AllBridgesToTerr project defined.
#        ./AllBridgesToTerr/TIDList.txt has list of territories to run
#		 BridgesToTerr against.
#
# Modification History.
# ---------------------
# 2/1/23.	wmk.	debug var removed.
# Legacy mods.
# 9/23/22.  wmk.    (automated) CB *codebase env var support.
# 10/4/22.  wmk.    (automated) fix *pathbase for CB system.
# 10/5/22.	wmk.	comments tidied; jumpt function removed.
# Legacy mods.
# 5/13/22.	wmk.	*pathbase* support; *projpath* var introduced for correct
#		 	 *make* pathing.
# 6/11/22.	wmk.	add verification that AllBridgesToTerr.sh are in sync on both
#			 /Procs-Dev and /BridgesToTerr folders.
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
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ]; then
  export folderbase="/media/ubuntu/Windows/Users/Bill"
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
  system_log="$folderbase/ubuntu/SystemLog.txt"
  ~/sysprocs/LOGMSG "   AllBridgesToTerr initiated from Make."
else
  ~/sysprocs/LOGMSG "   AllBridgesToTerr initiated from Terminal."
fi
TEMP_PATH=$HOME/temp
# check .sh files in sync...
if test -f $codebase/Procs-Dev/AllBridgesToTerr.sh;then
 diff -s $codebase/Procs-Dev/AllBridgesToTerr.sh \
  $codebase/Projects-Geany/BridgesToTerr/AllBridgesToTerr.sh \
  > $TEMP_PATH/scratchfile
 if [ $? -ne 0 ];then
  echo "** WARNING: AllBridgesToTerr has different versions...**"
  read -p "  Continue anyway (y/n)? "
  yn=${REPLY^^}
  if [ $yn != "Y" ];then
   echo " AllBridgesToTerr abandoned due to version differences."
  ~/sysprocs/LOGMSG " AllBridgesToTerr abandoned due to version differences."
   exit 1
  fi
 fi
fi	#end Procs-Dev version exists conditional
#
P1=$1
#proc body here
pushd ./ >> $TEMP_PATH/bitbucket.txt
cd $codebase/Projects-Geany/BridgesToTerr
MY_PROJ='Territories'
echo "  AllBridgesToTerr beginning processing."
if [ -z $TEMP_PATH ]; then
  TEMP_PATH=$HOME/temp
fi
#echo "TEMP_PATH = '$TEMP_PATH'"

error_counter=0		# set error counter to 0
IFS="&"			# set & as the word delimiter for read.
projpath=$codebase/Projects-Geany/BridgesToTerr
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
