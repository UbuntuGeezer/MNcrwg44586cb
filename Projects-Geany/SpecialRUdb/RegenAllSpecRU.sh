#!/bin/bash
echo " ** RegenAllSpecRU.sh out-of-date **";exit 1
echo " ** RegenAllSpecRU.sh out-of-date **";exit 1
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
# 10/4/22.    wmk.   (automated) fix *pathbase for CB system.
# RegenAllSpecRU.sh = Update RU downloads from list.
#	4/24/22.	wmk.
#
# Usage.	bash RegenAllSpecRU.sh
#
# Entry. ($)folderbase/Projects-Geany/FixAnyRU project defined.
#        ./SpecialRUdb/DBList.txt has list of /Special databases to run
#		 	MakeSpecialRUdb makefile against.
#
# Modification History.
# ---------------------
# 4/24/22.	wmk.	code generalized for FL/SARA/86777;*pathbase*, 
#			 *congterr*, *conglib* env vars introduced.
# Legacy mods.
# 12/7/21.	wmk.	original code; adapted from UpdtAllRUDwnld.
# 12/28/21.	wmk.	change to use $ USER env var.
#
# Notes. If the user wants to include a comment in the DBList.txt file, (i.e. line
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
 if [ "$USER" == "ubuntu" ];then
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
if [ -z "$conglib" ];then
 export conglib=FLsara86777
fi
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  TEMP_PATH=$folderbase/temp
  ~/sysprocs/LOGMSG "   RegenAllSpecRU initiated from Make."
else
  ~/sysprocs/LOGMSG "   RegenAllSpecRU initiated from Terminal."
fi
TEMP_PATH=$folderbase/temp
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
cd $folderbase/Territories/Projects-Geany/SpecialRUdb
MY_PROJ='Territories'
echo "  RegenAllSpecRU beginning processing."
error_counter=0		# set error counter to 0
IFS="&"			# set & as the word delimiter for read.
file='DBList.txt'
if ! test -f $file;then
 echo "** RegenAllSpecRU missing file DBList.txt - abandoned. **"
 ~/sysprocs/LOGMSG "   RegenAllSpecRU missing file DBList.txt - abandoned."
 exit 1
fi
i=0
while read -e; do
  #reading each line
  echo -e " processing $REPLY " >> $folderbase/scratchfile
  len=${#REPLY}
  len1=$((len-1))
  firstchar=${REPLY:0:1}
#  echo -e "  $firstchar\n is first char of line." >> $HOME/temp/scratchfile
  #expr index $string $substring
  if [ "$firstchar" = "#" ]; then			# skip comment
   echo $REPLY >> $folderbase/temp/scratchfile
  else
   db_name=${REPLY:0:len}
   bash ~/sysprocs/LOGMSG "  MakeSpecialRUdb $db_name initiated."
   ./DoSed.sh '' $db_name
   make -f MakeSpecialRUdb
  fi     # end is comment line conditional

i=$((i+1))
done < $file
echo " $i DBList.txt lines processed."
popd >> $TEMP_PATH/scratchfile
if [ $error_counter = 0 ]; then
  rm $TEMP_PATH/scratchfile
else
  echo "  $error_counter errors encountered - check $TEMP_PATH/scratchfile "
fi
# end proc body
bash ~/sysprocs/LOGMSG " RegenAllSpecRU complete." >> $system_log
echo " 	RegenAllSpecRU complete."
