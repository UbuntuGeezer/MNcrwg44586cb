#!/bin/bash
echo " ** AddMultiTerr86777Rec.sh out-of-date **";exit 1
echo " ** AddMultiTerr86777Rec.sh out-of-date **";exit 1
# AddMulti86777Rec.sh - Add range of SC records to Terr86777.db.
#	3/12/23.	wmk.
#
# Usage.  bash AddMulti86777Rec.sh <startID> <endID> <mm> <dd>
#
#	<mm> = month of download data
#	<dd> = day of download data
#
# Entry. *projpath/PIDList.txt = list of property IDs to add.
#
# Exit. Terr86777.db table Terr86777 has new properties added.
#
# Modification History.
# ---------------------
# 3/12/23.	wmk.	original code; adapted from AddRange86777Rec.
# Legacy mods.
# 6/5/22.	wmk.	original code.
# 9/23/22.  wmk.    (automated) CB *codebase env var support.
#
# Note. This is very useful when dealing with "special" territories
# where it is necessary to ensure that all condos or whatever have made
# it into the congregation territory database.
#
P3=$1
P4=$2
if [ -z "$P3" ] || [ -z "$P4" ]; then
 echo " Must specify  <mm> <dd>.. AddMulti86777Rec terminated."
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
#procbodyhere
projpath=$codebase/Projects-Geany/AddTerr86777Record
#seq $P1 $P2 > $TEMP_PATH/IDList.txt
cp -pv $projpath/PIDList.txt $TEMP_PATH/IDList.txt
addcount=0
file=$TEMP_PATH/IDList.txt
while read -e;do
 len=${#REPLY}
 frstchar=${REPLY:0:1}
 if [ "$frstchar" == "\$" ];then break;fi
 skipit=0
 if [ "$frstchar" == "#" ] || [ $len -eq 0 ];then skipit=1;fi
 if [ $skipit -eq 0 ];then
  echo "processing $REPLY ..."
  if [ $len -lt 10 ];then
   propid=0$REPLY
  else
   propid=$REPLY
  fi
  cd $projpath;./DoSed.sh $propid $P3 $P4
  make -f $projpath/MakeAddTerr86777Record
  addcount=$(($addcount+1))
 fi		# end skipit
done < $file
echo "  PIDList.txt processed (list of property IDs to add).."
echo "  $addcount records added."
echo "  AddMultiTerr86777Rec $P1  $P2 complete."
~/sysprocs/LOGMSG "  AddMultiTerr86777Rec $P1  $P2 complete."
# end AddMultiTerr86777Rec.
