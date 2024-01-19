#!/bin/bash
echo " ** FlagRUUpdates.sh out-of-date **";exit 1
echo " ** FlagRUUpdates.sh out-of-date **";exit 1
# FlagRUUpdates.sh - Flag RU updates to RUtidList.txt
#	2/4/23.	wmk.
#
# Usage. bash  FlagRUUpdates.sh <startTID> <endTID>
#
#	<startTID> = (optional) starting territory ID
#	<endTID> = (optional, mandaory if <startTID> present) ending territory ID
#
# Entry. 
#
# Dependencies.
#
# Modification History.
# ---------------------
# 2/2/23.	wmk.	original shell (template)
#
# Notes. *make* can't handle *pushd/*popd so this goes into a .sh instead
# of a makefile.
#
P1=$1
P2=$2
doall=0
if [ -z "$P1" ];then
 doall=1
elif [ -z "$P2" ];then
 echo "FlagRUUPdates [<startTID> <endTID>] missing <endTID> - abandoned."
 read -p "Enter ctrl-c to remain in Terminal:"
 exit
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
if [ -z "rupath" ];then
 export rupath=RawData/RefUSA/RefUSA-Downloads
fi
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "  FlagRUUpdates - initiated from Make"
  echo "  FlagRUUpdates - initiated from Make"
else
  ~/sysprocs/LOGMSG "  FlagRUUpdates - initiated from Terminal"
  echo "  FlagRUUpdates - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 . ~/GitHub/TerritoriesCB/Procs-Dev/SetToday.sh
#TODAY=2022-04-22
fi
#procbodyhere
	export projpath=$codebase/Projects-Geany/FlagRUUpdates
	if test -f $projpath/RUtidlist.txt;then rm $projpath/RUtidlist.txt;fi
	touch $projpath/RUtidList.txt
	rusuffx=_RU.db
	oodcount=0
	# loop checking all /RefUSA-Downloads/Terryyy folders.
	pushd ./ > $TEMP_PATH/scratchfile
	cd $pathbase/$rupath
	if test -f $TEMP_PATH/AllRUTerrs.txt;then rm $TEMP_PATH/AllRUTerrs.txt;fi
	if [ $doall -gt 0 ];then
	 ls -d Terr* > $TEMP_PATH/AllRUTerrs.txt
	else
	 seq $P1 $P2 > $TEMP_PATH/NumList.txt
	 file=$TEMP_PATH/NumList.txt
	 while read -e;do
	  echo "Terr$REPLY" > $TEMP_PATH/AllRUTerrs.txt
	 done < $file
	fi
	file=$TEMP_PATH/AllRUTerrs.txt
	echo "0" > $TEMP_PATH/counter
	while read -e;do
	 TID=${REPLY:4:3}
	 justadded=0
	 if [ $pathbase/$rupath/Terr$TID/Terr$TID$rusuffx \
	  -ot $pathbase/$rupath/Terr$TID/Map$TID$rusuffx ];then \
	  echo "$TID" >> $projpath/RUtidlist.txt;oodcount=$((oodcount+1));justadded=1;fi
	 if [ $justadded -eq 0 ] & test -f $pathbase/$rupath/Terr$TID/SPECIAL;then \
	  . $projpath/FlagSpecRUUpdate.sh $TID;fi
	 if test -f $TEMP_PATH/counter;then read -e < $TEMP_PATH/counter; \
	  anum=${REPLY:0:2};oodcount=$((oodcount+anum)); \
	  if [ $anum -gt 0 ];then echo "$TID" >> $projpath/RUtidList.txt;fi;fi
	done < $file
	popd > $TEMP_PATH/scratchfile
	echo "  $oodcount territories out-of-date; *cat* RUtidList.txt for list." 
#endprocbody
echo "  FlagRUUpdates complete."
~/sysprocs/LOGMSG "  FlagRUUpdates complete."
# end FlagRUUpdates.sh
