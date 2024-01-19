#!/bin/bash
echo " ** CheckSpecRUTerrs.sh out-of-date **";exit 1
echo " ** CheckSpecRUTerrs.sh out-of-date **";exit 1
# CheckSpecRUTerrs.sh - Check Special RU territories up-to-date.
# 5/14/23.	wmk.
#
# Usage. bash  CheckSpecRUTerrs.sh  [<start-tid> <end-tid>]
#
# Entry.  SyncAllData/RUTerrList.txt contains list of territories that use a
#			given RefUSA-Downloads/<spec-db>.db
#			 
# Dependencies.
#
# Exit.	*thisproj/RUoodList.txt = list of out-of date territories
#		*thisproj/KillSync = semaphore file; if exists RUoodList.txt has entries.
#
# Modification History.
# ---------------------
# 2/2/23.	wmk.	original shell.
# 2/16/23.	wmk.	<start_tid> <end-tid> support.
# 2/17/23.	wmk.	parameters added to termination message.
# 3/25/23.	wmk.	bug fix '.' as *mawk separator generating SpecDBList;
#		 	 bug fix *specdbname truncated; bug fix *thispath corrected to *thisproj;
#		 	 change logic in filedate comparison to use -nt instead of -ot.
# 5/14/23.	wmk.	BLDMSG messages added; remove comments from P1, P2 set commands.
# Notes. 
#
# set parameters P1..Pn here..
# P1 = start terr ID
# P2 = end terr ID
P1=$1
P2=$2
doall=0
if [ -z "$P1" ];then
 doall=1
elif [ -z "$P2" ];then
 echo " CheckSpecRUTerrs [<startTID> <endTID>] missing <endTID> - abandoned."
 read -p "Enter ctrl-c to remain in Terminal:"
 exit
fi
#
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
  ~/sysprocs/LOGMSG "  CheckSpecRUTerrs - initiated from Make"
  echo "  CheckSpecRUTerrs - initiated from Make"
else
  ~/sysprocs/LOGMSG "  CheckSpecRUTerrs - initiated from Terminal"
  echo "  CheckSpecRUTerrs - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 . ~/GitHub/TerritoriesCB/Procs-Dev/SetToday.sh
#TODAY=2022-04-22
fi
#procbodyhere
	thisproj=$codebase/Projects-Geany/SyncAllData
	oops=0
	remake=0
	oodcount=0		# out-of-date counter
	namesuffx=_RU.db
	csvsuffx=_RU.csv
	if test -f $thisproj/RUTerrList.txt;then rm $thisproj/RUTerrList.txt;fi
	pushd ./ > $TEMP_PATH/scratchfile
	cd $pathbase/$rupath
	if [ $doall -ne 0 ];then
	 ls -d Terr* > $thisproj/RUTerrList.txt
	 sed -in '/TerrFixList/d' $thisproj/RUTerrList.txt
	else
	 seq $P1 $P2 > $TEMP_PATH/NumList.txt
	 file=$TEMP_PATH/NumList.txt
	 while read -e;do
	  echo "Terr$REPLY" >> $thisproj/RUTerrList.txt
	 done < $file
	fi
	file=$thisproj/RUTerrList.txt
	# loop on all RefUSA-Downloads/Terrxxx folders checking Terrxxx_RUdb
	#  date against  <spec-db>.db date.
	while read -e;do
	  TID=${REPLY:4:3}
  	  skip=0
  	  if [ $doall -eq 0 ];then
   		if [ $TID -lt $P1 ] || [ $TID -gt $P2 ];then
    	 skip=1
   		fi
  	  fi
  	  # skip if not a SPECIAL territory.
  	  if ! test -f $pathbase/$rupath/$REPLY/SPECIAL;then
   		skip=1
  	  fi
  	  if [ $skip -eq 0 ];then
 	   echo "  Processing Territory $TID..."
	   Terr=Terr$TID
	   Spec=Spec$TID
	   RUdbName=$Spec$namesuffx
	   csvName=$Spec
	   pushd ./ > $TEMP_PATH/scratchfile
	   cd $pathbase/$rupath/Special
	   Spec=Spec
	   specsuffx=.db
	   grep -re "(MAKE).*$Terr" --include "Make*.Terr" > $TEMP_PATH/RUMakes.txt
	   if [ $? -eq 0 ];then\
	    mawk -F "." '{print $2}' $TEMP_PATH/RUMakes.txt > $TEMP_PATH/SpecDBList.txt;\
	    file2=$TEMP_PATH/SpecDBList.txt;\
	    while read -e;do\
	     len=${#REPLY}
	     len1=$((len-1))
	     specdb=${REPLY:0:len}
	     echo "  Processing "$specdb"..."
	     #
	     if test -f $pathbase/$rupath/$Terr/SPECIAL;then \
	      if [ $pathbase/$rupath/Special/$specdb.db -nt $pathbase/$rupath/$Terr/$RUdbName ];then \
	       echo "  ** $RUdbName out-of-date **";\
	       ~/sysprocs/BLDMSG "$RUdbName - older than $specdb.db. "; \
  	       echo "$RUdbName - older than $specdb.db " >> $thisproj/RUoodList.txt;oodcount=$((oodcount+1));fi;fi
         if test -f $pathbase/$rupath/$Terr/SPECIAL;then \
	      if [ $pathbase/$rupath/$Terr/$RUdbName -ot $pathbase/$rupath/$Terr/$csvName$csvsuffx ];then \
	       echo "  ** $RUdbName/$csvName$csvsuffx out-of-sync **";\
	       ~/sysprocs/BLDMSG "$RUdbName - older than $specdb.db."; \
  	       echo "$RUdbName - older than $specdb.db " >> $thisproj/RUoodList.txt;oodcount=$((oodcount+1));fi;fi
  	    done < $file2;fi
  	    # end loop on special db list.
	  popd  > $TEMP_PATH/scratchfile
      fi # skip
	done < $file
	# end territory ID loop.
    if [ $oodcount -gt 0 ];then \
     echo " ** $oodcount RefUSA special territories out-of-date. **";\
	 echo "  *cat file RUoodList.txt to view list.";\
	 echo "  also check *build_log..."; \
	 echo " CheckSpecRUTerrs FAILED - list on RUoodList.txt" >> $thisproj/KillSync;fi
	popd > $TEMP_PATH/scratchfile
#endprocbody
echo "  CheckSpecRUTerrs $P1 $P2 complete."
~/sysprocs/LOGMSG "  CheckSpecRUTerrs $P1 $P2 complete."
# end CheckSpecRUTerrs.sh
