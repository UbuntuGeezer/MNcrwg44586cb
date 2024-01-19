#!/bin/bash
# DefineSegs.sh - Define tertitory segments in TerrIDData.db.
#	2/12/23.	wmk.
#
# Usage. bash  DefineSegs.sh  <terrid>  <spec-db>|SCPA <mm> <dd>
#
#	<terrid> = territory ID
#	<spec-db> = special database name (without .db suffix)
#	<mm> = month if <spec-db> is 'SCPA'
#	<dd> = day if <spec-db> is 'SCPA
#		_<mm>-<dd> will be added to dbName if SCPA
#
# Entry. *rupath/Terrxxx/segdefs.csv contains segment definitions
#		 *scpath/Terrxxx/segdefs.csv contains segment definitions if
#			<spec-db> = 'SCPA'
# Exit.  /DB-Dev/TerrIDData.db updated as follows:
#			Territory.Segmented = 1 for <terrid>
#			SegDefs.sqldef entries made for all segment definitions
#
#		if the LoadSegDefs process failed, the semaphore file *loadsegsfailed*
#		 will be present in the *rupath/Special folder.
#
# Dependencies.
#
# Modification History.
# ---------------------
# 2/2/23.	wmk.	original shell (template)
#
# Notes. DefineSegs goes through the build process for both LoadSegDefs and
# AddSegDefs.  
#
# set parameters P1..Pn here..
#
P1=$1		# terrID
P2=$2		# <spec-db>
P3=$3		# <mm> for SCPA db
P4=$4		# <dd> for SCPA db
if [ -z "$P1" ] || [ -z "$P2" ];then
 echo "DefineSegs terrid <spec-db>|SCPA <mm> <dd> missing parameter(s) - abandoned."
 exit 1
fi
pars=${2:0:4}
db4chr=${pars^^}
if [ "$db4chr" == "SCPA" ];then
 if [ -z "$P3" ] || [ -z "$P4" ];then
  echo "DefineSegs <terrid> SCPA <mm> <dd> missing parameter(s) - abandoned."
  exit 1
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
  ~/sysprocs/LOGMSG "  DefineSegs - initiated from Make"
  echo "  DefineSegs - initiated from Make"
else
  ~/sysprocs/LOGMSG "  DefineSegs - initiated from Terminal"
  echo "  DefineSegs - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 . ~/GitHub/TerritoriesCB/Procs-Dev/SetToday.sh
#TODAY=2022-04-22
fi
#procbodyhere
pushd ./ > $TEMP_PATH/scratchfile
projpath=$codebase/Projects-Geany/SegDefsMgr
cd $projpath
./DoSedSegDefs.sh   $P1  $P2 $P3 $P4
make -f MakeLoadSegDefs
make -f MakeAddSegDefs
popd > $TEMP_PATH/scratchfile
#endprocbody
echo "  DefineSegs $P1 $P2 $P3 $P4 complete."
~/sysprocs/LOGMSG "  DefineSegs $P1 $P2 $P3 $P4 complete."
# end DefineSegs.sh# end DefineSegs.sh
