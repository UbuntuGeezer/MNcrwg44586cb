#!/bin/bash
echo " ** CheckSCTerrs.sh out-of-date **";exit 1
echo " ** CheckSCTerrs.sh out-of-date **";exit 1
# <filename>.sh - <description>.
# 2/2/23.	wmk.
#
# Usage. bash  <filename>.sh
#
# Entry. 
#
# Dependencies.
#
# Modification History.
# ---------------------
# 2/2/23.	wmk.	original shell (template)
#
# Notes. 
#
# set parameters P1..Pn here..
#
P1=$1
P2=$2
if [ -z "$P1" ] || [ -z "$P2" ];then
 echo "<filename> <mm> <dd> missing parameter(s) - abandoned."
 exit 1
fi
fi
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
  ~/sysprocs/LOGMSG "  <filename> - initiated from Make"
  echo "  <filename> - initiated from Make"
else
  ~/sysprocs/LOGMSG "  <filename> - initiated from Terminal"
  echo "  <filename> - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 . ~/GitHub/TerritoriesCB/Procs-Dev/SetToday.sh
#TODAY=2022-04-22
fi
#procbodyhere
	oops=0
	remake=0
	oodcount=0		# out-of-date counter
	namesuffx=_SC.db
	pushd ./ > $$TEMP_PATH/scratchfile
	cd $$pathbase/$$scpath
	ls -d Terr* > $(thisproj)/SCTerrList.txt
	file=$(thisproj)/SCTerrList.txt
	# loop on all SCPA-Downloads/Terrxxx folders checking Terrxxx_SCdb
	#  date against Terr86777.db date.
	while read -e;do
	  Terr=$REPLY
	  SCdbName=$$Terr$$namesuffx
	  if [ $$pathbase/DB-Dev/Terr86777.db -nt $$pathbase/$$scpath/$$Terr/$$SCdbName ];then \
	   echo "  ** $$SCdbname out-of-date **";\
	   echo "$$SCdbName" >> $(thisproj)/SCoodList.txt;oodcount=$$((oodcount+1));fi
	done < $$file
	if [ $$oodcount -gt 0 ];then \
	 echo " ** $$oodcount SCPA territories out-of-date **";echo "  file SCoodList.txt contains list.";fi
	popd > $$TEMP_PATH/scratchfile
#endprocbody
echo "  <filename> complete."
~/sysprocs/LOGMSG "  <filename> complete."
# end <filename>.sh
