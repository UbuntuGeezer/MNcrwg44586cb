#!/bin/bash
echo " ** ListAllTerrUpdt.sh out-of-date **";exit 1
# ListAllTerrUpdt - List extended Updt* file info for TIDList territories.
# 7/7/23.	wmk.
#
# Usage. bash  ListAllTerrUpdt.sh
#
# Entry. TIDList.txt contains territory list. 
#
# Exit. SCPA-Downloads/Terrxxx/UpdtxxxM.csv, UpdtxxxP.csv -lh details output.
#
# Calls. ListTerrUpdt.sh
#
# Modification History.
# ---------------------
# 7/7/23.	wmk.	original shell.
#
# Notes. 
#
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
  ~/sysprocs/LOGMSG "  ListAllTerrUpdt - initiated from Make"
  echo "  ListAllTerrUpdt - initiated from Make"
else
  ~/sysprocs/LOGMSG "  ListAllTerrUpdt - initiated from Terminal"
  echo "  ListAllTerrUpdt - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 . ~/GitHub/TerritoriesCB/Procs-Dev/SetToday.sh
#TODAY=2022-04-22
fi
#procbodyhere
pushd ./ > /dev/null
if test -f $TEMP_PATH/UpdtList.txt;then rm $TEMP_PATH/UpdtList.txt;fi
cd $codebase/Projects-Geany/UpdateSCBridge
projpath=$codebase/Projects-Geany/UpdateSCBridge
export MY_PROJ=UpdateSCBridge
echo "  ListAllTerrUpdt beginning processing."
#
error_counter=0		# set error counter to 0
IFS="&"			# set & as the word delimiter for read.
file=$projpath/TIDList.txt
i=0
while read -e; do
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
  else
   TID=${REPLY:0:len1}
   $projpath/ListTerrUpdt.sh $TID >> $TEMP_PATH/UpdtList.txt
  fi	# end is comment conditional
#
i=$((i+1))
done < $file
#jumpto Finish
#Finish:
echo " $i TIDList.txt lines processed."
mawk '{if(substr($0,1,1) != " ")print;;}' $TEMP_PATH/UpdtList.txt
popd >  /dev/null
if [ $error_counter = 0 ]; then
  rm $TEMP_PATH/scratchfile
else
  echo "  $error_counter errors encountered - check $TEMP_PATH/scratchfile "
fi
#endprocbody
echo "  ListAllTerrUpdt complete."
~/sysprocs/LOGMSG "  ListAllTerrUpdt complete."
# end ListAllTerrUpdt.sh
