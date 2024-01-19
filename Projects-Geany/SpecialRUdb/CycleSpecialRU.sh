#!/bin/bash
echo " ** CycleSpecialRU.sh out-of-date **";exit 1
echo " ** CycleSpecialRU.sh out-of-date **";exit 1
# CycleSpecialRU.sh - Cycle /Previous folder for special db.
# 12/5/22.	wmk.
#	Usage. bash CycleSpecialRU.sh <special-db>
#		<special-db> - name of special .db to cycle
#
# Dependencies.
#	Copies /Previous/<special-db>.db to <special-db>~.db in /Previous folder.
#	Copies /Previous/Fix.<special-db>.sql to Fix.<special-db>~.sql in
#	 /Previous folder.
#   Copies /Special/<special-db>.db to <special-db>.db in /Previous folder.
#	Copies Special/Fix.<special-db>.sql to Fix.<special-db>RU.sql in /Previous folder.
#	All these files are older versions for fixing future Special RU downloads.
#
# Modification History.
# ---------------------
# 9/23/22.  wmk.   (automated) CB *codebase env var support.
# 10/4/22.  wmk.   (automated) fix *pathbase for CB system.
# 12/5/22.	wmk.	exit processing for remain in Terminal; notify-send removed;
#			 -pv added to *cp*; comments tidied.
# Legacy mods.
# 4/24/22.	wmk.	code generalized for FL/SARA/86777;*pathbase*, 
#			 *congterr*, *conglib* env vars introduced.
# 5/31/22.	wmk.	P1 added to messages for batch run support; P1 not null
#			 check added.
# 5/31/22.	wmk.	documentation clarified.
# 6/17/22.	wmk.	-p option added to *cp* to preserve file date; notify-send
#			 removed.
# Legacy mods.
# 9/23/21.	wmk.	original shell; adapted from CyclePreviousRU.
# 10/27/21.	wmk.	bug fix Fix.<dbname>.sql superfluous '.' being added.
# 11/9/21.	wmk.	bug fix testing for Fix.<dbname>.sql; eliminate
#			 rm Fix.<dbname>.sql so Fix code preserved.
# 12/28/21.	wmk.	notify-send conditional; change to use $ USER env var.
#
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ];then
  export folderbase=/media/ubuntu/Windows/Users/Bill
 else
  export folderbase=$HOME
 fi
fi
if [ -z "$codebase" ];then
 codebase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories/FL/SARA/86777
fi
if [ -z "$congterr" ];then
 export congterr=FLSARA86777
fi
if [ -z "$conglib" ];then
 export conglib=FLsara86777
fi
#
P1=$1
if [ -z "$P1" ];then
 echo "  CycleSpecialRU <dbname> missing parameter - abandoned."
 read -p "Enter ctrl-c to remain in Terminal:"
 exit 1
fi
dbname=$P1
F_BASE=Special
FIX_BASE=Fix
FIX_SUFFX=.sql
FIX2_SUFFX=~.sql
DB_SUFFX=.db
DB2_SUFFX=~.db

FOLDER=$F_BASE		
F_NAME=$dbname$DB_SUFFX	
F2_NAME=$dbname$DB2_SUFFX	
F3_NAME=$FIX_BASE.$dbname$FIX_SUFFX	
F4_NAME=$FIX_BASE.$dbname$FIX2_SUFFX
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  bash ~/sysprocs/LOGMSG "   CyclePreviousRU initiated from Make."
  echo "   CyclePreviousRU initiated."
else
  bash ~/sysprocs/LOGMSG "   CyclePreviousRU initiated from Terminal."
  echo "   CyclePreviousRU initiated."
fi
TEMP_PATH=$HOME/temp
#
if [ -z "$P1" ]; then
  echo "  CycleSpecialRU ignored.. must specify <special-db>." >> $system_log #
  echo "  CycleSpecialRU ignored.. must specify <special-db>."
  read -p "Enter ctrl-c to remain in Terminal:"
  exit 1
fi
#
#procbodyhere
cd $pathbase/RawData/RefUSA/RefUSA-Downloads
if test -d ./$FOLDER/Previous ; then
#if cd ./$FOLDER/Previous ; then
  echo "   $FOLDER/Previous folder exists, proceeding.." >> $system_log
  echo "   $FOLDER/Previous folder exists, proceeding.."
else
  echo "   $FOLDER/Previous folder nonexistent - CyclePreviousRU abandoned." >> $system_log
  echo "   $FOLDER/Previous folder nonexistent - CyclePreviousRU abandoned."
  echo " Create $FOLDER/Prevous first."
  read -p "Enter ctrl-c to remain in Terminal:"
  exit 1
fi
#
if test -f $FOLDER/Previous/$F_NAME ; then
  mv $FOLDER/Previous/$F_NAME $FOLDER/Previous/$F2_NAME
fi
if test -f $FOLDER/$F_NAME;then cp -p $FOLDER/$F_NAME $FOLDER/Previous/$F_NAME 
 rm $FOLDER/$F_NAME;fi
#
#if ls $FOLDER/Previous/$F3_NAME >> $TEMP_PATH/bitbucket.txt; then
if test -f $FOLDER/Previous/$F3_NAME;then
  mv $FOLDER/Previous/$F3_NAME $FOLDER/Previous/$F4_NAME
fi
if test -f $FOLDER/$F3_NAME;then cp -p $FOLDER/$F3_NAME $FOLDER/Previous/$F3_NAME
 fi
# endprocbody
#
~/sysprocs/LOGMSG "   CycleSpecialRU $dbname complete."
echo "  CycleSpecialRU $TID complete."
#end CycleSpecialRU
