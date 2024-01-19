#!/bin/bash
echo " ** UpdtAllSCSpecials.sh out-of-date **";exit 1
# UpdtAllSCSpecials.sh = Update SC downloads from list.
# 	5/4/23.	wmk.
#
# Usage.	bash UpdtAllSCSpecials.sh mm dd
#
#		mm - month of latest download (default 06)
#		dd - day of latest download (default 19)
#
# Entry. ($)folderbase/Projects-Geany/UpdtSCBridge project defined.
#		 ($)folderbase/Projects-Geany/FixAnySC project defined.
#        ./UpdateSCBridge/DBList.txt has list of databases to run
#		  UpdtAllSCSpecials against.
#
# Modification History.
# ---------------------
# 11/24/22.	wmk.	*pathbase corrected with *congterr; jumpto function elminated;
#			 exit hadling allowing Terminal to continue; comments tidied.
# 5/4/23.	wmk.	'export' added to folderbase, codebase, pathbase conditionals.
# Legacy mods.
# 4/25/22.	wmk.	modified for general use;*pathbase* support; default mm dd
#			 to 11 21
# 5/27/22.	wmk.	*TEMP_PATH* definition added.
# 5/30/22.	wmk.	default mm dd set to 05 26.
# 5/31/22.	wmk.	TIDList corrected to DBList in comments.
# 9/23/22.  wmk.   (automated) CB *codebase env var support.
# Legacy mods.
# 11/6/21.	wmk.	original code; adapted from UpdtAllSCBridge; includes
#			 multihost support; mm dd paramters supported.
# 1/3/22.	wmk.	use USER instead of HOME for host test.
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
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ]; then
  export folderbase=/media/ubuntu/Windows/Users/Bill
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
TEMP_PATH=$HOME/temp
P1=$1
P2=$2
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "   UpdtAllSCSpecials initiated from Make."
else
  ~/sysprocs/LOGMSG "   UpdtAllSCSpecials initiated from Terminal."
fi
TEMP_PATH=$folderbase/temp
# set default mm dd to 11 21.
if [ -z "$P1" ] || [ -z "$P2" ]; then
 echo " UpdtAllSpecSCBridge mm dd not specified..."
 read -p " OK to use 11 21 (Y/N)? "
 yn={REPLY^^}
 if [ "$yn" == "Y" ];then
  P1=11
  P2=21
 else
  echo "run UpdtAllSpecSCBridge mm dd specifying mm dd.."
  read -p "Enter ctrl-c to remain in Terminal:"
  exit 1
 fi
fi
#local_debug=0	# set to 1 for debugging
local_debug=1
#
#procbodyhere
pushd ./ >> $TEMP_PATH/bitbucket.txt
cd $codebase/Projects-Geany/UpdateSCBridge
MY_PROJ='Territories'
echo "  UpdtAllSCSpecials beginning processing."
#
error_counter=0		# set error counter to 0
IFS="&"			# set & as the word delimiter for read.
file=DBList.txt
i=0
while read -e; do
  #reading each line
  echo -e " processing $REPLY " >> $TEMP_PATH/scratchfile
  len=${#REPLY}
  len1=$((len-1))
  firstchar=${REPLY:0:1}
#  echo -e "  $firstchar\n is first char of line." >> $HOME/temp/scratchfile
  #expr index $string $substring
  if [ "$firstchar" == "#" ] || [ $len -eq 0 ]; then			# skip comment
   echo $REPLY >> $TEMP_PATH/scratchfile
  else
   DBNAME=${REPLY:0:len}
   ~/sysprocs/LOGMSG "  UpdateSCDwnld $DBNAME initiated."
   ./DoSed1.sh $DBNAME $P1 $P2
   make -f MakeUpdtSpecSCBridge
  fi     # end is comment line conditional
#
 i=$((i+1))
done < $file
echo " $i DBList.txt lines processed."
popd >> $TEMP_PATH/scratchfile
if [ $error_counter = 0 ]; then
  rm $TEMP_PATH/scratchfile
else
  echo "  $error_counter errors encountered - check $TEMP_PATH/scratchfile "
fi
# endprocbody
~/sysprocs/LOGMSG " UpdtAllSCSpecials $P1 $P2 complete."
echo " 	UpdtAllSCSpecials $P1 $P2 complete."
# end UpdtAllSCSpecials
