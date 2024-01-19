#!/bin/bash
# FindFolderInTars.sh - Search for folder in subsytem .tar files.
# 1/15/23.	wmk.
#
#	Usage. bash FindFolderInTars <filespec> [-u mountname] [<statecountycongo>]
#
#		<filespec> = file to or pattern to search for
#						(e.g. Projects-Geany/ArchivingBackups/ReloadSubsys.sh)
#		-u = (optional) reload from unloadable device (flashdrive)
#		mountname (optional) = mount name for flashdrive
#		<statecountycongo> = (optional) tar archive base name
#							 default *congterr*
# Note: <statecountycongo> specifies a subfolder on the *mountname* drive
# in which the .tar exists to reload from.
#
# Dependencies.
#	*pathbase* - base directory in which all reloads will be placed.
#	*congterr* - congregation territory name (sscccccn format).
#	*pathbase*/*congterr*/.log - tar log subfolder of incremental dump tracking
#
# Exit Results. *TEMP_PATH/foundlist.txt lists incremental dumps containing <filespec>.
#
# Modification History.
# ---------------------
# 1/15/23.	wmk.	original code; adapted from FindFileInTars.sh
# Legacy mods.
# 11/17/22.	wmk.	exit handling improved allowing Terminal to continue.
# 11/22/22.	wmk.	mod to support system-resident .tar files; jumpto definition
#			 removed.
# 1/12/23.	wmk.	"Processing" changed to "Scanning".
# 1/15/23.	wmk.	"ArchList.txt" message corrected.
# Legacy mods.
# 9/20/22.	wmk.	modified for Chromebooks.
# 9/23/22.  wmk.    (automated) CB *codebase env var support.
# 10/10/22.	wmk.	updated to limit search output to successes.
# Legacy mods.
# 5/26/22.	wmk.	original code.
# 7/31/22.	wmk.	documentation improved.
#
P1=$1		# filespec
P2=$2		# -u
P3=$3		# mount-name
P4=${4^^}	# congterr
if [ -z "$P4" ];then
 P4=${congterr^^}
fi
if [ -z "$folderbase" ];then
 if [ "$USER" = "ubuntu" ]; then
  export folderbase=/media/ubuntu/Windows/Users/Bill
 else 
  export folderbase=$HOME
 fi
fi
if [ -z "$codebase" ];then
 codebase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$pathbase" ];then
 pathbase=$folderbase/Territories/FL/SARA/86777
fi
if [ -z "$congterr" ];then
 export congterr=FLSARA86777
fi
if [ -z "$P1" ];then
 echo "FindFolderInTars <filespec> [-u <mountname>] [<state><county><congno>] missing parameter(s) - abandoned."
 read -p "Enter ctrl-c to keep Terminal active:"
 exit 1
fi
# if P2 is present, P3 must also.
# to specify P4, P2, P3 must be present, but may be empty strings.
if  [ ! -z "$P2" ] && [ -z "$P3" ];then
  echo "FindFolderInTars <filespec> [-u <mountname>] [<state><county><congno>] missing parameter(s) - abandoned."
  echo "P1 = : $P1"		# filespec
  echo "P2 = : $P2"		# -u
  echo "P3 = : $P3"		# <mount-name>
  echo "P4 = : $P4"		# congterr
  read -p "Enter ctrl-c to keep Terminal active:"
  exit 1
fi
if [ -z "$P2" ];then		# if no flash drive specified
 echo "  No flash drive specified.."
 read -e -p " OK to use $codebase (Y/N)? :"
 yn=${REPLY,,}
 if [ "$yn" == "y" ];then
  dump_path=$codebase
 else
  echo "  Rerun TarFileDate specifying flash drive (typically 'Lexar')."
  read -p "Enter ctrl-c to remain in Terminal:"
  exit 1
 fi
else
 P2=${2,,}
 if [ "$P2" != "-u" ];then
  echo "FindFolderInTars <filespec> [-u <mountname>] [<state><county><congo>] unrecognized '-' option - abandoned."
 fi
 if ! test -d $U_DISK/$P3;then
  echo "** $P3 not mounted - mount $P3..."
  read -p "  then press {enter} or 'q' to quit: "
  yq=${REPLY^^}
  if [ "$yq" == "Q" ];then
   echo "  FindFolderInTars abandoned, drive not mounted."
   ~/sysprocs/LOGMSG "  FindFolderInTars abandoned, drive not mounted."
   read -p "Enter ctrl-c to keep Terminal active:"
   exit 0
  fi
  if ! test -d $U_DISK/$P3;then
   echo "  FindFolderInTars abandoned, $P3 drive still not mounted."
   read -p "Enter ctrl-c to keep Terminal active:"
   exit 1
  fi
  dump_path=$U_DISK/$P3/$P4
 fi
fi		# end no flash drive conditional
echo "P4 = : $P4"
# debugging code...
#echo "P1 = : $P1"	# filespec
#echo "P2 = : $P2"	# -u
#echo "P3 = : $P3"	# mount-name
#echo "P4 = : $P4"	# congter
#echo "FindFolderInTars parameter tests complete"
#read -p "Enter ctrl-c to keep Terminal active:"
#exit 0
# end debugging code.
local_debug=0	# set to 1 for debugging
#local_debug=1
#
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "   FindFolderInTars $P1 $P2 $P3 $P4 initiated from Make."
  echo "   FindFolderInTars initiated."
else
  ~/sysprocs/LOGMSG "   FindFolderInTars $P1 $P2 $P3 $P4 initiated from Terminal."
  echo "   FindFolderInTars initiated."
fi
TEMP_PATH="$HOME/temp"
#
if [ $local_debug = 1 ]; then
 pushd ./
 cd ~/Documents		# write files to Documents folder
fi

#procbodyhere
pushd ./ > $TEMP_PATH/scratchfile
if [ -z "$P3" ];then
 dump_path=$codebase
else
 dump_path=$U_DISK/$P3/$P4
fi
cd $dump_path
projpath=$codebase/Projects-Geany/ArchivingBackups
 # list all .tar files to temp/ArchList.txt.
if test -f $TEMP_PATH/taroutput.txt;then
 rm $TEMP_PATH/taroutput.txt
fi
 echo "dump_path = '$dump_path'"
  cd $dump_path
  ls *.tar > $TEMP_PATH/ArchList.txt
 echo "ArchList.txt follows..."
 cat $TEMP_PATH/ArchList.txt
  file=$TEMP_PATH/ArchList.txt
  cb=CB
  echo $P1 | sed 's?!?*?g'	#if ! substitute * 
   echo "Finding from *.tar dumps..."
   if [ -f $TEMP_PATH/taroutput.txt ];then
    rm $TEMP_PATH/taroutput.txt
   fi
   while read -e;do
    archname=$REPLY
    echo " Scanning $archname."
    echo "  $archname" >> $TEMP_PATH/taroutput.txt
    tar --list --wildcards \
    --file $dump_path/$archname \
    -- *$P1  1>>$TEMP_PATH/taroutput.txt 2>>$TEMP_PATH/taroutput.txt
   done < $file
backslash='//"'
# at this point taroutput.txt contains 2-line outputs, 1) archive name,
# 2) if found, line has $P1 or if not found, 2 lines beginning with 'tar:'
#mawk  '{if(substr($1,1,4) != "tar:") print;}' $TEMP_PATH/taroutput.txt
mawk -v srch_name="$P1" 'BEGIN {prevline = ""}{currline = $0;if(substr($1,1,4) != "tar:" && index($0,srch_name)>0){print prevline "\n" currline;prevline=currline}prevline=currline}' $TEMP_PATH/taroutput.txt
wc $TEMP_PATH/taroutput.txt > $TEMP_PATH/scratchfile.txt
if [ $? -ne 0 ];then
 echo "  File $P1 not found in tar dumps..."
fi
read -p "Enter ctrl-c to keep Terminal active:"
exit 0
# end FindFolderInTars.sh

