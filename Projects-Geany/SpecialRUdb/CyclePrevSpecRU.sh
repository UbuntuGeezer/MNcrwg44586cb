#!/bin/bash
echo " ** CyclePrevSpecRU.sh out-of-date **";exit 1
echo " ** CyclePrevSpecRU.sh out-of-date **";exit 1
#CyclePrevSpecRU.sh - Cycle to /Previous folder for <special-db>.
#	12/5/22.	wmk.
#	Usage. bash CyclePrevSpecRU.sh <special-db>
#		<special-db> - special db to cycle (no .db extension)
#
# Dependencies.
#	Copies /Previous/<special-db>.db to <special-db>~.db in /Previous folder.
#	Copies /Previous/Fix.<special-db>.sql to Fix.<special-db>~.sql in
#			 /Previous folder.
#   Copies <special-db>.db to <special-db>.db in /Previous folder.
#	Copies Fix.<special-db>.sql to Fix.<special-db>.sql in /Previous folder.
#	All these files are older versions for fixing future <special-db> RU
#	 downloads.
#
# Modification History.
# ---------------------
# 12/5/22.	wmk.	exit processing for remain in Terminal; notify-send removed;
#			 -pv added to *cp*; comments tidied.
# Legacy mods.
# 4/24/22.	wmk.	code generalized for FL/SARA/86777;*pathbase*, 
#			 *congterr*, *conglib* env vars introduced.
# 9/23/22.  wmk.   (automated) CB *codebase env var support.
# 10/4/22.  wmk.   (automated) fix *pathbase for CB system.
# Legacy mods.
# 12/7/21.	wmk.	original shell.
# 12/28/21.	wmk.	notify-send conditional; change to use $ USER env var.
#
# Notes. uses -ot comparison that will compare the dates of 2 files.
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

PTH_BASE=$pathbase/RawData/RefUSA/RefUSA-Downloads
DB_NAME=$P1
FIX_BASE=Fix.
FIX_SUFFX=.sql
FIX2_SUFFX=~.sql
DB_SUFFX=.db
DB2_SUFFX=~.db

FOLDER=Special		
F_NAME=$DB_NAME$DB_SUFFX	
F2_NAME=$DB_NAME$DB2_SUFFX	
F3_NAME=$FIX_BASE$DB_NAME$FIX_SUFFX	
F4_NAME=$FIX_BASE$DB_NAME$FIX2_SUFFX
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  bash ~/sysprocs/LOGMSG "   CyclePrevSpecRU initiated from Make."
  echo "   CyclePrevSpecRU initiated."
else
  bash ~/sysprocs/LOGMSG "   CyclePrevSpecRU initiated from Terminal."
  echo "   CyclePrevSpecRU initiated."
fi
TEMP_PATH=$HOME/temp
#
if [ -z "$P1" ]; then
  echo "  CyclePrevSpecRU ignored.. must specify <spec-db>." >> $system_log #
  echo "  CyclePrevSpecRU ignored.. must specify <spec-db>."
  read -p "Enter ctrl-c to remain in Terminal:"
  exit 1
fi
#
#procbodyhere
cd $pathbase/RawData/RefUSA/RefUSA-Downloads
if test -d ./$FOLDER/Previous ; then
#if cd ./$FOLDER/Previous ; then
  echo "   Special/Previous folder exists, proceeding.." >> $system_log
  echo "   Special/Previous folder exists, proceeding.."
else
  echo "   Special/Previous folder nonexistent - CyclePrevSpecRU abandoned." >> $system_log
  echo "   Special/Previous folder nonexistent - CyclePrevSpecRU abandoned."
  echo " Run CyclePrevSpecRU.sh first."
  read -p "Enter ctrl-c to remain in Terminal:"
  exit 1
fi
cd $PTH_BASE
# see if Fix.. files exist first..
if test -f $PTH_BASE/$FOLDER/$F_NAME; then
  if test -f $PTH_BASE/$FOLDER/Previous/$F_NAME  \
   && [ $PTH_BASE/FOLDER/Previous/$F_NAME -ot $PTH_BASE/$FOLDER/$F_NAME ]; then
   if test -f $PTH_BASE/$FOLDER/Previous/$F2_NAME ; then
    if [ $PTH_BASE/$FOLDER/Previous/$F2_NAME -ot  \
       $PTH_BASE/$FOLDER/Previous/$F_NAME ];then
     mv $PTH_BASE/$FOLDER/Previous/$F_NAME $PTH_BASE/$FOLDER/Previous/$F2_NAME
    fi
   fi
  fi
  cp $PTH_BASE/$FOLDER/$F_NAME $PTH_BASE/$FOLDER/Previous/$F_NAME
fi
#
  #if ls $FOLDER/Previous/$F3_NAME >> $TEMP_PATH/bitbucket.txt; then
if test -f PTH_BASE/$FOLDER/Previous/$F3_NAME;then
  if test -f PTH_BASE/$FOLDER/Previous/$F4_NAME \
   && [ $PTH_BASE/FOLDER/Previous/$F4_NAME -ot $PTH_BASE/$FOLDER/$F3_NAME ]; then
   if test -f $PTH_BASE/$FOLDER/Previous/$F4_NAME ; then
    if [ $PTH_BASE/$FOLDER/Previous/$F4_NAME -ot  \
       $PTH_BASE/$FOLDER/Previous/$F3_NAME ];then
     mv $PTH_BASE/$FOLDER/Previous/$F3_NAME TH_BASE/$FOLDER/Previous/$F4_NAME
    fi
   fi
  fi
  cp -pv $PTH_BASE/$FOLDER/$F3_NAME $PTH_BASE/$FOLDER/Previous/$F3_NAME
fi
#
# endprocbody
#
bash ~/sysprocs/LOGMSG "   CyclePrevSpecRU $DB_NAME complete."
echo "  CyclePrevSpecRU $DB_NAME complete."
#end CyclePrevSpecRU
