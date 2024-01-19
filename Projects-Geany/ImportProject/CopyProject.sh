#!/bin/bash
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
# CopyProject.sh - Copy all project files from CopyFiles.txt list.
#	9/20/22.	wmk.
#
# Usage.	bash CopyProject.sh <srcpath> <projname> [destpath]
#
#	<srcpath> = source project Geany path
#	<projname> = project name (e.g. DoTerrsWithCalcHP)
#	<destpath> = (optional) destination path (e.g. DoTerrsWithCalc)
#
# Entry. *pathbase* environment var set
#			*pathbase*/Projects-Geany/ImportProject/CopyFiles.txt is
#			 list of files to copy to *pathbase*/Projects-Geany/<projname>
#
# Exit. *pathbase*/Projects-Geany/<projname>.geany copied from srcpath
#		*pathbase*/Projects-Geany/<projname> folder has all files
#		 from CopyFiles.txt list, along with the CopyFiles.txt list
#
# Modification History.
# ---------------------
# 9/20/22.	wmk.	modified for Chromebook.
# Legacy mods.
# 5/28/22.	wmk.	modified for FL/SARA/86777.
# Legacy mods.
# 4/13/22.	wmk.	original code.
# 4/14/22.	wmk.	add -r copy to cover projects with embedded folders
#			 (e.g. DoTerrsWithCalc);add destpath 3rd parameter for cases
#			 where <projname> points to a different folder.
# 5/15/22.    wmk.   (automated) pathbase corrected to TX/HDLG/99999.
#
# Notes. Files are copied to <projname> folder without regard to
# their previous folder names. The <projname>/CopyFiles.txt list can
# be a guide to relocating copied files as necessary.
#
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
P3=$3
if [ -z "$P1" ] || [ -z "$P2" ];then
 echo "CopyProject  <geany-source>  <projname> missing parameter(s) - abandoned."
 exit 1
fi
if [ -z "$P3" ];then
 P3=$P2
fi
# handle case where called from Make.
if [ -z "$system_log" ]; then
  export system_log="$folderbase/ubuntu/SystemLog.txt"
  TEMP_PATH="$HOME/temp"
  ~/sysprocs/LOGMSG "   CopyProject initiated from Make."
else
  ~/sysprocs/LOGMSG "   CopyProject initiated from Terminal."
fi
TEMP_PATH=$HOME/temp
#proc body here
pushd ./ > $TEMP_PATH/scratchfile
# first copy .geany file
if ! test -f $P1/$P2.geany;then
 echo " ** CopyProject - $P1/$P2.geany not found, abandoned."
 ~/sysprocs/LOGMSG  " ** CopyProject - $P1/$P2.geany not found, abandoned."
 exit 1
fi
# copy .geany project file.
cp -uv $P1/$P2.geany ../
error_counter=0		# set error counter to 0
IFS="&"			# set & as the word delimiter for read.
file=CopyFiles.txt
if ! test -f $file;then
 echo "** Cannot find file $file - CopyProject abandoned. **"
 ~/sysprocs/LOGMSG "** Cannot find file $file - CopyProject abandoned. **"
 exit 1
fi
if ! test -d $codebase/Projects-Geany/$P3;then
 pushd ./ > $TEMP_PATH/scratchfile
 cd $codebase/Projects-Geany
 mkdir $P3
 popd > $TEMP_PATH/scratchfile
fi
# copy project folder(s).
pushd ./ > $TEMP_PATH/scratchfile
cd $P1
cp -ruv ./$P3 $codebase/Projects-Geany
popd > $TEMP_PATH/scratchfile
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
   echo $REPLY >> $TEMP_PATH/scratchfile
  else
   pname=${REPLY:0:len}
   cp -uv $pname $codebase/Projects-Geany/$P3
  fi     # end is comment line conditional

i=$((i+1))
done < $file
echo " $i CopyFiles.txt lines processed."
if [ $error_counter = 0 ]; then
  rm $TEMP_PATH/scratchfile
else
  echo "  $error_counter errors encountered - check $TEMP_PATH/scratchfile "
fi
popd > $TEMP_PATH/scratchfile
#end proc body
~/sysprocs/LOGMSG " CopyProject $P1  $P2 complete."
echo " 	CopyProject $P1  $P2 complete."
#end CopyProject proc.
	
