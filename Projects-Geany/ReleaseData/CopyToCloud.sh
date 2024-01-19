#!/bin/bash
# CopyToCloud.sh - Copy Release Data to cloud.
#	3/5/23.	wmk.
#
# Usage.	bash CopyCloud.sh  mm dd yy [-k]
#
#	mm = month of release
#	dd = day of release
#	yy = year of release
#
# Exit.	gcloud:/CongInfoExchange/Territories/Release_mm-dd-yy folder created
#		 with the release files.
#
# Modification History.
# ---------------------
# 3/5/23.	wmk.	*codebase support; comments tidied.
# Legacy mods.
# 11/16/21.	wmk.	original code.
# 4/28/22.	wmk.	rmdir path corrected.
# 5/7/22.	wmk.	*pathbase* support.
#
P1=$1
P2=$2
P3=$3
if [ -z "$P1" ] ||[ -z "$P2" ] ||[ -z "$P3" ];then 
 echo "CopyToCloud <mm> <dd> <yy> missing parameter(s) - abandoned."
 exit 1
fi
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ]; then
   export folderbase="/media/ubuntu/Windows/Users/Bill"
 else 
  export folderbase=$HOME
 fi
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories/FL/SARA/86777
fi
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "  CopyToCloud - initiated from Make"
  echo "  CopyToCloud - initiated from Make"
else
  ~/sysprocs/LOGMSG "  CopyToCloud - initiated from Terminal"
  echo "  CopyToCloud - initiated from Terminal"
fi 
TEMP_PATH="$folderbase/temp"
if [ -z "$P1"  ] || [ -z "$P2"  ] || [ -z "$P3"  ];then 
  echo "CopyToCloud <mm> <dd> <yy>  missing parameter - abandoned."
 ~/sysprocs/LOGMSG "  CopyToCloud <mm> <dd> <yy>  missing parameter - abandoned."
  exit 1  
fi
#proc body here
relbase=Release_$P1
echo "rclone rmdir gcloud:CongInfoExchange/Territories/$relbase-$P2-$P3"
rclone rmdir gcloud:CongInfoExchange/Territories/$relbase-$P2-$P3echo
"rclone mkdir gcloud:CongInfoExchange/Territories/$relbase-$P2-$P3"
rclone mkdir gcloud:CongInfoExchange/Territories/$relbase-$P2-$P3
echo "rclone copy $pathbase/ReleaseData/$relbase-$P2-$P3 to gcloud"
rclone copy $pathbase/ReleaseData/$relbase-$P2-$P3 \
  gcloud:CongInfoExchange/Territories/$relbase-$P2-$P3
#end proc body
echo "  CopyToCloud $P1 $P2 $P3 complete."
~/sysprocs/LOGMSG "  CopyToCloud $P1 $P2 $P3 complete."
#end proc
