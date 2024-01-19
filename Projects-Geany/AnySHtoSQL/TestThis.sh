#!/bin/bash
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
#BridgesToTerr.sh - Take SC and RU Bridge tables and generate territory.csv.
# 6/7/21.	wmk.
#	Usage. bash BridgesToTerr.sh <terrid> 
#		<terrid> - territory id or "tidlist"
#				   if "tidlist" then ../Projects-Geany/BridgesToTerr.TIDList.txt
#					has list of territory ids to generate the territories for.
#
# Notes. sleep added after DoSed to allow to complete before executing next line
# Dependencies.
#	RefUSA-Downloads/Terrxxx/Terrxxx_RU.db up-to-date.
#	SCPA-Downloads/Terrxxx/Terrxxx_SC.db up-to-date.
#	Uses [projects]/BridgesToTerr makefile to accomplish the following:
#	Clears territory xxx from PolyTerr/TerrProps and MultiMail/SplitProps.
#	Combines all owners in each SCBridge record.
#	Updates DONOTCALLs in SCBridge records.
#	Copies Bridge records from Terrxxx_RUBridge and Terrxxx_SCBridge to
#	  TerrProps and SplitProps.
#	Gets territory records into /TerrData/Terrxxx/Working-Files/QTerrxxx.db
#	  and sorts them properly.
#	Makes final pass ensuring DNCs are up-to-date.
#	Generates QTerrxxx.csv for use with LibreOffice/Calc to generate 
#	  territory spreadsheet.
#
# Modification History.
# ---------------------
# 5/19/21.	wmk.	updated for multihost support.
# 5/30/21.	wmk.	modified for multihost system support.
# 6/7/21.	wmk.	bug fixes; equality check ($)HOME, TEMP_PATH 
#					ensured set.
#jumpto function definition
function jumpto
{
    label=$1
    cmd=$(sed -n "/$label:/{:a;n;p;ba};" $0 | grep -v ':$')
    eval "$cmd"
    exit
}
if [ "$HOME" == "/home/bill" ]; then
 folderbase=$HOME
else 
 folderbase="$folderbase"
fi
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log="$folderbase/ubuntu/SystemLog.txt"
  TEMP_PATH="$HOME/temp"
  ~/sysprocs/LOGMSG "   BridgesToTerr.sh initiated from Make."
  echo "   BridgesToTerr initiated."
else
  ~/sysprocs/LOGMSG "   BridgesToTerr initiated from Terminal."
  echo "   BridgesToTerr initiated."
fi
# pathbase block.
# 5/30/22.
if [ -z "$codebase" ];then
 codebase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$pathbase" ];then
 if [ ! -z "$congpath" ];then
  export pathbase=$folderbase/Territories
 else
  export pathbase=$folderbase/Territories
 fi
fi
# end pathbase block.
TEMP_PATH=$HOME/temp
#
P1=$1
P2=$2
P3=$3
TID=${P1,,}
F_BASE="Terr"
FIX_BASE="Fix"
FIX_SUFFX="RU.sql"
FIX2_SUFFX="SC_0.sql"
DB_SUFFX="_RU.db"
DB2_SUFFX="_RU_0.db"
FOLDER=$F_BASE$TID					# Terryyy
F_NAME=$F_BASE$TID$DB_SUFFX			# Terryyy_RU.db
F2_NAME=$F_BASE$TID$DB2_SUFFX		# Terryyy_RU_0.db
F3_NAME=$FIX_BASE$TID$FIX_SUFFX		# FixyyyRU.sql
F4_NAME=$FIX_BASE$TID$FIX2_SUFFX	# FixyyySC_0.sql
#local_debug=0	# set to 1 for debugging
local_debug=1
if [ $local_debug = 1 ]; then
 echo "   processing $F_NAME $F2_NAME $F3_NAME $F4_NAME"
fi
#
if [ -z "$P1" ]; then
  echo "  BridgesToTerr ignored.. must specify <terrid>." >> $system_log #
  echo "  BridgesToTerr ignored.. must specify <terrid>."
  exit 1
fi
#
if [ $local_debug = 1 ]; then
 pushd ./ > $TEMP_PATH/bitbucket.txt
 cd ~/Documents		# write files to Documents folder
fi

#procbodyhere
pushd ./ >> $TEMP_PATH/bitbucket.txt
cd $pathbase/RawData/SCPA/SCPA-Downloads
#
case $TID in 
"tidlist" )
# fill in read of tidlist file here
 file='$codebase/Projects-Geany/BridgesToTerr/TIDList.txt'
 touch $file
while read -e; do
#cd $pathbase/RawData/SCPA/SCPA-Downloads
  len=${#REPLY}
  len1=$((len-1))
  firstchar=${REPLY:0:1}
  if [ "$firstchar" = "#" ]
  then			# skip comment
   echo >> $HOME/temp/scratchfile
  else
# process next territory ID..
  TID=$REPLY
  pushd ./ >> $TEMP_PATH/bitbucket.txt
  echo "   BridgesToTerr - processing $TID ..."
  cd $codebase/Projects-Geany/BridgesToTerr
  ./DoSed.sh $TID
  sleep 3
  make -f MakeBridgesToTerr
  ~/sysprocs/LOGMSG "   BridgesToTerr $TID complete."
  popd >> $TEMP_PATH/bitbucket.txt
#   echo $REPLY
 fi
 done < $file
 echo "   Done reading TIDList.txt." 
	;;
* )
  pushd ./ >> $TEMP_PATH/bitbucket.txt
  cd $codebase/Projects-Geany/BridgesToTerr
  ./DoSed.sh $TID 
  sleep 3
  make -f MakeBridgesToTerr
  ~/sysprocs/LOGMSG "   BridgesToTerr $TID complete."
  echo "   Copying all previous .sql files to $FOLDER/Previous..."
  popd >> $TEMP_PATH/bitbucket.txt
	;;
esac
# endprocbody
#

if [ $local_debug = 1 ]; then
  popd >> $TEMP_PATH/bitbucket.txt
  cd $codebase/Procs-Dev
#  echo $PWD
  jumpto EndProc
fi
#
#echo $PWD
popd >> $TEMP_PATH/bitbucket.txt
jumpto EndProc
EndProc:
#echo $PWD
notify-send "BridgesToTerr" "$TID complete."
bash ~/sysprocs/LOGMSG "   BridgesToTerr $TID complete."
echo "  BridgesToTerr $TID complete."
#end proc BridgesToTerr
