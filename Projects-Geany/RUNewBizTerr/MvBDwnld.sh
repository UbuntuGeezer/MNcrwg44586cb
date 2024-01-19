#!/bin/bash
echo " ** MvBDwnld.sh out-of-date **";exit 1
echo " ** MvBDwnld.sh out-of-date **";exit 1
# MvBDwnld.sh - Move business territory downloads from BRU/Downloads to BRU/Terrxxx folders.
#	6/15/23.	wmk.
#
#	Usage. bash MvBDwnld <terr> <type>
#		<terr> - territory id or "tidlist" {FixAnyRU project}
#		<type> - RU or SC; RU default if not specified
#
# Dependencies.
#	folder ~/BRawData/BBRefUSA/BBRefUSA-Downloads/Terr<terr> exists
#	folder ~/BRawData/BBSCPA/BBSCPA-Downloads/Terr<terr> exists
#	filename "Map<terr><type>".csv exists
#
# Modification History.
# ---------------------
# 6/15/23.	wmk.	header description improved.
# Legacy mods.
# 9/28/21.	wmk.	original shell; adapted from MvDwnld.
# 5/11/22.	wmk.	*pathbase* support; path change to RefUSA/RefUSA-Downloads.
# Legacy mods.
# 4/8/21.	wmk.	original shell.
# 5/18/21.	wmk.	add copy to ./Previous before move.
# 5/27/21.	wmk.	modified for use with Kay's system; environment checked
#					and used for correct Territory folder paths.
# 5/30/21.	wmk.	modified for multihost system support.
# 6/6/21.	wmk.	bug fixes; equality check ($)HOME, TEMP_PATH
#					ensured set.
# 6/9/21.	wmk.	mod generalizing folderbase for multihost support;
#					multifile processing using TIDList added; RU default.
# 6/17/21.	wmk.	bug fixes; LOGMSG type corrected; TID missing in 
#					filename generation with single TID.
# 9/18/21.	wmk.	base folder changed from Downloads to BRefUSA-Downloads/Downloads
#					or BSCPA-Downloads/Downloads; superfluous "s removed; P2
#					case shifted to lowercase; typebase env var added; jumpto
#					function eliminated; -uv option added to copy (update/vervose);
#					bug fix where 'ru' not being defaulted correctly; folderbase
#					added to all paths.
#
# Notes. If "tidlist" is used, the TIDList.txt file is expected to be
# in the FixAnyRU project folder.
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
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories/FL/SARA/86777
fi
TEMP_PATH=$HOME/temp
#
PA=$1
P1=${PA,,}
PA=$2
P2=${PA,,}
local_debug=0	# set to 1 for debugging
#local_debug=1
#
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  TEMP_PATH="$HOME/temp"
  bash ~/sysprocs/LOGMSG "   MvBDwnld initiated from Make."
  echo "   MvBDwnld initiated."
else
  bash ~/sysprocs/LOGMSG "   MvBDwnld initiated from Terminal."
  echo "   MvBDwnld initiated."
fi
#
if [ -z "$P1" ]; then
  echo "  MvBDwnld ignored.. must specify <terrid>." >> $system_log #
  echo "  MvBDwnld ignored.. must specify <terrid>."
  exit 1
fi 
# only process TIDList for type RU.
if [ "$P1" == "tidlist" ]; then
  P2=ru
fi
if [ -z "$P2" ]; then
  echo "  MvBDwnld <type> not specified.. defaulting to RU." >> $system_log #
  echo "  MvBDwnld <type> not specified.. defaulting to RU."
  P2=ru
fi 
#
if [ $local_debug = 1 ]; then
 pushd ./
 cd ~/Documents		# write files to Documents folder
fi

#proc body here
if [ "$P2" == "ru" ]; then
 type_base=RefUSA/RefUSA-Downloads
 type_path=RefUSA/RefUSA-Downloads/Terr
 file_suffx=_RU
elif [ "$P2" == "sc"  ]; then
 type_base=SCPA/SCPA-Downloads
 type_path=SCPA/SCPA-Downloads/Terr
 file_suffx=_SC
else
 bash ~/sysprocs/LOGMSG "  MvBDwnld ignored.. invalid RU/SC type."
 echo "  MvBDwnld ignored.. invalid RU/SC type."
 exit 1
fi
base_path=$pathbase/BRawData
src_path=$base_path/$type_base/Downloads
targ_path=$base_path/$type_path
# conditionally loop on TIDList.
case "$P1" in
"tidlist")
  cd $pathbase/Projects-Geany/FixAnyRU
  error_counter=0		# set error counter to 0
  IFS="&"			# set & as the word delimiter for read.
  file='TIDList.txt'
  file_base="Map"
  file_type=".csv"
  i=0
  while read -e; do
    #reading each line
    echo -e " processing $REPLY " >> $TEMP_PATH/scratchfile
    len=${#REPLY}
    len1=$((len-1))
    firstchar=${REPLY:0:1}
#  echo -e "  $firstchar\n is first char of line." >> $HOME/temp/scratchfile
  #expr index $string $substring
    if [ "$firstchar" = "#" ]; then			# skip comment
      echo $REPLY >> $HOME/temp/scratchfile
    else
      TID=${REPLY:0:len}
      bash ~/sysprocs/LOGMSG "  MvBDwnld $TID RU initiated."
      echo "  MvBDwnld $TID RU initiated."
# copy cp code here..
      file_base="Map"
      file_type=".csv"
      file_name=$file_base$TID$file_suffx$file_type
      if [ $local_debug = 1 ]; then
       echo "cp -uv $targ_path$TID/$file_name $targ_path/Previous"
      fi
      if test -f $targ_path$TID/$file_name;then 
	cp -uv $targ_path$TID/$file_name $targ_path$TID/Previous;fi
      if [ $local_debug = 1 ]; then
       echo "cp -uv $src_path/$file_name $targ_path$TID/$file_name"
      fi
      cp -uv $src_path/$file_name $targ_path$TID/$file_name
    fi     # end is comment line conditional

    i=$((i+1))
  done < $file
  echo " $i TIDList.txt lines processed."
  if [ $error_counter = 0 ]; then
    rm $TEMP_PATH/scratchfile
  else
    echo "  $error_counter errors encountered - check $TEMP_PATH/scratchfile "
  fi
;;
*)
  TID=$P1
  bash ~/sysprocs/LOGMSG "  MvBDwnld $TID RU initiated."
  echo "  MvBDwnld $TID $P2 initiated."
  file_base="Map"
  file_type=".csv"
  file_name=$file_base$TID$file_suffx$file_type
  if [ $local_debug = 1 ]; then
   echo "cp -uv $targ_path$TID/$file_name $targ_path$TID/Previous"
  fi
  if test -f $targ_path$TID/$filename;then 
   cp -uv $targ_path$TID/$file_name $targ_path$TID/Previous;fi
  if [ $local_debug -eq 1 ]; then
   echo "cp -uv $src_path/$file_name $targ_path$TID/$file_name"
  fi
  cp -uv $src_path/$file_name $targ_path$TID/$file_name;;
esac
#end proc body
if [ $local_debug = 1 ]; then
  popd > $TEMP_PATH/scratchfile.txt
fi
notify-send "MvBDwnld" "$1 complete."
~/sysprocs/LOGMSG  "MvBDwnld $1 complete."
echo "  MvBDwnld $P1 complete."
#end MvBDwnld
