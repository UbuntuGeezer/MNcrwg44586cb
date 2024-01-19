#!/bin/bash
echo " ** TerrSpecList.sh out-of-date **";exit 1
echo " ** TerrSpecList.sh out-of-date **";exit 1
# TerrSpecList.sh - generate list of territories using <spec-db>.
# 2/2/23.	wmk.
#
# Usage. bash  TerrSpecList.sh  <spec-db>
#
#	<spec-db> = name of /Special database (e.g. AuburnCoveCir.db or AuburnCoveCir)
#
# Entry. /Special/Make.<spec-db>.Terr = makefile for <spec-db> territories
#
# Dependencies.
#
# Exit.	*PWD/TerrSpecList.txt = list of territories using <spec-db>, one per line.
#
# Modification History.
# ---------------------
# 2/2/23.	wmk.	original shell (template)
#
# Notes. 
#
# set parameters P1..Pn here..
#
P1=$1	# <spec-db>
if [ -z "$P1" ];then
 echo "TerrSpecList <spec-db> missing parameter(s) - abandoned."
 exit 1
fi
patt='.*\.db'
if [[ "$P1" =~ $patt ]];then
 len=${#P1}
 len2=$((len-3))
 export dbfile=${P1:0:len2}
else
 export dbfile=$P1
fi
echo "Processing $dbfile..."
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ]; then
  folderbase=/media/ubuntu/Windows/Users/Bill
 else
  folderbase=$HOME
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
  ~/sysprocs/LOGMSG "  TerrSpecList - initiated from Make"
  echo "  TerrSpecList - initiated from Make"
else
  ~/sysprocs/LOGMSG "  TerrSpecList - initiated from Terminal"
  echo "  TerrSpecList - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 . ~/GitHub/TerritoriesCB/Procs-Dev/SetToday.sh
#TODAY=2022-04-22
fi
#procbodyhere
pushd ./ > $TEMP_PATH/scratchfile
targpath=$PWD
cd $pathbase/$rupath/Special
if test -f Make.$dbfile.Terr;then
 echo "found Make..Terr file"
 grep -e "(MAKE).*Terr" Make.$dbfile.Terr > $TEMP_PATH/templist.txt
 cat $TEMP_PATH/templist.txt
 mawk -F "/" 'BEGIN{db_file = ENVIRON["dbfile"]}{print db_file ".db," $2 ",0"}' \
  $TEMP_PATH/templist.txt > $targpath/TerrSpecList.txt
fi
popd > $TEMP_PATH/scratchfile
#endprocbody
echo "  TerrSpecList complete."
~/sysprocs/LOGMSG "  TerrSpecList complete."
# end TerrSpecList.sh
