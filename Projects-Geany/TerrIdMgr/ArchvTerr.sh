#!/bin/bash
# ArchvTerr.sh - Archive territory rawdata folders.
# 2/2/23.	wmk.
#
# Usage. bash  ArchvTerr.sh <terrid>
#
#	<terrid> = territory ID to archive
#
# Entry. 
#
# Exit.	RefUSA-Downloads/Terrxxx, SCPA-Downloads/Terrxxx, and
# TerrData/Terrxxx folders all compressed into a .zip file in the
# territory folder. 
#	RefUSA-Downloads/Terrxxx/OBSOLETE, SCPA-Downloads/Terrxxx/OBSOLETE,
#	and TerrData/Terrxxx/OBSOLETE files "touched".
#
# Dependencies.
#
# Modification History.
# ---------------------
# 2/2/23.	wmk.	original shell (template)
#
# Notes.  ArchvTerr takes the /RefUSA-Downloads/Terrxxx,
# SCPA-Downloads/Terrxxx, and TerrData/Terrxxx folders and archives them
# by consolidating all files into Terrxxx.zip in the main folder
# and adding the file 'OBSOLETE' into the main folder. This flags the
# territory as obsolete, so it will be ignored by any project builds.
#
#
P1=$1
if [ -z "$P1" ];then
 echo "ArchvTerr <terrid> missing parameter(s) - abandoned."
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
  ~/sysprocs/LOGMSG "  ArchvTerr - initiated from Make"
  echo "  ArchvTerr - initiated from Make"
else
  ~/sysprocs/LOGMSG "  ArchvTerr - initiated from Terminal"
  echo "  ArchvTerr - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 . ~/GitHub/TerritoriesCB/Procs-Dev/SetToday.sh
#TODAY=2022-04-22
fi
#procbodyhere
terrname=Terr$P1
# archive along RefUSA path.
if ! test -d $pathbase/$rupath/$terrname;then
 echo "$rupath/$terrname not found - skipping.."
else
 cd $pathbase/$rupath/$terrname
 if test -f $terrname.zip;then
  echo "$rupath/$terrname already archived- skipping.."
 else
  echo "Archiving $rupath/$terrname..."
  zip $TEMP_PATH/$terrname.zip *
  rm *
  if test -d ./Previous;then
   rm -r Previous
  fi
  cp -pv $TEMP_PATH/$terrname.zip ./
  rm $TEMP_PATH/$terrname.zip
  touch OBSOLETE
 fi
fi 	# end ru/Terrxxx missing
# archive along SCPA path.
if ! test -d $pathbase/$scpath/$terrname;then
 echo "$scpath/$terrname not found - skipping.."
else
 cd $pathbase/$scpath/$terrname
 if test -f $terrname.zip;then
  echo "$scpath/$terrname already archived- skipping.."
 else
  echo "Archiving $scpath/$terrname..."
  zip $TEMP_PATH/$terrname.zip *
  rm *
  if test -d ./Previous;then
   rm -r Previous
  fi
  cp -pv $TEMP_PATH/$terrname.zip ./
  rm $TEMP_PATH/$terrname.zip
  touch OBSOLETE
 fi
fi 	# end sc/Terrxxx missing
# archive along TerrData path.
if ! test -d $pathbase/TerrData/$terrname;then
 echo "TerrData/$terrname not found - skipping.."
else
 cd $pathbase/TerrData/$terrname
 if test -f $terrname.zip;then
  echo "TerrData/$terrname already archived- skipping.."
 else
  echo "Archiving TerrData..."
  zip $TEMP_PATH/$terrname.zip *
  rm *
  if test -d ./Working-Files;then
   rm -r Working-Files
  fi
  cp -pv $TEMP_PATH/$terrname.zip ./
  rm $TEMP_PATH/$terrname.zip
  touch OBSOLETE
 fi
fi 	# end TerrData/Terrxxx missing
#endprocbody
echo "  ArchvTerr complete."
~/sysprocs/LOGMSG "  ArchvTerr complete."
# end ArchvTerr.sh
