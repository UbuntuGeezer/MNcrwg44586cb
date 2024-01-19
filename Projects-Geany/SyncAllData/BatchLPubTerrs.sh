#!/bin/bash
echo " ** BatchLPubTerrs.sh out-of-date **";exit 1
echo " ** BatchLPubTerrs.sh out-of-date **";exit 1
# BatchLPubTerrs.sh - Batch process publisher territories from local TIDList.txt.
# 6/26/23.	wmk.
#
# Usage. bash  BatchLPubTerrs.sh  <mm> <dd> [-nx]
#
#	<mm> = month of latest SCPA download
#	<dd> = day of latest SCPA download
#	-nx = (optional) if present suppress execution of soffice
#
# Entry. *projpath/TIDList.txt = list of territories to process
#	 *TEMP_PATH/autotids.txt = residual list of territories to run
#	 ProcessQTerrs12 on from prior BatchLPubTerrs runs. User will be
#	 prompted before removing. This allows batch runs to accumulate
#	 a build list for ProcessQTerrs12. 
#
# Dependencies.
#
# Modification History.
# ---------------------
# 3/12/23.	wmk.	original shell; adapted from BatchPubTerrs.
# 3/15/23.	wmk.	--silent added to *make call.
# 3/27/23.	wmk.	OBSOLETE territory detection.
# 6/26/23.	wmk.	bug fix - copy TIDList to 2 separate files so read does
#			 not resume in 1st list; fix $ detection in search list loop;
#			 use *pcount and *endcount to determine when *batchend is set.
#		 	 use -s in TIDList.txt test to force nonzero length file.
# Legacy mods.
# 3/5/23.	wmk.	original shell.
# 3/7/23.	wmk.	prompt user before removing autotids.txt; *run_soffice env
#			 var exported.
# 3/10/23.	wmk.	always rm PToodList.txt for new batch run.
#
# Notes. The environment var *batchrun is exported = 1 to flag downstream
# processes that a bath run of publisher territories is in progress.
# The environment var *run_soffice is exported to flag whether or not
# soffice.bin (LibreOffice) is executed in the final MakePubTerr recipe. 
#
# set parameters P1..Pn here..
#
P1=$1
P2=$2
P5=$3
if [ -z "$P1" ] || [ -z "$P2" ];then
 echo "BatchLPubTerrs <mm> <dd> [-nx] missing parameter(s) - abandoned."
 exit 1
fi
export run_soffice=1
if [ ! -z "$P5" ];then
 if [ "$P5" != "-nx" ];then
  echo "BatchLPubTerrs <mm> <dd> [-nx] invalid $P5 for -nx - abandoned."
  exit 1
 else
  export run_soffice=0
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
  ~/sysprocs/LOGMSG "  BatchLPubTerrs - initiated from Make"
  echo "  BatchLPubTerrs - initiated from Make"
else
  ~/sysprocs/LOGMSG "  BatchLPubTerrs - initiated from Terminal"
  echo "  BatchLPubTerrs - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 . ~/GitHub/TerritoriesCB/Procs-Dev/SetToday.sh
#TODAY=2022-04-22
fi
#procbodyhere
projpath=$codebase/Projects-Geany/SyncAllData
export batchrun=1
if test -f $projpath/RUoodList.txt;then
 echo "  list of territories for queued for RU update already exists..."
  read -p " Do you wish to clear it (y/n)? "
  yn=${REPLY^^}
  if [ "$yn" == "Y" ];then
   rm $projpath/RUoodList.txt
  fi
fi
if test -f $TEMP_PATH/autotids.txt;then
 echo "  list of territories for queued for generation already exists..."
  read -p " Do you wish to clear it (y/n)? "
  yn=${REPLY^^}
  if [ "$yn" == "Y" ];then
   rm $TEMP_PATH/autotids.txt
  else	# treat as though batch run
   export batchrun=1
  fi
fi
if test -f PToodList.txt;then rm PToodList.txt;fi
export batchend=0
#seq $P3 $P4 > $TEMP_PATH/PubTerrs.txt
if test -s TIDList.txt;then
 cp -pv TIDList.txt $TEMP_PATH/PubTerrs.txt
 cp -pv TIDList.txt $TEMP_PATH/PubTerrs1.txt 
else
 echo "  ** TIDList.txt missing for BatchLPubTerrs - abandoned."
 exit 1
fi
# count lines to determine *batchend.
file=$TEMP_PATH/PubTerrs.txt
export endcount=0
# get the last territory from the list; set in *endterr;
while read -e;do
 firstchr=${REPLY:0:1}
 if [ "$REPLY" == "" ] || [ "$firstchr" == "\$" ];then
  break
 else
  skipit=0
  if [ "$firstchr" == "#" ];then skipit=1;fi
  if [ $skipit -eq 0 ];then
   export endcount=$((endcount+1))
   #echo "in BatchLPubTerrs in counting loop..."
   #echo " endcount incremented = '$endcount'"
  fi
 fi 
done < $file
#echo "in BatchLPubTerrs out of counting loop..."
#echo " endcount = '$endcount'"
#read -p "Enter ctrl-c to exit BatchLPubTerrs: "
# loop on the following for each territory.
export pcount=0
#echo "BatchLPubTerrs entering loop..."
#echo " pcount = '$pcount'  endcount = '$endcount'"
#read -p "Enter ctrl-c to exit BatchLPubTerrs: "
nextfile=$TEMP_PATH/PubTerrs1.txt
while read -r;do
 TID=$REPLY
 firstchr=${REPLY:0:1}
# echo "in processing loop.. TID = '$TID'"
# sleep 5
 if [ "$TID" == "" ] || [ "$firstchr" == "$" ];then
  break
 fi
 skipit=0
 if [ "$firstchr" == "#" ];then skipit=1;fi
 if test -f $pathbase/$rupath/Terr$TID/OBSOLETE;then
  echo " Territory $TID is OBSOLETE, skipping..."
  skipit=1
 fi
 if [ $skipit -eq 0 ];then
  $projpath/DoSed.sh $P1 $P2  $TID $TID
  export pcount=$((pcount+1))
  export batchend=0
#   echo "in BatchLPubTerrs at batchend test..."
#   echo " pcount = '$pcount'  endcount = '$endcount'"
#  sleep 5
  if [ $pcount -eq $endcount ];then
   export batchend=1
  fi
  make  -f $projpath/MakePubTerr
 fi
done < $nextfile
#endprocbody
echo "  BatchLPubTerrs complete."
~/sysprocs/LOGMSG "  BatchLPubTerrs complete."
# end BatchLPubTerrs.sh
