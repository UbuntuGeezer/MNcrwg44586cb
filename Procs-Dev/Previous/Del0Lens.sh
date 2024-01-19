#!/bin/bash
# Del0Lens.sh - delete 0-length files from folder.
#	6/25/22.	wmk.
#
# Usage.  bash  Del0Lens.sh <folder> [<--dry-run>]
#
#	<folder> = folder from which to delete 0-length files.
#	<--dry-run> = [optional] if specified, list 0-length files.
P1=$1
P2=$2
if [ -z "$P1" ];then
 echo "Del0Lens <folder> [<--dry-run>] missing parameter(s) - abandoned."
 exit 1
fi
if ! test -d $P1;then
 echo "Del0Lens folder $P1 not found - abandoned."
 exit 1
fi
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ]; then
  export folderbase="/media/ubuntu/Windows/Users/Bill"
 else 
  export folderbase=$HOME
 fi
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories/FL/SARA/86777
fi
TEMP_PATH=$HOME/temp
pushd ./ > $TEMP_PATH/scratchfile
cd $P1
ls -lh > $TEMP_PATH/FileList.txt
awk '{ if ( $5 == "0" && substr($1,1,1) != "d" )print $9}' $TEMP_PATH/FileList.txt > $TEMP_PATH/ZeroLens.txt
# now loop deleting ZeroLens files.
file=$TEMP_PATH/ZeroLens.txt
while read -e;do
 echo " $REPLY"
 if [ -z "$P2" ];then
  rm -v $REPLY
 fi
done < $file
popd > $TEMP_PATH/scratchfile
echo "Del0Lens complete."
# end Del0Lens


