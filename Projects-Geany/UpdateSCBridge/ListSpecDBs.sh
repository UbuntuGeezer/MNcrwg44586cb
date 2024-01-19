#!/bin/bash
echo " ** ListSpecDBs.sh out-of-date **";exit 1
# ListSpecDBs.sh - List territories using /Special dbs..
# 7/7/23.	wmk.
#
# Usage. bash  ListSpecDBs.sh  <terrid> [--full] [--silent]
#
# 	<terrid> = territory id using Special dbs.
#	[--full] = (optional) include terrid in listing.
#	[--silent] = (optional) suppress status messages.
#
# Entry. /SCPA-Downloads/Terr<terrid>/Updt<terrid>M.csv, Updt<terrid>P.csv
#	files' date stamps contain last FlagSCUpdates dates.
#
# Exit. Make.<spec-db>.Terr information output for <terrid>
#
# Modification History.
# ---------------------
# 7/7/23.	wmk.	original shell.
# 7/8/23.	wmk.	parameter documentation corrected; code simplified to
#			 use *grep for search; --full option support
#
# Notes. 
#
# P1=<terrid> P2=--full
#
export P1=$1
P2=${2,,}
P3=${3,,}
if [ -z "$P1" ];then
 echo "ListSpecDBs <terrid> [--full|-] [--silent] missing parameter(s) - abandoned."
 read -p "Enter ctrl-c to remain in Terminal: "
 exit 1
fi
showterr=0
if [ ! -z "$P2" ];then
 if [ "$P2" != "--full" ] && [ "$P2" != "-" ];then
  echo  "ListSpecDBs <terrid> [--full|-] unrecognized '--' option - abandoned."
  read -p "Enter ctrl-c to remain in Terminal: "
  exit 1
 elif [ "$P2" == "--full" ];then
  showterr=1
 fi
fi
domsg=1
if [ ! -z "$P3" ];then
 if [ "$P3" != "--silent" ];then
  echo  "ListSpecDBs <terrid> [--full|-] unrecognized '--' option - abandoned."
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
  ~/sysprocs/LOGMSG "  ListSpecDBs - initiated from Make"
   echo "  ListSpecDBs - initiated from Make"
  else
  ~/sysprocs/LOGMSG  -q "  ListSpecDBs - initiated from Make"
  fi
else
  if [ $domsg -ne 0 ];then
  ~/sysprocs/LOGMSG "  ListSpecDBs - initiated from Terminal"
   echo "  ListSpecDBs - initiated from Terminal"
  else
   ~/sysprocs/LOGMSG -q "  ListSpecDBs - initiated from Terminal"
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
cd $pathbase/$scpath/Special
# extract list of Make.<db-name>.Terr files.
# loop on list of Makefiles searching for Terrxxx.
# why not just use grep -rle "MAKE).*Terrxxx"?..
grep -rle "MAKE).*Terr$P1" --include "Make.*.Terr" > $TEMP_PATH/MakeList.txt
err=$?
if [ $err -ne 0 ];then
 if [ $domsg -ne 0 ];then
  echo ".SCPA-Downloads/Special - no Make*Terr files reference $P1" 
 fi
else
 if [ $showterr -eq 0 ];then
  mawk -F "." '{print $2}' $TEMP_PATH/MakeList.txt
 else
  mawk -F "." '{print ENVIRON["P1"] " " $2}' $TEMP_PATH/MakeList.txt
 fi
fi
popd > /dev/null
#endprocbody
if [ $domsg -ne 0 ];then
 ~/sysprocs/LOGMSG "  ListSpecDBs complete."
 echo "  ListSpecDBs complete."
else
 ~/sysprocs/LOGMSG -q "  ListSpecDBs complete."
fi
# end ListSpecDBs.sh
