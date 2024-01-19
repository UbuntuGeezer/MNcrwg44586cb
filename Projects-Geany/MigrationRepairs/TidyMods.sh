#!/bin/bash
echo " ** TidyMods.sh out-of-date **";exit 1
echo " ** TidyMods.sh out-of-date **";exit 1
# TidyMods.sh - Tidy up Modification History in makefiles.
#	5/7/23.	wmk.
#
# Usage. bash  TidyMods.sh  <rawpath> <terrid>
#
#	<rawpath> = raw data path (e.g. *pathbase/*rupath)
#	<terrid> = territory ID
#
# Entry. <rawpath>/Make* files are makefiles with standardized headers.
#
# Dependencies.	/MigrationRepairs/awktidymods1.txt, awktidymods2.txt
#
# Exit. all Make files on path are udpated with automated header information
# and Modification History adjusted.
#
# Modification History.
# ---------------------
# 5/6/23.	wmk.	original shell.
# 5/7/23.	wmk.	mod to use *gawk for first pass to sort history; skip added
#			 if no makefiles present.
#
# Notes. 
#
# set parameters P1..Pn here..
#
P1=$1
P2=$2
if [ -z "$P1" ] || [ -z "$P2" ];then
 echo "TidyMods <rawpath> <terrid> missing parameter(s) - abandoned."
 exit 1
fi
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ]; then
  export folderbase=/media/ubuntu/Windows/Users/Bill
 else
  export folderbase=$HOME
 fi
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories/FL/SARA/86777
fi
if [ -z "$codebase" ];then
 export pathbase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "  TidyMods - initiated from Make"
  echo "  TidyMods - initiated from Make"
else
  ~/sysprocs/LOGMSG "  TidyMods - initiated from Terminal"
  echo "  TidyMods - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 . ~/GitHub/TerritoriesCB/Procs-Dev/SetToday.sh
#TODAY=2022-04-22
fi
#procbodyhere
projpath=$codebase/Projects-Geany/MigrationRepairs
fixpath=$P1/Terr$P2
pushd ./ > $TEMP_PATH/scratchfile
cd $fixpath
#echo "PWD = '$PWD'"
ls Make* > $TEMP_PATH/Makefiles.txt
if [ $? -ne 0 ];then
 echo "   Terr$P2 - no makefiles to process.. skipping"
 echo "  TidyMods $P1 $P2 complete."
 exit 0
fi
#cat $TEMP_PATH/Makefiles.txt
file=$TEMP_PATH/Makefiles.txt
# loop on all *Make files in folder *P1/Terr*P2.
while read -e;do
 currfn=$REPLY
 skip=0
 grep -e "(automated) move previous history" $currfn > $TEMP_PATH/scratchfile
 if [ $? -eq 0 ];then
  skip=1
  echo "   $currfn previously processed - skipping.."
 fi
 if [ $skip -eq 0 ];then
  echo "   processing $currfn..."
  sed "s?<filename>?$currfn?g" $projpath/awktidymods1.tmp > $projpath/awktidymods1.txt
  sed "s?<filename>?$currfn?g" $projpath/awktidymods2.tmp > $projpath/awktidymods2.txt
  gawk -f $projpath/awktidymods1.txt $currfn > $TEMP_PATH/PrevHist.txt
  mawk -f $projpath/awktidymods2.txt $currfn > $TEMP_PATH/$currfn.new
  cp -pv $TEMP_PATH/$currfn.new $currfn
 fi
done < $file
popd > $TEMP_PATH/scratchfile
#endprocbody
echo "  TidyMods $P1 $P2 complete."
~/sysprocs/LOGMSG "  TidyMods $P1 $P2 complete."
# end TidyMods.sh
