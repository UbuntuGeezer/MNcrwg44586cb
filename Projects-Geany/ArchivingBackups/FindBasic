#!/bin/bash
# FindBasic.sh  - Incremental archive of Basic subdirectories.
# 5/2/22.	wmk.
#
#	Usage. bash FindBasic <filelist> [-u mountname] [<statecountycongo>]
#
#		<filespec> = file to reload or pattern to reload
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
# Exit Results. *stdout* lists incremental dumps containing <filespec>.
#
# Modification History.
# ---------------------
# 5/2/22.	wmk.	original code.
#
# Notes. FindBasic.sh performs a *tar* reload of the
# Basic subdirectory file(s). If the folder *pathbase*/*congterr*/log does
# not exist under
# Basic, it is considered an unrecoverable error, since the current
# archive level cannot be detemined.
# The file ./log/Basic.snar is created as the listed-incremental archive
# information. The file *pathbase*/*congterr*/log/nextlevel.txt contains
# the next archive level. If this is '0', then no retrieval is possible.
# Otherwise, $(nextlevel)-1 is assumed to be the latest dump level.
# All .level.tar files will have the filespec reloaded, starting with
# level = 0 through $(nextlevel)-1. 
# function definition
function jumpto
{
    label=$1
    cmd=$(sed -n "/$label:/{:a;n;p;ba};" $0 | grep -v ':$')
    eval "$cmd"
    exit
}
P1=$1
P2=$2
P3=$3
P4=${4^^}
if [ -z "$P1" ];then
 echo "FindBasic <filespec> [-u <mountname>] [<state><county><congno>] missing parameter(s) - abandoned."
 exit 1
fi
# if P2 is present, P3 must also.
# to specify P4, P2, P3 must be present, but may be empty strings.
if  [ ! -z "$P2" ] && [ -z "$P3" ];then
  echo "FindBasic <filespec> [-u <mountname>] [<state><county><congno>] missing parameter(s) - abandoned."
  echo "P1 = : $P1"
  echo "P2 = : $P2"
  echo "P3 = : $P3"
  echo "P4 = : $P4"
  exit 1
fi
if [ ! -z "$P2" ];then
 P2=${2,,}
 if [ "$P2" != "-u" ];then
  echo "FindBasic <filespec> [-u <mountname>] [<state><county><congo>] unrecognized '-' option - abandoned."
 fi
 if ! test -d $U_DISK/$P3;then
  echo "** $P3 not mounted - mount $P3..."
  read -p "  then press {enter} or 'q' to quit: "
  yq=${REPLY^^}
  if [ "$yq" == "Q" ];then
   echo "  FindBasic abandoned, drive not mounted."
   ~/sysprocs/LOGMSG "  FindBasic abandoned, drive not mounted."
   exit 0
  fi
 fi
fi
echo "P4 = : $P4"
if [ -z "$folderbase" ];then
 if [ "$USER" = "ubuntu" ]; then
  export folderbase=/media/ubuntu/Windows/Users/Bill
 else 
  export folderbase=$HOME
 fi
fi
if [ -z "$pathbase" ];then
 pathbase=$folderbase/Territories/FL/SARA/86777
fi
if [ -z "$congterr" ];then
 export congterr=FLSARA86777
fi
if [ -z "$P4" ];then
 P4=${congterr^^}
fi
#if [ "$P4" != "$congterr" ];then
# echo "*congterr* = :$congterr"
# echo "** $P1$P2$P3 mismatch with *congterr* - FlashBacks abandoned **"
# exit 1
#fi
# debugging code...
#echo "P1 = : $P1"
#echo "P2 = : $P2"
#echo "P3 = : $P3"
#echo "P4 = : $P4"
#echo "FindBasic parameter tests complete"
#exit 0
# end debugging code.
local_debug=0	# set to 1 for debugging
#local_debug=1
#
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "   FindBasic $P1 $P2 $P3 $P4 initiated from Make."
  echo "   FindBasic initiated."
else
  ~/sysprocs/LOGMSG "   FindBasic $P1 $P2 $P3 $P4 initiated from Terminal."
  echo "   FindBasic initiated."
fi
TEMP_PATH="$HOME/temp"
#
if [ $local_debug = 1 ]; then
 pushd ./
 cd ~/Documents		# write files to Documents folder
fi

#proc body here
pushd ./ > $TEMP_PATH/scratchfile
cd $pathbase
# list all .tar file folders, then cycle on list.
echo "" > $TEMP_PATH/tarparents.txt
echo "FLSARA86777" >> $TEMP_PATH/tarparents.txt
echo "TXHDLG99999" >> $TEMP_PATH/tarparents.txt
echo "NewTerritories" >> $TEMP_PATH/tarparents.txt
# now loop through parents listing .tar files.
file=$TEMP_PATH/tarparents.txt
if -f $TEMP_PATH/findlist.txt;then
 rm $TEMP_PATH/findlist.txt
fi
touch $TEMP_PATH/findlist.txt
while read -e;do
 farchbase=$REPLY
 cd $pathbase
 ls -lh ./$farchbase*.tar >> $TEMP_PATH/findlist.txt
done < $file
exit 0
#------------------------------------
ls *.tar > $TEMP_PATH/tarbabies.txt

level=level
nextlevel=nextlevel
newlevel=newlevel
# check for .snar file.
if [ -z "$congterr" ];then
 if ! test -f $pathbase/log/$congterr$basic.snar-0;then
  echo "** cannot locate .snar file.. abandoned."
  exit 1
 fi
else
 if ! test -f $pathbase/log/$congterr$basic.snar-0;then
  echo "** cannot locate .snar file.. abandoned."
  exit 1
 fi
fi
# cat ./log/$congterr$basic$nextlevel.txt
 awk '{$1--; print $0}' ./log/$congterr$basic$nextlevel.txt > $TEMP_PATH/LastTarLevel.txt
 file=$TEMP_PATH/LastTarLevel.txt
 while read -e;do
#  echo "Last *tar* level = : $REPLY"
  lastlevel=$REPLY
 done < $file
 seq 0 $lastlevel > $TEMP_PATH/TarLevelList.txt
# seq 0 $lastlevel
 file=$TEMP_PATH/TarLevelList.txt
 if [ -z "$P3" ];then
  echo "Finding from $P4$basic.*.tar incremental dumps..."
  while read -e;do
   echo " Processing $basic.$REPLY.tar."
   tar --list --wildcards \
   --keep-newer-files \
   --file=$P4$basic.$REPLY.tar \
   $basic/$P1
  done < $file
 else
  echo "Finding from $U_DISK/$P3/$P4/$P4$basic.*.tar incremental dumps..."
  while read -e;do
   echo " Processing $U_DISK/$P3/$P4/$P4$basic.$REPLY.tar."
   tar --list --wildcards \
   --keep-newer-files \
   --file=$U_DISK/$P3/$P4/$P4$basic.$REPLY.tar \
   $basic/$P1
  done < $file
 fi
exit 0
# end FindBasic.sh

