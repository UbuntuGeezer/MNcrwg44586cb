#!/bin/bash
echo " ** UpdtAllLtrRUdbs.sh out-of-date **";exit 1
echo " ** UpdtAllLtrRUdbs.sh out-of-date **";exit 1
# UpdtAllLtrRUdbs.sh = Update Letter RU downloads from list.
# 	6/6/23.	wmk.
#
# Usage.	bash UpdtAllLtrRUdbs.sh <state> <county> <congno>
#
# Entry. ($)folderbase/Projects-Geany/FixAnyRU project defined.
#        ./UpdateLtrDwnld/TIDList.txt has list of territories to run
#		 	UpdateLtrDwnld makefile against.
#
# Modification History.
# ---------------------
# 2/26/23.	wmk.	rewrite; adapted from UpdateAllSpecRUdbs.
# 3/12/23.	wmk.	bug fix where *codebase not used to switch to project path.
# 6/6/23.	wmk.	OBSOLETE territory detection.
# Legacy mods.
# 9/23/22.  wmk.    (automated) CB *codebase env var support.
# 10/4/22.  wmk.    (automated) fix *pathbase for CB system.
# Legacy mods.
# 12/6/21.	wmk.	original code; adapted from UpdtAllRUDwnld.
# 4/25/22.	wmk.	generalized for FL/SARA.86777;*pathbase* support.
# Legacy mods.
# 6/6/21.	wmk.	bug fix; equality check ($)HOME, TEMP_PATH
#					ensured set.
# 6/27/21.	wmk.	multihost code improved; superfluous "s removed.
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
P1=${1^^}
P2=${2^^}
P3=$3
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ];then
 echo "UpdateAllLtrRUdbs <state> <county> <congno> missing parameter(s) - abandoned."
 exit 1
fi
if [ -z "$folderbase" ];then
 if [ "$USER" = "ubuntu" ]; then
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
if [ "$P1$P2$P3" != "$congterr" ];then
 echo "*congterr* = :$congterr"
 echo "** $P1$P2$P3 mismatch with *congterr* - UpdateAllSpecRUdbs abandoned **"
 exit 1
fi
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "   UpdtAllLtrRUdbs initiated from Make."
else
  ~/sysprocs/LOGMSG "   UpdtAllLtrRUdbs initiated from Terminal."
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
#procbodyhere
pushd ./ >> $TEMP_PATH/bitbucket.txt
cd $codebase/Projects-Geany/UpdateLtrDwnld
MY_PROJ='Territories'
echo "  UpdtAllLtrRUdbs beginning processing."

error_counter=0		# set error counter to 0
IFS="&"			# set & as the word delimiter for read.
file=TIDList.txt
i=0
while read -e; do
  #reading each line
  echo -e " processing $REPLY " >> $TEMP_PATH/scratchfile
  len=${#REPLY}
  len1=$((len-1))
  firstchar=${REPLY:0:1}
#  echo -e "  $firstchar\n is first char of line." >> $TEMP_PATH/scratchfile
  #expr index $string $substring
  if [ "$firstchar" == "#" ]; then			# skip comment
   echo $REPLY >> $TEMP_PATH/scratchfile
  elif [ $len -eq 0 ];then					# skip empty line
   echo "blank line" >> $TEMP_PATH/scratchfile
  elif [ "$firstchar" == "\$" ];then			# $ terminates list
   break
  else
   skip=0
   TID=${REPLY:0:len}
   if test -f $pathbase/$rupath/OBSOLETE;then
    echo " ** Territory $TID OBSOLETE - UpdtAllLtrRUdbs skipping.."
    skip=1
   fi
   if [ $skip -eq 0 ];then
    bash ~/sysprocs/LOGMSG "  UpdateLtrDwnld $TID initiated."
    ./DoSed.sh $TID
    make -f MakeUpdateLtrDwnld
   fi	# skip = 0
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
~/sysprocs/LOGMSG " UpdtAllLtrRUdbs complete." >> $system_log
echo " 	UpdtAllLtrRUdbs complete."
