#!/bin/bash
# 2023-09-02   wmk.   (automated) ver2.0 path fixes.
# Del0Lens.sh - delete 0-length files from folder.
#	5/11/23.	wmk.
#
# Usage.  bash  Del0Lens.sh <folder> [<--dry-run>]
#
#	<folder> = folder from which to delete 0-length files.
#	<--dry-run> = [optional] if specified, list 0-length files without removing.
# Modification History.
# ---------------------
# 6/25/22.	wmk.	original code.
# 2/6/23.	wmk.	bug fix where --dry-run not listing files.
# 3/9/23.	wmk.	prompt before deleting "known" files ForceBuild and
#			 MissingIDs.csv
# 5/11/23.	wmk.	add Updt[1-9][0-9][0-9][MP].csv to known files list.
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
  export folderbase="/media/ubuntu/Windows"
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
awk '{ if ( $5 == "0" && substr($1,1,1) != "d" )print $8}' $TEMP_PATH/FileList.txt > $TEMP_PATH/ZeroLens.txt
# now loop deleting ZeroLens files.
dryrun=0
if [ ! -z "$P2" ];then
 echo "dry-run - the following files would be removed:"
 dryrun=1
fi
file=$TEMP_PATH/ZeroLens.txt
re=Updt[1-9][0-9][0-9][MP].csv
while read -e;do
 delflag=1
 echo " $REPLY"
 fname=$REPLY
 if [ "$fname" == "ForceBuild" ] || [ "$fname" == "MissingIDs.csv" ] \
    || [[ $fname =~ $re ]];then
  echo "  skipping $fname..."
  delflag=0
 fi
 if [ -z "$P2" ] && [ $delflag -ne 0 ] && [ $dryrun -eq 0 ];then
  rm -v $fname
 fi
done < $file
popd > $TEMP_PATH/scratchfile
echo "Del0Lens complete."
# end Del0Lens
