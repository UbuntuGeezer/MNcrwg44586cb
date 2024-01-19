#!/bin/bash
echo " ** MovSCDwnld.sh out-of-date **";exit 1
echo " ** MovSCDwnld.sh out-of-date **";exit 1
# MovSCDwnld.sh - Move SCPA download from *DWNLD_PATH to SCPA-Downloads folder.
#	6/15/23.wmk.
#	Usage. bash MovSCDwnldHP <state> <county> <congno>
#
#		<state> = 2 character state abbreviation
#		<county> = 4 character county abbreviation
#		<congno> = congregation number
#		<mm> = month of new download
#		<dd> = day of new download
#
#	Entry. *pathbase* = base path for Territory system
#			passed parameters must match key fields in *pathbase*
#
# Dependencies.
#	folder ~/RawData/SCPA/SCPA-Downloads exists
#	filename SCPA Public.xlsx exists in *folderbase*/Downloads folder.
#
# Exit. /Downloads/'SCPA Public.xlsx' -> *pathbase/*scpath/SCPA-Public_mm-dd.xlsx
#
# Modification History.
# ---------------------
# 11/22/22.	wmk.	original shell; adapted from MovSCDwnldHP.
# 11/22/22. wmk.    (automated) CB *codebase env var support.
# 6/14/23.	wmk.	use *DWNLD_PATH environment var.
# 6/15/23.	wmk.	export *folderbase if not set.
# Legacy mods.
# 4/27/22.	wmk.	original shell.
# 6/30/22.	wmk.	bug fix 'RawData' missing from target path.
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
 export codebase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$system_log" ]; then
 system_log=$folderbase/ubuntu/SystemLog.txt
fi
TEMP_PATH=$HOME/temp
#
P1=${1^^}	# state
P2=${2^^}	# county
P3=$3		# congterr
P4=$4		# mm
P5=$5		# dd
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ] || [ -z "$P4" ] || [ -z "$P5" ];then
 echo "MovSCDwnldHP <state> <county> <congo> <mm> <dd> missing parameter(s) - abandoned."
 read -p "Enter ctrl-c to remain in Terminal"
 exit 1
fi
if "$folderbase/Territories/$P1/$P2/$P3" != "$pathbase" ];then
 echo "pathbase =$pathbase"
 echo " $folderbase/Territories/$P1/$P2/$P3 does not match *pathbase* - abandoned."
 read -p "Enter ctrl-c to remain in Terminal"
 exit 1
fi
#
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  bash ~/sysprocs/LOGMSG "   MovDwnld initiated from Make."
  echo "   MovSCDwnldHP initiated."
else
  bash ~/sysprocs/LOGMSG "   MovDwnld initiated from Terminal."
  echo "   MovSCDwnldHP initiated."
fi
TEMP_PATH=$HOME/temp
#
#procbodyhere
src_path=$DWNLD_PATH
targ_path=$pathbase/RawData/SCPA/SCPA-Downloads
if [ ! -f $src_path/'SCPA Public.xlsx' ];then
 echo "** Missing $src_path/'SCPA Public.xlsx exiting **"
 read -p "Enter ctrl-c to remain in Terminal:"
 exit 1
fi
#  cp -uv $targ_path$TID/$file_name $targ_path$TID/Previous
#cp -puv $src_path/'SCPA Public.xlsx' $targ_path/SCPA-Public_$P4-$P5.xlsx
mv $src_path/'SCPA Public.xlsx' $targ_path/SCPA-Public_$P4-$P5.xlsx
ls $targ_path/SCPA-Public_$P4-$P5.xlsx
#endprocbody
~/sysprocs/LOGMSG  "MovSCDwnldHP complete."
echo "  MovSCDwnld complete."
#end MovSCDwnldHP.
