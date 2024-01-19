#!/bin/bash
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
# AllUpdtRUDwnld.sh - create all Mapxxx_RU.csv files for territories in TIDList.txt
# 7/6/21.	wmk.
#
# Usage.	bash AllUpdtRUDwnld.sh
#
# Entry. ($)folderbase/Projects-Geany/AllUpdtRUDwnld project defined.
#        ./UpdateMHPDwnld/TIDList.txt has list of territories to run
#		 MakeRUMHP against.
#
# Modification History.
# ---------------------
# 7/6/21.	wmk.	original code; adapted from AllMakeRUMHP; includes
#				    multihost support.
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
if [ "$HOME" == "/home/ubuntu" ]; then
 folderbase="/media/ubuntu/Windows/Users/Bill"
else 
 folderbase=$HOME
fi
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  TEMP_PATH=$HOME/temp
else
  ~/sysprocs/LOGMSG "   AllUpdtRUDwnld initiated from Terminal."
fi
P1=$1
P2=$2
P3=$3
P4=$4
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ] ;then
 ~/sysprocs/LOGMSG "   missing parameter(s)- AllUpdtRUDwnld abandoned."
 echo "   must specify <db-name> mm dd - AllUpdtRUDwnld abandoned."
 exit 1
fi
~/sysprocs/LOGMSG "   AllUpdtRUDwnld $P1 initiated."
TEMP_PATH=$HOME/temp
#
DB_NAME=$P1
MM=$P2
DD=$P3
#TID=$P4
#local_debug=0	# set to 1 for debugging
local_debug=1
#
if [ $local_debug = 1 ]; then
 pushd ./ > $TEMP_PATH/bitbucket.txt
 cd ~/Documents		# write files to Documents folder
fi
#proc body here
pushd ./ >> $TEMP_PATH/bitbucket.txt
cd $folderbase/Territories/Projects-Geany/UpdateMHPDwnld
MY_PROJ='Territories'
echo "  AllUpdtRUDwnld beginning processing."
if [ -z $TEMP_PATH ]; then
  TEMP_PATH=$HOME/temp
fi
echo "TEMP_PATH = '$TEMP_PATH'"

error_counter=0		# set error counter to 0
IFS="&"			# set & as the word delimiter for read.
file='TIDList.txt'
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
   echo $REPLY >> $TEMP_PATH/scratchfile
  else
   TID=${REPLY:0:len}
   bash ~/sysprocs/LOGMSG "  MakeRUMHP $TID initiated."
   ./DoSed.sh $DB_NAME $MM $DD $TID
   make -f MakeUpdateMHPDwnld
  fi     # end is comment line conditional

i=$((i+1))
#echo "  currently in folder $PWD"
done < $file
echo " $i TIDList.txt lines processed."
if [ $error_counter = 0 ]; then
  rm $TEMP_PATH/scratchfile
else
  echo "  $error_counter errors encountered - check $TEMP_PATH/scratchfile "
fi
bash ~/sysprocs/LOGMSG " AllUpdtRUDwnld complete." >> $system_log
echo " 	AllUpdtRUDwnld complete."
#end AllUpdtRUDwnld proc.
