#!/bin/bash
echo " ** FindAllIDinTerrs.sh out-of-date **";exit 1
# FindAllIDinTerrs.sh = Update RU downloads from list.
# 6/7/23.	wmk.
#
# Usage.	bash FindAllIDinTerrs.sh <propid>
#
#		<propID> = property Id to search for
#
# Entry. ($)folderbase/Projects-Geany/UpdateSCBridge project defined.
#        ./UpdateSCBridge/TIDList.txt has list of territories to run
#		 	FindAllIDinTerrs.sh against.
#		 *pathase/*scpath/Terr<TIDList-entry>/Terr<TIDList-entry_SC.db
#			is SC database for each territory in TIDList
#
# Exit.	[*TEMP_PATH/<propid>.sqllist.txt] = records with matching <propID>
#	from all territories in TIDList.txt: 
#	<propID> TerrID UnitAddress Unit SitusAddress
#
# Modification History.
# ---------------------
# 9/23/22.  wmk.    (automated) CB *codebase env var support.
# 6/7/23.	wmk.	bug fix where line split in SELECT; OBSOLETE territory
#			 detection; terminate loop on line with $ as 1st char; comments
#			 expanded, tidied.
# Legacy mods.
# 4/26/22.	wmk.	<state> <county> <congno> support;*pathbase* support.
# 5/27/22.	wmk.	*TEMP_PATH* definition added.
# Legacy mods.
# 7/23/21.	wmk.	original code; adapted from UpdtAllRUDwnld; includes
#			 multihost.
# 3/24/22.	wmk.	HOME changed to USER in host test.
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
if [ -z "$folderbase" ];then
 if [ "$USER" = "ubuntu" ]; then
   terrbase=/media/ubuntu/Windows/Users/Bill
   folderbase=/media/ubuntu/Windows/Users/Bill
 else
   terrbase=$HOME
   folderbase=$HOME
 fi
fi
if [ -z "$codebase" ];then
 codebase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$pathbase" ];then
 pathbase=$folderbase/Territories
fi
TEMP_PATH=$HOME/temp
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ]; then
 echo " DoSed - territory mm dd - must be specified - aborted."
 exit 1
fi
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "   FindAllIDinTerrs initiated from Make."
else
  ~/sysprocs/LOGMSG "   FindAllIDinTerrs initiated from Terminal."
fi
TEMP_PATH=$folderbase/temp
#
P1=$1
if [ -z "$P1" ]; then
 ~/sysprocs/LOGMSG "  FindAllIDinTerrs <propid> missing - abandoned."
 echo "  FindAllIDinTerrs <propid> missing - abandoned."
 exit 1
fi
#local_debug=0	# set to 1 for debugging
local_debug=1
#
if [ $local_debug = 1 ]; then
 pushd ./ > $TEMP_PATH/bitbucket.txt
 cd ~/Documents		# write files to Documents folder
fi
#procbodyhere
pushd ./ >> $TEMP_PATH/bitbucket.txt
cd $codebase/Projects-Geany/UpdateSCBridge
MY_PROJ='Territories'
echo "  FindAllIDinTerrs beginning processing."
#
error_counter=0		# set error counter to 0
IFS="&"			# set & as the word delimiter for read.
echo "" > ~/Documents/$P1.greplist.txt
echo "'$codebase/Projects-Geany/UpdateSCBridge/TIDList.txt'"
file=$codebase/Projects-Geany/UpdateSCBridge/TIDList.txt
i=0
fname=Terr
bridge=_SCBridge
dbend=_SC.db
echo "" > $TEMP_PATH/$P1.sqllist.txt
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
  elif [ "$firstchar" == "$" ];then			# end on $
   break
  else
   TID=${REPLY:0:len}
   skip=0
   if test -f $pathbase/$scpath/Terr$TID/OBSOLETE;then
    skip=1
    echo " ** Territory $TID OBSOLETE - skipping...**"
   fi
   if [ $skip -eq 0 ];then
    ~/sysprocs/LOGMSG "  grep $P1 $TID initiated."
#   echo "cd $pathbase/RawData/SCPA/SCPA-Downloads/$fname$TID"
    cd $pathbase/RawData/SCPA/SCPA-Downloads/$fname$TID
    DB_NAME=$fname$TID$dbend
    TBL_NAME=$fname$TID$bridge
    echo ".open $DB_NAME" > SQLTemp.sql
    echo "--.output '$TEMP_PATH/$P1.sqllist.txt';" >> SQLTemp.sql
    echo "SELECT OwningParcel, CongTerrID, " >> SQLTemp.sql
    echo " UnitAddress, Unit, SitusAddress FROM $TBL_NAME " >> SQLTemp.sql
    echo " WHERE OwningParcel IS '$P1';" >> SQLTemp.sql
    echo ".quit" >> SQLTemp.sql
    sqlite3 < SQLTemp.sql >> $TEMP_PATH/$P1.sqllist.txt
#   grep -e "$P1" -r -f *.db >> ~/Documents/$P1.greplist.txt
   fi		# skip=0
  fi     # end is comment line conditional
#
i=$((i+1))
done < $file
echo " $i TIDList.txt lines processed."
popd >> $TEMP_PATH/scratchfile
if [ $error_counter = 0 ]; then
  rm $TEMP_PATH/scratchfile
else
  echo "  $error_counter errors encountered - check $TEMP_PATH/scratchfile "
fi
#endprocbody
~/sysprocs/LOGMSG " FindAllIDinTerrs complete." >> $system_log
echo " 	FindAllIDinTerrs complete."
# end FindAllIDinTerrs.
