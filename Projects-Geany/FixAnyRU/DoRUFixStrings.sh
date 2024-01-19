#!/bin/bash
echo " ** DoRUFixStrings.sh out-of-date **";exit 1
echo " ** DoRUFixStrings.sh out-of-date **";exit 1
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
# DoRUFixStrings.sh - use sed to globalize paths in files like FixyyyRU.sql.
# 4/25/22.	wmk.
#	Usage.	bash DoRUFixStrings.sh
#
#	Enttry.	file TIDList.txt - list of territory IDs to process on path
#			($)folderbase/Territories/Projects-Geany/FixAnyRU
#
# Modification History.
# ---------------------
# 4/25/22.	wmk.	modified for general use with *pathbase* env var.
# Legacy mods.
# 1/13/22.	wmk.	original code; adapted from DoRUSedPaths.
#
# Notes. DoRUFixStrings.sh changes all occurrences of paths
# containing (%)folderbase/Territories to ($)folderbase, and
# all errant strings where $ replaced %
# in all files FixyyyRU.sql whose yyy is in the TIDList.txt file
# and adds a header line with that noted.
function jumpto
{
    label=$1
    cmd=$(sed -n "/$label:/{:a;n;p;ba};" $0 | grep -v ':$')
    eval "$cmd"
    exit
}
P1=${1^^}
P2=${2^^}
P3=$3
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ];then
 echo "DoRUFixStrings <state> <county> <congno> missing parameter(s) - abandoned."
 exit 1
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
 export pathbase=$folderbase/Territories
fi
if [ -z "$congterr" ];then
 export congterr=FLSARA86777
fi
if [ "$P1$P2$P3" != "$congterr" ];then
 echo "*congterr* = :$congterr"
 echo "** $P1$P2$P3 mismatch with *congterr* - FlashBacks abandoned **"
 exit 1
fi
#
FIX_SUFFX="RU.sql"
#local_debug=0	# set to 1 for debugging
local_debug=1 
#proc body here
pushd ./ >> $TEMP_PATH/bitbucket.txt
error_counter=0		# set error counter to 0
IFS="&"			# set & as the word delimiter for read.
file=TIDList.txt
i=0
rm $TEMP_PATH/scratchfile
projpath=$codebase/Projects-Geany/FixAnyRU
cd $codebase/Projects-Geany/FixAnyRU
while read -e; do
  #reading each line
  echo " processing $REPLY " >> $TEMP_PATH/scratchfile
  len=${#REPLY}
  len1=$((len-1))
  firstchar=${REPLY:0:1}
#  echo "firstchar = '$firstchar'"
#  echo -e "  $firstchar\n is first char of line." >> $HOME/temp/scratchfile
  #expr index $string $substring
  if [ "$firstchar" = "#" ]; then			# skip comment
   echo $REPLY >> $HOME/temp/scratchfile
  else
   TID=${REPLY:0:len}
   pushd ./ > $TEMP_PATH/scratchfile.txt
   cd $pathbase/RawData/RefUSA/RefUSA-Downloads/Terr$TID
#   projpath/sestrfix.txt has sed directives.
   FBASE="Fix$TID"
   FN=$FBASE$FIX_SUFFX
   if test -f $FN;then
    echo "  processing $FN"
    sed -i -f $projpath/sedstrfix.txt $FN
   else
    echo "  $FN not found - skipped."
   fi
   popd >$TEMP_PATH/scratchfile.txt
  fi     # end is comment line conditional
#
i=$((i+1))
done < $file
echo " $i TIDList.txt lines processed."
#
echo "  DoRUFixStrings complete."
