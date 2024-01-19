#!/bin/bash
echo " ** ListAllSpecDBs.sh out-of-date **";exit 1
# ListAllSpecDBs - List all /Special dbs for territories in TIDList.
# 7/7/23.	wmk.
#
# Usage. bash  ListAllSpecDBs.sh  [--silent]
#
#	--silent = (optional) suppress status messages.
#
# Entry. TIDList.txt contains territory list. 
#
# Exit. List of /Special territories required for TIDList is output.
#
# Calls. ListTerrUpdt.sh
#
# Modification History.
# ---------------------
# 7/7/23.	wmk.	original shell.
#
# Notes. 
#
P1=${1,,}
domsg=1
if [ ! -z "$P1" ];then
 if [ "$P1" != "--silent" ];then
  echo "ListAllSpecials [--silent] unrecognized '--' option - abandoned."
  read -p "Enter ctrl-c to remain in Terminal: "
  exit 1
 else
  domsg=0
 fi
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
  if [ $domsg -ne 0 ];then
   ~/sysprocs/LOGMSG "  ListAllSpecDBs - initiated from Make"
   echo "  ListAllSpecDBs - initiated from Make"
  else
   ~/sysprocs/LOGMSG -q "  ListAllSpecDBs - initiated from Make"
  fi
else
  if [ $domsg -ne 0 ];then
   ~/sysprocs/LOGMSG "  ListAllSpecDBs - initiated from Terminal"
   echo "  ListAllSpecDBs - initiated from Terminal"
  else
    ~/sysprocs/LOGMSG -q "  ListAllSpecDBs - initiated from Terminal"
  fi
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 . ~/GitHub/TerritoriesCB/Procs-Dev/SetToday.sh
#TODAY=2022-04-22
fi
#procbodyhere
pushd ./ > /dev/null
if test -f $TEMP_PATH/SpecList.txt;then rm $TEMP_PATH/SpecList.txt;fi
cd $codebase/Projects-Geany/UpdateSCBridge
projpath=$codebase/Projects-Geany/UpdateSCBridge
export MY_PROJ=UpdateSCBridge
if [ $domsg -ne 0 ];then
 echo "  ListAllSpecDBs beginning processing."
fi
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
   TID=$REPLY
   if [ $domsg -ne 0 ];then
    echo "# processing $TID..."
   fi
   $projpath/ListSpecDBs.sh $TID --full --silent >> $TEMP_PATH/SpecList.txt
  fi	# end is comment conditional
#
i=$((i+1))
done < $file
#jumpto Finish
#Finish:
if [ $domsg -ne 0 ];then
 echo "# $i TIDList.txt lines processed."
fi
if test -s $TEMP_PATH/SpecList.txt;then
 mawk '{if(index("# ",substr($1,1,1)) == 0 )print;;}' $TEMP_PATH/SpecList.txt
# cat $TEMP_PATH/SpecList.txt
else
 echo "No /Special dbs for territories in TIDList.txt"
fi
popd >  /dev/null
if [ $error_counter = 0 ]; then
  rm $TEMP_PATH/scratchfile
else
  echo "  $error_counter errors encountered - check $TEMP_PATH/scratchfile "
fi
#endprocbody
if [ $domsg -ne 0 ];then
 echo "  ListAllSpecDBs complete."
 ~/sysprocs/LOGMSG "  ListAllSpecDBs complete."
else
 ~/sysprocs/LOGMSG  -q "  ListAllSpecDBs complete."
fi
# end ListAllSpecDBs.sh
