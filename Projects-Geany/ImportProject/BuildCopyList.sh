#!/bin/bash
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
# BuildCopyList.sh - Build list of files to copy to CopyFiles list.
#	9/20/22.	wmk.
#
# Usage.	bash BuildCopyList.sh  <source-path> <project-name>
#
#		<source-path> = full path to source project
#		<project-name> = name of project
#
# Entry.	*pathbase* env var set for current Territory system
#			/Projects-Geany/<source-project>.geany is the project properties
#			 source file to scan for FILE_NAME entries.
#
# Exit.	CopyFiles.txt in the ImportProject folder contains a list of the
#		filepaths for copy.
#
# Modification History.
# ---------------------
# 9/20/22.	wmk.	modified for Chromebook.
# Legacy mods.
# 5/28/22.	wmk.	modified for FL/SARA/86777.
# Legacy mods.
# 4/13/22.	wmk.	original code.
# 5/15/22.    wmk.   (automated) pathbase corrected to TX/HDLG/99999.
#
# Notes. Uses *awk* to extract lines with FILE_NAME, then converts the
# Geany pathnames to GNU/Linux pathnames or Windows pathnames, depending
# on the path separator (%2F - Linux, %5C - Windows).
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ]; then
  export folderbase="/media/ubuntu/Windows/Users/Bill"
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
P1=$1
P2=$2
# handle case where called from Make.
if [ -z "$system_log" ]; then
  export system_log="$folderbase/ubuntu/SystemLog.txt"
  ~/sysprocs/LOGMSG "   BuildCopyList initiated from Make."
else
  ~/sysprocs/LOGMSG "   BuildCopyList initiated from Terminal."
fi
TEMP_PATH=$HOME/temp
#proc body here
pushd ./ >> $TEMP_PATH/bitbucket.txt
echo "extracting paths from $P1/$P2.geany.."
echo $PWD
mawk -F ";" '/FILE_NAME/ {print $8}' $P1/$P2.geany > CopyFiles.txt
sed -i 's?%2F?/?g' CopyFiles.txt
#end proc body
~/sysprocs/LOGMSG " BuildCopyList $P1  $P2 complete."
echo " 	BuildCopyLisst $P1  $P2complete."
#end BuildCopyList proc.
