#!/bin/bash
echo " ** CatDwnld.sh out-of-date **";exit 1
echo " ** CatDwnld.sh out-of-date **";exit 1
# CatDwnld.sh - Concatenate special download(s) in RU/Special folder.
# 6/6/23.	wmk.
#
#  Usage. bash CatSpecDwnld.sh <terrid> [count]
#
#		<terrid> - territory ID (e.g. 102)
#		[count] - (optional) count of download filesl 1 assumed
#
#  Entry. Terr<terrid>_RU.csv exists in ~/RefUSA-Downloads/Downloads folder
#		OR if count nonempty, > 0
#       Terr<terrid>-1.csv .. Terr<terrid>-$count.csv files in /Downloads
#
#  CatSpecDwnld.sh concatenates download .csv files in the
#      Terr<terrid>-1..Terr<terrid>-n.csv
#  files are combined into Terr<terrid>_RU.csv
#
# Dependencies.
#	folder ~/RawData/RefUSA/RefUSA-Downloadsexists
#   files Terr<terrid>-1.csv .. Terr<terrid>-count.csv exist
#
# Modification History.
# ---------------------
# 6/6/23.	wmk.	OBSOLETE territory detection.
# Legacy mods.
# 9/23/22.  wmk.    (automated) CB *codebase env var support.
# 10/4/22.	wmk.	*pathbase corrected for CB system.
# 3/4/23.	wmk.	Note added on preserving .csv date; comments tidied.
# 3/6/23.	wmk.	bug fix where *file_sufx not being added; notify-send
#			 removed.
# Legacy mods.
# 4/25/22.	wmk.	original code;adapted from SpecDwnld version.
# Legacy mods.
# 11/8/21.	wmk.	original shell.
# 11/12/21.	wmk.	bug fix where 1st file not being cat,d.
# 11/29/21.	wmk.	bug fix in 'initiated' message.
# 12/21/21.	wmk.	tidy up superfluous touch.
# 12/28/21.	wmk.	notify-send conditional; change to use $ USER env var.
#
# Notes. CatSpecDwnld should be run IMMEDIATELY after the Mov..sh operation to
# preserve the .csv download date to match the individual download dates. The
# Mov..sh operation incorporates the *sed that removes header lines so that the
# individual downloads have their .csv date preserved also.
#
# *touch on the CB system does not create the file if it does not exist.
# this is compensated for by echoing '' to line 1, then deleting it later
# with *sed.
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
P2=$2
local_debug=0	# set to 1 for debugging
#local_debug=1
#
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "   CatDwnld initiated from Make."
  echo "   CatDwnld initiated."
else
  ~/sysprocs/LOGMSG "   CatSpecDwnld initiated from Terminal."
  echo "   CatDwnld initiated."
fi
TEMP_PATH=$HOME/temp
#
if [ -z "$P1" ]; then
  echo "  CatDwnld ignored.. must specify <terrid>." >> $system_log #
  echo "  CatDwnld ignored.. must specify <terrid>."
  exit 1
fi 
# this is always RU download
TYPE_=ru
if [ -z "$P2" ]; then
  F_CNT=0
else
  F_CNT=$P2
fi 
#
if [ $local_debug = 1 ]; then
 pushd ./
 cd ~/Documents		# write files to Documents folder
fi
~/sysprocs/LOGMSG "  CatDwnld $TID RU initiated."
echo "  CatDwnld $P1 $P2 initiated."
#procbodyhere env var TYPE_ is RU if needed.
 type_base=RawData/RefUSA/RefUSA-Downloads
 src_path=$pathbase/RawData/RefUSA/RefUSA-Downloads/Terr$P1
 targ_path=$pathbase/RawData/RefUSA/RefUSA-Downloads/Terr$P1
 file_suffx=_RU
 terr=Terr
 map=Map
 if test -f $pathbase/$rupath/Terr$P1/OBSOLETE;then
  echo " ** Territory $P1 OBSOLETE - CatDwnld exiting...**"
  exit 2
 fi
# conditionally loop on .csv files.
# look checking for all files before proceeding.
if [ $F_CNT -gt 1 ];then
 for (( i=1; i<=$F_CNT ; i++ ));do
  num=$i
  if ! test -f $src_path/$map$P1-$num$file_suffx.csv; then
    echo "$src_path/$map$P1-$num$file_suffx.csv not found - CatSpecDwnld abandoned."
    ~/sysprocs/LOGMSG "  $map$P1-$num$file_suffx.csv not found - CatDwnld abandoned."
    exit 1
  fi
 done;
# loop copying files.
 if test -f $src_path/$map$P1$file_suffx.csv;then
  rm $src_path/$map$P1$file_suffx.csv
 fi; 
 echo "" > $src_path/$map$P1$file_suffx.csv
 for (( i=1; i<=$F_CNT ; i++ ));do
   echo $map$P1-$i$file_suffx.csv
  if ! test -f $src_path/$map$P1-$i$file_suffx.csv; then
    echo "$src_path/$map$P1-$i$file_suffx.csv not found - CatSpecDwnld abandoned."
    ~/sysprocs/LOGMSG "  $map$P1-$i$file_suffx.csv not found - CatSpecDwnld abandoned."
    exit 1
  fi
  cat $src_path/$map$P1$file_suffx.csv $src_path/$map$P1-$i$file_suffx.csv \
    > $src_path/$map$P1$file_suffx.tmp
  mv $src_path/$map$P1$file_suffx.tmp $src_path/$map$P1$file_suffx.csv
  if [ $i -eq 1 ];then sed -i '1d' $src_path/$map$P1$file_suffx.csv;fi
 done;
# insufficient file count.
else
  echo "CatSpecDwnld - must have file count >= 2 - abandoned."
  ~/sysprocs/LOGMSG " CatSpecDwnld - must have file count >= 2 - abandoned."
  exit 1
fi
#end proc body
if [ $local_debug = 1 ]; then
  popd > $TEMP_PATH/scratchfile.txt
fi
~/sysprocs/LOGMSG  "CatDwnld $1 $2 complete."
echo "  CatDwnld $P1 $2 complete."
#end CatDwnld
