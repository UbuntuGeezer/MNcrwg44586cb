#!/bin/bash
echo " ** RebldAllRUSpecials.sh out-of-date **";exit 1
echo " ** RebldAllRUSpecials.sh out-of-date **";exit 1
# RebldAllRUSpecials.sh = Update RU downloads from list.
#	6/30/23.	wmk.
#
# Usage. bash	RebldAllRUSpecials.sh [--force-build]
#
#	--force-build = (optional) if present, force builds to happen regardless of
#		prerequisites.
#
# Entry. ($)folderbase/Projects-Geany/FixAnyRU project defined.
#        ./SpecialRUdb/DBList.txt has list of /Special databases to run
#		 	MakeSpecialRUdb makefile against.
#
# Modification History.
# ---------------------
# 6/30/23.	wmk.	bug fix * firstchr conditional ==; ($) processed as end in
#			 DBList.txt; add code to run <dbname>Tidy.sh after *make comments tidied.
# 9/23/22.  wmk.    (automated) CB *codebase env var support.
# 10/4/22.  wmk.    (automated) fix *pathbase for CB system.
# Legacy mods.
# 5/31/22.	wmk.	original code; adapted from CycleAllSpecRU.sh; single quotes
#			 removed from file= in do loop; TEMP_PATH fixed; fix bug where
#			 empty input line executes as empty db_name.
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
P1=${1,,}
forcemake=0
if [ ! -z "$P1" ];then
 if [ "$P1" == "--force-build" ];then
  forcemake=1
 else
  echo "RebuildAllRUSpecials [--force-build] unrecognized -- option - abandoned."
  read -p "Enter ctrl-c to remain in Terminal: "
  exit 1
 fi
fi
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
TEMP_PATH=$HOME/temp
#
#local_debug=0	# set to 1 for debugging
local_debug=0
#
if [ $local_debug -eq 1 ]; then
 pushd ./ > /dev/null
 cd ~/Documents		# write files to Documents folder
fi
#procbodyhere
pushd ./ > /dev/null
projpath=$codebase/Projects-Geany/SpecialRUdb
cd $projpath
altpath=$pathbase/$rupath/Special
MY_PROJ='Territories'
echo "  RebldAllRUSpecials beginning processing."
error_counter=0		# set error counter to 0
IFS="&"			# set & as the word delimiter for read.
file=DBList.txt
if ! test -f $file;then
 echo "** RebldAllRUSpecials missing file DBList.txt - abandoned. **"
 ~/sysprocs/LOGMSG "   RebldAllRUSpecials missing file DBList.txt - abandoned."
 read -p "Enter ctrl-c to remain in Terminal: "
 exit 1
fi
if [ $forcemake -ne 0 ];then
 touch $projpath/ForceBuild
fi
i=0
while read -e; do
  #reading each line
  echo -e " processing $REPLY " >> $pathbase/scratchfile
  len=${#REPLY}
  len1=$((len-1))
  firstchar=${REPLY:0:1}
#  echo -e "  $firstchar\n is first char of line." >> $HOME/temp/scratchfile
  #expr index $string $substring
  if [ "$firstchar" == "#" ] || [ ${#REPLY} -eq 0 ]; then	# skip comment
   echo $REPLY >> $TEMP_PATH/scratchfile
  elif [ "$firstchar" == "\$" ];then
   break
  else
   db_name=${REPLY:0:len}
   cd $projpath;./DoSed.sh " " $db_name
   make -f $projpath/MakeSpecialRUdb
   tidysuffx=Tidy.sh
   $altpath/$db_name$tidysuffx
  fi     # end is comment line conditional
#
 i=$((i+1))
done < $file
echo " $i DBList.txt lines processed."
popd > /dev/null
if [ $error_counter = 0 ]; then
  rm $TEMP_PATH/scratchfile
else
  echo "  $error_counter errors encountered - check $TEMP_PATH/scratchfile "
fi
# endprocbody
~/sysprocs/LOGMSG " RebldAllRUSpecials complete."
echo " 	RebldAllRUSpecials complete."
# end RebldAllRUSpecials.sh
