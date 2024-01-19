#!/bin/bash
echo " ** LoopAnyShell.sh out-of-date **";exit 1
# LoopAnyShell.sh - Loop any shell on list.
# 6/14/23.	wmk.
#
# Usage.	bash LoopAnyShell.sh  <shellname> <listsource> [p1 p2 p3]
#
#	<shellname> = name of shell to loop (e.g. ShellDesc.sh)
#	<listsource> = path to list of filenames to loop <shellname> on
#	p1 = P1 parameter for <shellname>
#	p2 = P2 parameter for <shellname>
#	p3 = P3 parameter for <shellname>
#
# Entry. <listsource> list of filenames; lines starting with '#' treated as
#			comments; line starting with '$' treated as end of list
#
# Modification History.
# ---------------------
# 6/14/23.	wmk.	original code; adapted from UpdateSCBridge/FindAllIDlist.
# Legacy mods.
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
# If the <shellname> runs using a list of files with optional parameters, the
# <shellname> parameter list should specify the filename as the first parameter.
# (e.g. FixRUCsv.sh <filename> - ..etc.
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
  ~/sysprocs/LOGMSG "   LoopAnyShell initiated from Make."
else
  ~/sysprocs/LOGMSG "   LoopAnyShell initiated from Terminal."
fi
TEMP_PATH=$HOME/temp
#
P1=$1
P2=$2
P3=$3
P4=$4
P5=$5
if [ -z "$P1" ] || [ -z "$P2" ];then
 echo "LoopAnyShell <shellname> <listsource> [p1 p2 p3] missing parameter(s) - abandoned."
 exit 1
fi
#procbodyhere
pushd ./ > /dev/null
#
MY_PROJ='Territories'
echo "  LoopAnyShell beginning processing."
error_counter=0		# set error counter to 0
IFS="&"			# set & as the word delimiter for read.
file=$P2
i=0
while read -e; do
  #reading each line
  echo -e " processing $REPLY " >> $TEMP_PATH/scratchfile
  len=${#REPLY}
  len1=$((len-1))
  firstchar=${REPLY:0:1}
  next_one=$REPLY
#  echo -e "  $firstchar\n is first char of line." >> $HOME/temp/scratchfile
  #expr index $string $substring
  if [ "$firstchar" == "#" ]; then			# skip comment
   echo $REPLY >> $TEMP_PATH/scratchfile
  elif [ "$firstchar" == "$" ];then
   break
  else
    $P1 $next_one  $P3 $P4 $P5
  fi
i=$((i+1))
done < $file
echo " $i $P2 lines processed."
popd > /dev/null
# endprocbody
~/sysprocs/LOGMSG " LoopAnyShell complete."
echo " 	LoopAnyShell complete."
