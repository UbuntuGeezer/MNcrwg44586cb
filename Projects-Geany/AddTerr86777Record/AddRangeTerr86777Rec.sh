#!/bin/bash
echo " ** AddRangeTerr86777Rec.sh out-of-date **";exit 1
echo " ** AddRangeTerr86777Rec.sh out-of-date **";exit 1
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
# AddRange86777Rec.sh - Add range of SC records to Terr86777.db.
#	6/5/22.	wmk.
#
# Usage.  bash AddRange86777Rec.sh <startID> <endID> <mm> <dd>
#
#	<startID> = starting property ID to add
#	<endID> = ending propertyID to add
#	<mm> = month of download data
#	<dd> = day of download data
#
# Exit. Terr86777.db table Terr86777 has new properties added.
#
# Modification Date.
# ------------------
# 6/5/22.	wmk.	original code.
# 3/26/23.	wmk.	documentation and error messages improved.
#
# Note. This is very useful when dealing with "special" territories
# where it is necessary to ensure that all condos or whatever have made
# it into the congregation territory database.
#
P1=$1		# starting ID
P2=$2		# ending ID
P3=$3		# month
P4=$4		# day
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ] || [ -z "$P4" ]; then
 echo " AddRange86777Rec <startID> <endID> mm dd missing parameter(s) - abandoned."
 exit 1
fi
if [ ${#P1} -ne 10 ]  || [ ${#P2} -ne 10 ];then
 echo " ** AddRangeTerr86777Rec property IDs MUST be 10 chars - abandoned."
 exit 1
fi
if [ $P1 -gt $P2 ];then
 echo " ** AddRangeTerr86777Rec id2 must be >= id1 - abandoned."
 exit 1
fi
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
 export pathbase = $folderbase/Territories/FL/SARA/86777
fi
TEMP_PATH=$HOME/temp
seq $P1 $P2 > $TEMP_PATH/IDList.txt
file=$TEMP_PATH/IDList.txt
projpath=$codebase/Projects-Geany/AddTerr86777Record
while read -e;do
 echo "processing $REPLY ..."
 len=${#REPLY}
 if [ $len -lt 10 ];then
  propid=0$REPLY
 else
  propid=$REPLY
 fi
 cd $projpath;./DoSed.sh $propid $P3 $P4
 make -f $projpath/MakeAddTerr86777Record
done < $file
echo "  AddRangeTerr86777Rec $P1  $P2 $P3 $P4 complete."
~/sysprocs/LOGMSG "  AddRangeTerr86777Rec $P1  $P2 $P3 $P4 complete."
# end AddRangeTerr86777Rec.
