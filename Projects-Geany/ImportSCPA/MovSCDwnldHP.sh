#!/bin/bash
echo " ** MovSCDwnldHP.sh out-of-date **";exit 1
echo " ** MovSCDwnldHP.sh out-of-date **";exit 1
# MovSCDwnldHP.sh - Move SCPA download from *DWNLD_PATH to SCPA-Downloads folder.
# 6/14/23.	wmk.
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
# 4/27/22.	wmk.	original shell.
# 6/30/22.	wmk.	bug fix 'RawData' missing from target path.
# 9/23/22.  wmk.    (automated) CB *codebase env var support.
# 6/14/23.	wmk.	use *DWNLD_PATH environment var.
#
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ]; then
  export folderbase=/media/ubuntu/Windows/Users/Bill
 else 
  export folderbase=$HOME
 fi
fi
if [ -z "$system_log" ]; then
 system_log=$folderbase/ubuntu/SystemLog.txt
fi
TEMP_PATH=$HOME/temp
#
P1=${1^^}
P2=${2^^}
P3=$3		# congno
P4=$4		# mm
P5=$5		# dd
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ] || [ -z "$P4" ] || [ -z "$P5" ];then
 echo "MovSCDwnldHP <state> <county> <congo> <mm> <dd> missing parameter(s) - abandoned."
 exit 1
fi
if "$folderbase/Territories/$P1/$P2/$P3" != "$pathbase" ];then
 echo "pathbase =$pathbase"
 echo " $folderbase/Territories/$P1/$P2/$P3 does not match *pathbase* - abandoned."
 exit 1
fi
local_debug=0	# set to 1 for debugging
#local_debug=1
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
if [ $local_debug = 1 ]; then
 pushd ./
 cd ~/Documents		# write files to Documents folder
fi

#proc body here
src_path=$DWNLD_PATH
targ_path=$pathbase/RawData/SCPA/SCPA-Downloads
if [ $local_debug = 1 ]; then
   echo "cp -uv $srcpath/'SCPA Publix.xlsx' $targ_path"
fi
#  cp -uv $targ_path$TID/$file_name $targ_path$TID/Previous
cp -puv $src_path/'SCPA Public.xlsx' $targ_path/SCPA-Public_$P4-$P5.xlsx
#end proc body
if [ $local_debug = 1 ]; then
  popd > $TEMP_PATH/scratchfile.txt
fi
# check for Chromebook.
~/sysprocs/LOGMSG  "MovSCDwnldHP complete."
echo "  MovSCDwnldHP complete."
#end MovSCDwnldHP.
