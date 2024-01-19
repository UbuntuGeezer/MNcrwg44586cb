#!/bin/bash
echo " ** MovDwnld.sh out-of-date **";exit 1
echo " ** MovDwnld.sh out-of-date **";exit 1
# MovDwnld.sh - Move territory download from ~/Downloads to RawData folder.
# 7/9/23.	wmk.
#
#	Usage. bash MovDwnld <terr>|tidlist <type>
#		<terr> - territory id or "tidlist" {UpdateRUDwnld project}
#		<type> - RU or SC; RU default if not specified
#		<count> = count of download files if split .csv
#
# Dependencies.
#	*DWNLD_PATH* environment var set.
#	folder ~/RawData/RefUSA/RefUSA-Downloads/Terr<terr> exists
#	folder ~/RawData/SCPA/SCPA-Downloads/Terr<terr> exists
#	filename "Map<terr><type>".csv exists
#	~/Procs-Dev/MvDwnld.sh shell
#
# Modification History.
# ---------------------
# 3/4/23.	wmk.	*sed added after move to strip header line, preserving .csv
#			 file date for data synchronization; comments tidied.
# 5/22/23.	wmk.	title path corrected to ~/Downloads.
# 6/6/23.	wmk.	OBSOLETE territory detection.
# 7/5/23.	wmk.	error message(s) include all parameters.
# 7/9/23.	wmk.	bug fix - UpdateRUDwnld path (not FixAnyRU) for 'tidlist';
#			 add FixRUcsv.sh to compensate for RefUSA bug.
# Legacy mods.
# 10/4/22.  wmk.    (automated) fix *pathbase for CB system.
# Legacy mods.
# 9/23/22.  wmk.    (automated) CB *codebase env var support.
# 10/2/22.	wmk.	*pathbase support; codebase support; multiple minor bug fixes.
# Legacy mods.
# 5/24/22.	wmk.	*DWNLD_PATH dependency added.
# Legacy mods.
# 12/20/20.	wmk.	original shell; adapted from MovDwnld.
# 12/21/21.	wmk.	bug fix with basepath for ChromeBook; eliminate TID
#			 from targpath, since is /Downloads; add code to loop if 
#			 processing multiple downloads. 
# 1/10/22.	wmk.	else case P2=ru corrected.
# 1/11/22.	wmk.	bug fix with *tidlist* option doubling terrid in name;
#			 targpath reset for each TID in *tidlist*
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
# 9/18/21.	wmk.	base folder changed from Downloads to RefUSA-Downloads/Downloads
#			 or SCPA-Downloads/Downloads; superfluous "s removed; P2
#			 case shifted to lowercase; typebase env var added; jumpto
#			 function eliminated; -uv option added to copy (update/vervose);
#			 bug fix where 'ru' not being defaulted correctly; folderbase
#			 added to all paths.
#
# Notes. If "tidlist" is used, t# insufficient file count.
# The TIDList.txt file is expected to be
# in the FixAnyRU project folder.
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
if [ -z "$codebase" ]; then
 export codebase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$DWNLD_PATH" ];then
 echo "  Hint: export DWNLD_PATH=/home/vncwmk3/Downloads..."
 echo "  MovDwnld *DWNLD_PATH* environment var not set - abandoned."
 echo " Hint"
 echo " export DWNLPATH=~/Downloads"
 exit 1
fi
if [ -z "$system_log" ]; then
 system_log=$folderbase/ubuntu/SystemLog.txt
fi
TEMP_PATH=$HOME/temp
#
PA=$1
P1=${PA,,}
TID=$P1
PA=$2
P2=${PA,,}
P3=$3
local_debug=0	# set to 1 for debugging
#local_debug=1
#
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  TEMP_PATH="$HOME/temp"
  bash ~/sysprocs/LOGMSG "   MovDwnld initiated from Make."
  echo "   MovDwnld initiated."
else
  bash ~/sysprocs/LOGMSG "   MovDwnld initiated from Terminal."
  echo "   MovDwnld initiated."
fi
#
if [ -z "$P1" ]; then
  ~/sysprocs/LOGMSG "  MovDwnld <terrid>|'tidlist' [RU|SC] [<count>] missing parameter(s) - abanndoned."
  echo "  MovDwnld <terrid> [RU|SC] [<count>] missing parameter(s) - abanndoned."
  read -p "Enter ctrl-c to remain in Terminal: "
  exit 1
fi
if [ "$P1" != "tidlist" ] && test -f $pathbase/$rupath/Terr$P1/OBSOLETE;then
 echo " ** Territory $P1 OBSOLETE - MovDwnld exiting..**"
 exit 2
fi 
# only process TIDList for type RU.
if [ "$P1" == "tidlist" ]; then
  P2=ru
fi
if [ -z "$P2" ]; then
  echo "  MovDwnld <type> not specified.. defaulting to RU." >> $system_log #
  echo "  MovDwnld <type> not specified.. defaulting to RU."
  P2=ru
fi 
#
if [ -z "$P3" ]; then
  echo "  MovDwnld <count> not specified.. defaulting to 1." >> $system_log #
  echo "  MovDwnld <count> not specified.. defaulting to 1."
  P3=1
else
  P2=ru
fi 
if [ $local_debug = 1 ]; then
 pushd ./ > /dev/null
 cd ~/Documents		# write files to Documents folder
fi

#procbodyhere
if [ "$P2" == "ru" ]; then
 type_base=RefUSA/RefUSA-Downloads
 type_path=RefUSA/RefUSA-Downloads/Terr
 file_suffx=_RU
elif [ "$P2" == "sc"  ]; then
 type_base=SCPA/SCPA-Downloads
 type_path=SCPA/SCPA-Downloads/Terr
 file_suffx=_SC
else
 ~/sysprocs/LOGMSG "  MovDwnld ignored.. invalid RU/SC type."
 echo "  MovDwnld ignored.. invalid RU/SC type."
 exit 1
fi
#src_path=/mnt/chromeos/MyFiles/Downloads
src_path=$DWNLD_PATH
base_path=$pathbase/RawData
targ_path=$base_path/$type_path$TID
# conditionally loop on TIDList.
case "$P1" in
"tidlist")
  cd $codebase/Projects-Geany/UpdateRUDwnld
  error_counter=0		# set error counter to 0
  IFS="&"			# set & as the word delimiter for read.
  file=$codebase/Projects-Geany/UpdateRUDwnld/TIDList.txt
  file_base=Map$TID
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
    if [ "$firstchar" == "#" ]; then			# skip comment
      echo $REPLY >> $HOME/temp/scratchfile
      continue
    elif [ "$firstchar" == "$" ];then
      break
    else
      TID=${REPLY:0:len}
      ~/sysprocs/LOGMSG "  MovDwnld $TID RU initiated."
      echo "  MovDwnld $TID RU initiated."
# copy cp code here..
      file_base=Map$TID
      file_type=.csv
      file_name=$file_base$file_suffx$file_type
      targ_path=$pathbase/RawData/RefUSA/RefUSA-Downloads/Terr$TID
#      cp -uv $targ_path$$file_name $targ_path/Previous
	  if  ! test -f $src_path/$file_name;then
	   error_counter=$((error_counter+1))
	   i=$((i+1))
	   continue
	  fi
	  $codebase/Projects-Geany/DwnldMgr/FixRUcsv.sh $file_base$file_suffx $src_path
      cp -uv $src_path/$file_name $targ_path/$file_name
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
  src_path=$DWNLD_PATH
  targ_path=$pathbase/RawData/RefUSA/RefUSA-Downloads/Terr$TID
  ~/sysprocs/LOGMSG "  MovDwnld $TID RU initiated."
  echo "  MovDwnld $TID $P2 initiated."
  file_base=Map$TID
  basefile=$file_base
  file_type=".csv"
  file_name=$file_base$TID$file_suffx$file_type
#  cp -uv $targ_path$TID/$file_name $targ_path$TID/Previous

  if [ $P3 -eq 1 ];then
#d   cp -uv $src_path/$file_name $targ_path
   $codebase/Projects-Geany/DwnldMgr/FixRUcsv.sh $file_base$file_suffx $src_path
   cp -puv $src_path/$file_base$file_suffx.csv $targ_path
   # remove headers at this point to preserve.csv file date.
   sed -i '/Last Name/ d' $targ_path/$file_base$file_suffx.csv
  else
  # multifile copy.
  # stolen code from CatSpecDwnld.
    F_CNT=$P3
# type_base=Territories/RawData/RefUSA/RefUSA-Downloads
# src_path=Territories/RawData/RefUSA/RefUSA-Downloads/Special
# targ_path=Territories/RawData/RefUSA/RefUSA-Downloads/Terr$TID
# file_suffx=_RU
    basetid=Map$TID 
    basefile=Map$TID$file_suffx
   if [ $F_CNT -gt 1 ];then
    for (( i=1; i<=$F_CNT ; i++ ));do
     echo $src_path/$basetid-i$file_suffx.csv
     if ! test -f $src_path/$basetid-$i$file_suffx.csv; then
       echo "$basetid-$i$file_suffx.csv not found - MovDwnld abandoned."
       ~/sysprocs/LOGMSG "  $basetid-$i$file_suffx.csv not found - MovDwnld abandoned."
       exit 1
     fi
    done;
    # loop copying files.
#    basetid=Map$TID 
#    basefile=Map$TID_RU
    if test -f $targ_path/$basefile.csv;then
     rm $targ_path/$basefile.csv
    fi;
    basetid=Map$TID 
    #basefile=Map$TID_RU
    touch $targ_path/$basefile.csv
    for (( i=1; i<=$F_CNT ; i++ ));do
      filename=$basetid-$i$file_suffx.csv
      echo $filename
     if ! test -f $src_path/$basetid-$i$file_suffx.csv; then
#   cp -uv $src_path/$file_name $targ_path/$file_name
       echo "$basetid-$i$file_suffx.csv not found - MovDwnld abandoned."
       ~/sysprocs/LOGMSG "  $basetid-$i$file_suffx.csv not found - MovDwnld abandoned."
       exit 1
     fi
     $codebase/Projects-Geany/DwnldMgr/FixRUcsv.sh $basetid-$i$file_suffx $src_path
     cp -pv $src_path/$basetid-$i$file_suffx.csv $targ_path
     cat $targ_path/$basefile.csv $targ_path/$basetid-$i$file_suffx.csv \
       > $targ_path/$basefile.tmp
     mv $targ_path/$basefile.tmp $targ_path/$basefile.csv
    done;
    # remove headers at this point to preserve.csv file date.
    sed -i '/Last Name/ d' $targ_path/$basefile.csv
    echo "  ** WARNING - run *CatDwnld.sh immediately to preserve .csv dates **" 
   # insufficient file count.
   else
     echo "MovDwnld - must have file count >= 2 - abandoned."
     ~/sysprocs/LOGMSG " MovDwnld - must have file count >= 2 - abandoned."
     exit 1
   fi
  fi
  ;;
esac
#endprocbody
~/sysprocs/LOGMSG  "MovDwnld $P1 $P2 $P3 complete."
echo "  MovDwnld $P1  $P2 $P3 complete."
#end MovDwnld
