#!/bin/bash
# FindFileInTars.sh - Search for file in subsytem .tar files.
# 8/15/23.	wmk.
#
#	Usage. bash FindFileInTars <filespec> -u mountname [<scope>] [<statecountycongo>]
#
#		<filespec> = file to or pattern to search for
#						(e.g. Projects-Geany/ArchivingBackups/ReloadSubsys.sh)
#		-u = (optional) reload from unloadable device (flashdrive)
#		mountname (optional, mandatory with -u) = mount name for flashdrive
#		<scope> = (optional) .tar search scope (e.g. *TerrData*)
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
# 8/15/23.	wmk.	adpated for MNcrwg44586; -u, <mount-name> mandatory.
# Legacy mods.
# 3/16/23.	wmk.	<scope> support for limiting .tars,s searched;have gawk sort
#			 dump file list so processed in order.
# 3/27/23.	wmk.	add *congterr to *scope for archive names.
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
# <filespec> <-u> <mount-name> <scope> <congterr>
P1=$1	
P2=${2,,}
P3=$3	
P4=$4
P5=${5^^}
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ];then
 echo "FindFileInTars <filespec> -u <mountname> [<scope> <congterr>] missing parameter(s) - abandoned."
 exit 1
fi
if [ -z "$P5" ];then
 P5=${congterr^^}
fi
if [ -z "$P4" ];then
 P4=*
fi
export scope=$P4
if [ -z "$folderbase" ];then
 if [ "$USER" = "ubuntu" ]; then
  export folderbase=/media/ubuntu/Windows/Users/Bill
 else 
  export folderbase=$HOME
 fi
fi
if [ -z "$codebase" ];then
 export codebase=$folderbase/GitHub/TerritoriesCB/MNcrwg44586
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories/MN/CRWG/44586
fi
if [ -z "$congterr" ];then
 export congterr=MNCRWG44586
fi
# if P2 is present, P3 must also.
# to specify P5, P2, P3 must be present, but may be empty strings.
if [ "$P2" != "-u" ];then
  echo "FindFileInTars <filespec> [-u <mountname>] [<scope>] [<state><county><congo>] unrecognized '-' option - abandoned."
fi
if ! test -d $U_DISK/$P3;then
  echo "** $P3 not mounted - mount $P3..."
  read -p "  then press {enter} or 'q' to quit: "
  yq=${REPLY^^}
  if [ "$yq" == "Q" ];then
   echo "  FindFileInTars abandoned, drive not mounted."
   ~/sysprocs/LOGMSG "  FindFileInTars abandoned, drive not mounted."
   read -p "Enter ctrl-c to keep Terminal active:"
   exit 0
  fi
  if ! test -d $U_DISK/$P3;then
   echo "  FindFileInTars abandoned, $P3 drive still not mounted."
   read -p "Enter ctrl-c to keep Terminal active:"
   exit 1
  else
   echo "  continuing with $P3 mounted..."
  fi
else
 echo "  continuing with $P3 mounted..."
fi
echo "P5 = : $P5"
# debugging code...
echo "P1 = : $P1"	# filespec
echo "P2 = : $P2"	# -u
echo "P3 = : $P3"	# mount-name
echo "P4 = : $P4"  # scope
echo "P5 = : $P5"	# congter
echo "FindFileInTars parameter tests complete"
#read -p "Enter ctrl-c to keep Terminal active:"
#exit 0
# end debugging code.
#
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "   FindFileInTars $P1 $P2 $P3 $P4 $P5 initiated from Make."
  echo "   FindFileInTars initiated."
else
  ~/sysprocs/LOGMSG "   FindFileInTars $P1 $P2 $P3 $P4 $P5 initiated from Terminal."
  echo "   FindFileInTars initiated."
fi
TEMP_PATH="$HOME/temp"
#
#procbodyhere
pushd ./ > /dev/null
dump_path=$U_DISK/$P3/$P5
cd $dump_path
projpath=$codebase/Projects-Geany/ArchivingBackups
 # list all .tar files to temp/ArchList.txt.
if test -f $TEMP_PATH/taroutput.txt;then
 rm $TEMP_PATH/taroutput.txt
fi
 echo "dump_path = '$dump_path'"
  cd $dump_path
  ls $congterr$scope.*.tar > $TEMP_PATH/ArchList.txt
#gawk -F "." '{BEGIN{cnt=0}{names[cnt] = $0}END{n=asort(names,names,"@val_str_asc");for(i=0;i <= cnt;i++)print names[i]}}' ArchList.txt > ArchSortedList.txt
gawk -F "." -f $projpath/awksortarch2.txt $TEMP_PATH/ArchList.txt > $TEMP_PATH/ArchSortedList.txt
 echo "ArchSortedList.txt follows..."
 cat $TEMP_PATH/ArchSortedList.txt
  file=$TEMP_PATH/ArchSortedList.txt
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
    -- */$P1  1>>$TEMP_PATH/taroutput.txt 2>>$TEMP_PATH/taroutput.txt
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
# end FindFileInTars.sh
