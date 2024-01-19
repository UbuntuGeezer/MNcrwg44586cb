#!/bin/bash
echo " ** ListTerrSpecDBs.sh out-of-date **";exit 1
# ListTerrSpecDBs.sh - List SC /Special dbs used by territory.
# 7/7/23.	wmk.
#
# Usage. bash  ListTerrSpecDBs.sh <terrid>
#
# Entry. *scpath/Special/Make.<spec-db>.Terr = makefile for <spec-db>s.
#
# Exit.	list of .db statements accessing /Special dbs. output
#
# Modification History.
# ---------------------
# 7/7/23.	wmk.	original shell; adapted from UpdateRUDwnlds version.
#
# Notes. 
#
# P1=<terrid>
#
echo "ListTerrSpecDBs.sh - use ListSpecDBs.sh"
read -p "Enter ctrl-c to remain in Terminal: "
exit 1
export P1=$1
if [ -z "$P1" ];then
 echo "ListTerrSpecDBs <terrid> missing parameter(s) - abandoned."
 read -p "Enter ctrl-c to remain in Terminal: "
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
  ~/sysprocs/LOGMSG "  ListTerrSpecDBs - initiated from Make"
  echo "  ListTerrSpecDBs - initiated from Make"
else
  ~/sysprocs/LOGMSG "  ListTerrSpecDBs - initiated from Terminal"
  echo "  ListTerrSpecDBs - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 . ~/GitHub/TerritoriesCB/Procs-Dev/SetToday.sh
#TODAY=2022-04-22
fi
#procbodyhere
projpath=$codebase/Projects-Geany/UpdateSCBridge
pushd ./ > /dev/null
if test -f $TEMP_PATH/DBTerrsList.txt;then rm $TEMP_PATH/DBTerrsList.txt;fi
cd $pathbase/$scpath/Special
utilpath=$pathbase/$scpath/Special
ls Make.*.Terr > $TEMP_PATH/MakeList.txt
mawk -F "." '{print $2}' $TEMP_PATH/MakeList.txt > $TEMP_PATH/SpecList.txt
#loop on *TEMP_PATH/SpecList.txt
error_counter=0		# set error counter to 0
IFS="&"			# set & as the word delimiter for read.
file=$TEMP_PATH/SpecList.txt
i=0
while read -e; do
  if [ $i -gt 0 ];then break;fi
  #reading each line
  echo -e " processing $REPLY " >> $TEMP_PATH/scratchfile
  len=${#REPLY}
  len1=$((len-1))
  firstchar=${REPLY:0:1}
#  echo -e "  $firstchar\n is first char of line." >> $HOME/temp/scratchfile
  #expr index $string $substring
  if [ "$firstchar" == "#" ] || [ $len -eq 0 ];then		# skip comment
   echo $REPLY >> $folderbase/temp/scratchfile
  elif [ "$firstchar" == "\$" ]; then
   break
  elif [ $len -eq 0 ];then
   echo $REPLY >> $folderbase/temp/scratchfile	# skip empty line
  else
   dbname=$REPLY
   dbname=TarponCenterDr
   #echo "  processing $dbname..."
   $utilpath/ListDBTerrs.sh $dbname --full >> $TEMP_PATH/DBTerrsList.txt
   #mawk '{if ("$1" ~ /$MAWK/ )print $3;;}' Make.$dbname.Terr
   #$projpath/ListTerrUpdt.sh $TID >> $TEMP_PATH/UpdtList.txt
  fi	# end is comment conditional
#
i=$((i+1))
done < $file
#
#echo "cat of DBTerrsList.txt follows..."
#cat $TEMP_PATH/DBTerrsList.txt
if test -s $TEMP_PATH/DBTerrsList.txt;then
 #mawk '{print $2}' $TEMP_PATH/DBTerrsList.txt
 mawk '{if(index($2,ENVIRON["P1"]) > 0)print;;}' $TEMP_PATH/DBTerrsList.txt
fi
exit 0
if ! test -f Terr$P1/RegenSpecDB.sql;then
 echo " Territory $P1 uses no /Special .db,s."
 read -p "Enter ctrl-c to remain in Terminal: "
 exit 0
fi
grep -e "'.*\.db" -r Terr$P1 --include "RegenSpecDB.sql" > $TEMP_PATH/dbSQLs.txt
sed "s?<terrid>?$P1?g" $projpath/awkfilterspecdbs.tmp > $projpath/awkfilterspecdbs.txt
mawk -f $projpath/awkfilterspecdbs.txt $TEMP_PATH/dbSQLs.txt
popd > /dev/null
#endprocbody
echo "  ListTerrSpecDBs $P1 complete."
~/sysprocs/LOGMSG "  ListTerrSpecDBs $P1 complete."
# end ListTerrSpecDBs.sh
