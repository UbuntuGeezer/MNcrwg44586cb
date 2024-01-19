#!/bin/bash
# AllUpdtRUDwnld.sh - Batch Run UpdateMHPDwnld for territories in TIDList.txt
# 7/2/23.	wmk.
#
# Usage. bash 	AllUpdtRUDwnld.sh
#
# Entry. ($)folderbase/Projects-Geany/AllUpdtRUDwnld project defined.
#        ./UpdateMHPDwnld/TIDList.txt has list of territories to run
#		 MakeUpdateMHPDwnld against.
#
# Modification History.
# ---------------------
# 6/6/23.	wmk.	OBSOLETE territory detection; *folderbase updated;
#			 skip out on TIDList.txt 1st char '$'; comments tidied.
# 7/2/23.	wmk.	*pathbase, *codebase environment vars replace hard-coded
#			 paths; pushd/popd to /dev/null.
# Legacy mods.
# 11/14/21.	wmk.	no shell modifications; new does Batch Run of 
#					MakeUpDateMHPDwnld where var oldway = 0 using
#					TIDList.txt
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
# Legacy mods.
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
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ]; then
  export folderbase="/media/ubuntu/Windows/Users/Bill"
 else 
  export folderbase=$HOME
 fi
fi
if [ -z "$codebase" ];then
 export codebase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories/FL/SARA/86777
fi
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  TEMP_PATH=$HOME/temp
else
  ~/sysprocs/LOGMSG "   AllUpdtRUDwnld initiated from Terminal."
fi
# P1=<dbname> P2=<mm> P3=<dd> 
P1=$1
P2=$2
P3=$3
P4=$4
if [ -z "$P1" ];then
 ~/sysprocs/LOGMSG "   missing <db-name> - AllUpdtRUDwnld abandoned."
 echo "   must specify <db-name> <terrid> - AllUpdtRUDwnld abandoned."
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
local_debug=0
#
if [ $local_debug = 1 ]; then
 pushd ./ > $TEMP_PATH/bitbucket.txt
 cd ~/Documents		# write files to Documents folder
fi
#procbodyhere
pushd ./ > /dev/null
cd $codebase/Projects-Geany/UpdateMHPDwnld
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
  if [ "$firstchar" == "#" ]; then			# skip comment
   echo $REPLY >> $TEMP_PATH/scratchfile
  elif [ "$firstchar" == "$" ];then
   break
  else
   TID=${REPLY:0:len}
   skip=0
   if test -f $pathbase/$rupath/Terr$TID/OBSOLETE;then
    skip=1
    echo " ** Territory $TID OBSOLETE - AllUpdtRUDwnld skipping...**"
   fi
   if [ $skip -eq 0 ];then
    bash ~/sysprocs/LOGMSG "  MakeRUMHP $TID initiated."
    ./DoSed.sh $DB_NAME $TID
    make -f MakeUpdateMHPDwnld
   fi	# end skip
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
~/sysprocs/LOGMSG " AllUpdtRUDwnld complete."
echo " 	AllUpdtRUDwnld complete."
#end AllUpdtRUDwnld proc.
