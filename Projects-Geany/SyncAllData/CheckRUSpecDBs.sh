#!/bin/bash
echo " ** CheckRUSpecDBs.sh out-of-date **";exit 1
echo " ** CheckRUSpecDBs.sh out-of-date **";exit 1
# CheckRUSpecDBs.sh -Check all RU /Special/<spec-db>.dbs against Terr86777.db
#	5/14/23.	wmk.
#
# Usage. bash  CheckRUSpecDBs.sh  [<spec-db> | -h]
#
#	<spec-db> = (optional) single RefUSA-Downloads/Special/<spec-db>.db to check
#	-h = (optional) display command help
#
# Entry.  /RefUSA-Downloads/Special/<spec-db1>.db .. <spec-dbn>.db present
#		  /DB-Dev/Terr86777.db = up-to-date SC county master data 
#
# Dependencies.
#
# Exit.	*thisproj/RUSpecOODlist.txt = list of out-of date RU <spec-db>.db,s
#		 compared against Terr86777.db records and against Specxxx_RU.csv
#		*thisproj/KillSync = semaphore file; if exists RUSpecOODlist.txt has entries.
#
# Modification History.
# ---------------------
# 2/5/23.	wmk.	original shell; adapted from CheckRUTerrs.
# 2/16/23.	wmk.	<start_tid> <end-tid> support.
# 2/17/23.	wmk.	parameters added to termination message.
# 2/27/23.	wmk.	bug fix; '-d' parameter removed from *ls command;
#			 *doall conditional added to *ls code.
# 3/22/23.	wmk.	bug fix date string to %s for comparison; correct date
#			 comparison; -h option support.
# 5/14/23.	wmk.	BLDLOG messaging added.
#
# Notes. This shell checks the <special-db>.db latest record date
# against the Terr86777.db latest record date. It also checks the
# <special-db>.db against the <special-db>.csv date. If either/both
# of the Terr86777.db or <special-db>.csv is newer, then the
# <special-db>.db is considered out-of-date.
#
# *make* can't handle *pushd/*popd so this goes into a .sh instead
# of a makefile.
#
P1=$1
H1=${P1^^}
if [ "$H1" == "-H" ];then
 echo "CheckRUSpecDBs [<spec-db> | -h ]"
 echo "    <spec-db> = (optional) single /Special DB to check"
 echo "    -h = (optional) display command help"
 echo "    if neither <spec-db> nor -h specified, check all Special dbs"
 echo ""
 echo "CheckRUSpecDBs checks the latest record date in the <spec-db>.db"
 echo " against Terr86777.db latest record date. It also checks the"
 echo " <spec-db>.csv against the <spec-db>.db date."
 exit 0
fi
doall=1
if [ ! -z "$P1" ];then
 doall=0
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
if [ -z "rupath" ];then
 export rupath=RawData/RefUSA/RefUSA-Downloads
fi
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "  CheckRUSpecDBs - initiated from Make"
  echo "  CheckRUSpecDBs - initiated from Make"
else
  ~/sysprocs/LOGMSG "  CheckRUSpecDBs - initiated from Terminal"
  echo "  CheckRUSpecDBs - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 . ~/GitHub/TerritoriesCB/Procs-Dev/SetToday.sh
#TODAY=2022-04-22
fi
#procbodyhere
	export projpath=$codebase/Projects-Geany/SyncAllData
	export thisproj=$codebase/Projects-Geany/SyncAllData
	if test -f $projpath/RUSpecOODlist.txt;then rm $projpath/RUSpecOODlist.txt;fi
	rusuffx=_RU.db
	mapsuffx=_RU.csv
	oodcount=0
	# loop checking all /RefUSA-Downloads/Special/<spec-db>.db files.
	pushd ./ > $TEMP_PATH/scratchfile
	cd $pathbase/$rupath/Special
	if test -f $TEMP_PATH/AllRUSpecDBs.txt;then rm $TEMP_PATH/AllRUSpecDBs.txt;fi
if [ $doall -gt 0 ];then
	ls *.db > $TEMP_PATH/AllRUSpecDBs.txt
else
	ls $P1.db > $TEMP_PATH/AllRUSpecDBs.txt
fi
	file=$TEMP_PATH/AllRUSpecDBs.txt
	echo "0" > $TEMP_PATH/counter
	while read -e;do
	 len=${#REPLY}
	 len1=$((len-1))
	 len3=$((len-3))
	 #specname=${REPLY:0:len-1}
	 specname=$REPLY
	 csvname=${REPLY:0:len3}
	 justdid=0
	 
if [ 1 -eq 0 ];then
#------------- old code just using file dates ------------------
	 # check against latest SC master Terr86777.db
	 pushd ./ > $TEMP_PATH/scratchfile
	 cd $projpath;./DoSed1.sh $pathbase/$rupath/Special $specname Spec_RUBridge
	 make -f MakeLastDwnldDate
	 # have *TEMP/PATH/LastDwnldDate.txt
	 ls -lh $pathbase/$rupath/Special/$specname > $TEMP_PATH/DBdate.txt
	 read -e $TEMP_PATH/DBdate.txt
	 date1=$REPLY
	 read -e $TEMP_PATH/LastDwnldDate.txt
	 date2=$REPLY
	 if [ "$date1" < "$date2" ];then\
	   echo "  ** $specname out-of-date **";\
	   echo "$specname - older than Terr86777.db" >> $thisproj/RUSpecOODlist.txt;\
	   oodcount=$((oodcount+1));fi
	 popd > $TEMP_PATH/scratchfile

if [ 1 -eq 0 ];then
	 if [ $pathbase/$rupath/Special/$specname \
	  -ot $pathbase/DB-Dev/Terr86777.db ];then \
	   echo "  ** $specname out-of-date **";\
	   echo "$specname - older than Terr86777.db" >> $thisproj/RUSpecOODlist.txt;\
	   oodcount=$((oodcount+1));fi
fi
	 popd > $TEMP_PATH/scratchfile
#---------- end old code just using file dates --------
fi
	 # check against latest SC master Terr86777.db
	 pushd ./ > $TEMP_PATH/scratchfile
	 cd $projpath;./DoSed1.sh $pathbase/$rupath/Special $specname Spec_RUBridge
	 make -f $projpath/MakeLatestDwnldDate
	 . ./LatestDwnldDate.sh
	 # have *TEMP/PATH/LatestDwnldDate.txt
	 ls -lh $pathbase/$rupath/Special/$specname > $TEMP_PATH/DBdate.txt
	 file=$TEMP_PATH/DBdate.txt
	 while read -e;do
 	  date1=$(echo $REPLY | mawk -F " " '{print $6}')
 	  break
	 done < $file
	 file=$TEMP_PATH/LatestDwnldDate.txt
	 while read -e;do
	  date2=$(echo $REPLY | mawk -F "," '{print $1}')
	 done < $file
	 #read -p "Enter ctrl-c to remain in Terminal"
	 #exit 0
     echo "$specname $date2"
     echo "Terr86777.db $date1"
         rdate1=$(date -d $date1 +%s)
         rdate2=$(date -d $date2 +%s)
	 if [ $rdate2 -lt $rdate1 ];then
	   echo "  ** $specname out-of-date **"
	   echo "$specname - older than Terr86777.db" >> $projpath/RUSpecOODlist.txt
	   ~/sysprocs/BLDMSG "$specname - older than Terr86777.db";oodcount=$((oodcount+1));fi
	 popd > $TEMP_PATH/scratchfile
	 if [ $specname -ot $csvname ];then
	   echo "  ** $specname/$csvname out-of-sync **"
	   echo "$specname - older than $csvname" >> $projpath/RUSpecOODlist.txt
	   ~/sysprocs/BLDMSG "$specname - older than $csvname";oodcount=$((oodcount+1));fi
	done < $file
	if [ $oodcount -gt 0 ];then
	 echo " ** $oodcount /Special/<spec-db>.db,s out-of-date **"
	 echo "  file RUSpecOODlist.txt contains list."
	 echo "  see also *build_log..."\
	 echo " CheckRUSpecDBs FAILED - list on RUSpecOODlist.txt" >> $thisproj/KillSync
	fi
	popd > $TEMP_PATH/scratchfile
	echo "  $oodcount <spec-db>.db,s out-of-date; *cat* RUSpecOODlist.txt for list." 
#endprocbody
echo "  CheckRUSpecDBs $P1 complete."
~/sysprocs/LOGMSG "  CheckRUSpecDBs $P1 complete."
# end CheckRUSpecDBs.sh
