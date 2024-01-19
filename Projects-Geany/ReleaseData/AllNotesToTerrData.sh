#!/bin/bash
# AllNotesToTerrData.sh = Create territories from TIDList Bridge records.
# 5/7/22.	wmk.
#
# Usage.	bash AllNotesToTerrData.sh
#
# Entry. ($)folderbase/Projects-Geany/AllNotesToTerrData project defined.
#        ./ReleaseData/NotesTIDList.txt has list of territories paths to run
#		  MvPubNotes against.
#
# Modification History.
# ---------------------
# 1/1/22.	wmk.	original code; adapted from AllBridgesToTerr.
# 5/7/22.	wmk.	*pathbase* support.
# 
# Notes. If the user wants to include a comment in the NotesTIDList.txt file, (i.e. line
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
  ~/sysprocs/LOGMSG "   AllNotesToTerrData initiated from Make."
else
  ~/sysprocs/LOGMSG "   AllNotesToTerrData initiated from Terminal."
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
cd $pathbase/Projects-Geany/ReleaseData
MY_PROJ='Territories'
echo "  AllNotesToTerrData beginning processing."
if [ -z $TEMP_PATH ]; then
  TEMP_PATH=$HOME/temp
fi
#echo "TEMP_PATH = '$TEMP_PATH'"

error_counter=0		# set error counter to 0
IFS="&"			# set & as the word delimiter for read.
file='NotesTIDList.txt'
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
   terr_path=${REPLY:0:len}
   TID=${terr_path:20:3}
   bash ~/sysprocs/LOGMSG "  MvPubNotes initiated."
   ./DoSed1.sh $TID
   make -f MakeMvPubNotes
  fi     # end is comment line conditional

i=$((i+1))
done < $file
echo " $i NotesTIDList.txt lines processed."
if [ $error_counter = 0 ]; then
  rm $TEMP_PATH/scratchfile
else
  echo "  $error_counter errors encountered - check $TEMP_PATH/scratchfile "
fi
bash ~/sysprocs/LOGMSG " AllNotesToTerrData complete." >> $system_log
echo " 	AllNotesToTerrData complete."
#end AllNotesToTerrData proc.
