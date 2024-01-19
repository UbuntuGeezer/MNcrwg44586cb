#!/bin/bash
echo " ** DoRURedoFixes.sh out-of-date **";exit 1
echo " ** DoRURedoFixes.sh out-of-date **";exit 1
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
# DoRURedoFixes.sh - remove .sq and .sh FixyyyRU files from territory list.
# 1/13/22.	wmk.
#	Usage.	bash DoRURedoFixes.sh
#
#	Entry.	file TIDList.txt - list of territory IDs to process on path
#			($)folderbase/Territories/Projects-Geany/FixAnyRU
#
# Modification History.
# ---------------------
# 1/13/22.	wmk.	original code; adapted from DoRUSedPaths.
#
# Notes. DoRURedoFixes.sh removes .sh and .sq FixyyyRU files from territories
# forcing rebuild of FixyyyRU.sh.
function jumpto
{
    label=$1
    cmd=$(sed -n "/$label:/{:a;n;p;ba};" $0 | grep -v ':$')
    eval "$cmd"
    exit
}
P1=$1
TID=$P1
if [ "USER" = "ubuntu" ]; then
 folderbase="/media/ubuntu/Windows/Users/Bill"
else 
 folderbase=$HOME
fi
#
FIX_SUFFX1=RU.sh
FIX_SUFFX2=RU.sq
#local_debug=0	# set to 1 for debugging
local_debug=1 
#proc body here
pushd ./ >> $TEMP_PATH/bitbucket.txt
error_counter=0		# set error counter to 0
IFS="&"			# set & as the word delimiter for read.
file='TIDList.txt'
i=0
rm $TEMP_PATH/scratchfile
projpath=$folderbase/Territories/Projects-Geany/FixAnyRU
cd $folderbase/Territories/Projects-Geany/FixAnyRU
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
   cd $folderbase/Territories/RawData/RefUSA/RefUSA-Downloads/Terr$TID
#   projpath/sestrfix.txt has sed directives.
   FBASE="Fix$TID"
   FN=$FBASE$FIX_SUFFX1
   if test -f $FN;then
    echo "  removing $FN"
    rm $FN
   else
    echo "  $FN not found - skipped."
   fi
   FN=$FBASE$FIX_SUFFX2
   if test -f $FN;then
    echo "  removing $FN"
    rm $FN
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
echo "  DoRURedoFixes complete."
