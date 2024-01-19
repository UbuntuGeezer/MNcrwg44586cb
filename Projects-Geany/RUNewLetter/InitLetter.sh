#!/bin/bash
# InitLetter - Initialize RU files in letter writing territory.
#	10/27/21.	wmk.
#
# Usage.	bash InitLetter.sh  <terrid>
#
#		<terrid> - territory ID for letter-writing territory (6xx)
#
# Exit.	Following files copied from RUNewLetter project to /RefUSA-Downloads/Terryyy:
#
# Dependencies.
#
#	Exit.	LETTER, ~/Territory-PDFs/Letter_yyy.pdf, AddZips.sql, MakeAddZips
#			files copied to ~RefUSA-Downloads/Terr<terrid>
#
# Modification History.
# ---------------------
# 2/21/23.	wmk.	*folderbase updated; *pathbase, *codebase support; notify-send
#			 removed; comments tidied.
# Legacy mods.
# 9/23/22.  wmk.    (automated) CB *codebase env var support.
# Legacy mods.
# 10/14/21.	wmk.	original code; adapted from InitLetter.
# 10/22/21.	wmk.	AddZips.sql, MakeAddZips added to proc.
# 10/23/21.	wmk.	comments corrected to reflect RefUSA folders; projpath
#					added to commands to support parent Make call; ensure
#					RefUSA-Downloads/Terr<terrid> exists.
# 10/25/21.	wmk.	AddZips, MakeAddZips source path corrected;AddZips sed
#					corrected to change xxx.
# 10/27/21.	wmk.	bug fix line 70 cd ./($)P1 corrected to Terr($)P1.
#
if [ -z "$folderbase" ];then
 if [ "$USER" = "ubuntu" ]; then
  export folderbase=/media/ubuntu/Windows/Users/Bill
 else 
  export folderbase=$HOME
 fi
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories/FL/SARA/86777
fi
if [ -z "$codebase" ];then
 export codebase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$system_log" ]; then
 system_log=$folderbase/ubuntu/SystemLog.txt
fi
#
P1=$1
local_debug=0	# set to 1 for debugging
#local_debug=1
#
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  TEMP_PATH=$HOME/temp
  bash ~/sysprocs/LOGMSG "   InitLetter (RU) initiated from Make."
  echo "   InitLetter (RU) initiated."
else
  bash ~/sysprocs/LOGMSG "   InitLetter (RU) initiated from Terminal."
  echo "   InitLetter (RU) initiated."
fi
#
if [ -z "$P1" ]; then
  echo "  InitLetter (RU) ignored.. must specify <terrid>." >> $system_log #
  echo "  InitLetter (RU) ignored.. must specify <terrid>."
  exit 1
else
  echo "  InitLetter (RU) $P1 - initiated from Terminal" >> $system_log #
  echo "  InitLetter (RU) $P1 - initiated from Terminal"
fi 
#
if [ $local_debug = 1 ]; then
 pushd ./
 cd ~/Documents		# write files to Documents folder
fi

#procbodyhere
dwnldpath=$pathbase/RawData/RefUSA/RefUSA-Downloads/Terr$P1
projpath=$codebase/Projects-Geany/RUNewLetter
if test -f $dwnldpath/OBSOLETE;then
 echo " ** Territory $P1 OBSOLETE - InitLetter.sh exiting..."
 exit 2
fi
if ! test -d $dwnldpath;then
 cd $pathbase/RawData/RefUSA/RefUSA-Downloads
 mkdir Terr$P1
 cd ./Terr$P1
 mkdir ./Previous
fi
if test -f $dwnldpath/LETTER;then 
 echo "  LETTER already present - skipped."
else
# cp LETTER $folderbase/$dwnldpath
 sed "s?yyy?$P1?g" $projpath/LETTER > $dwnldpath/LETTER
 echo "LETTER copied."
fi
if test -f $pathbase/Territory-PDFs/Letter_$P1.pdf; then
  if test -f $dwnldpath/Letter_$P1.pdf; then
   echo "  Letter_$P1.pdf already exists - skippped. "
  else
  # cp ~/Territory-PDFs/Letter_$P1.pdf $folderbase/$dwnldpath
   cp -pv $pathbase/Territory-PDFs/Letter_$P1.pdf \
	 $dwnldpath
   echo "Letter_$P1.pdf copied."
  fi
else
  echo "  ** /Territory-PDFs/Letter_$P1.pdf not found - skipped **"
fi
if test -f $dwnldpath/AddZips.sql; then
   echo "  Terr$P1/AddZips.sql already exists - skipped. "
else
   sed "s?xxx?$P1?g" $projpath/AddZips.sql > $dwnldpath/AddZips.sql
   echo "AddZips.sql copied."
fi
if test -f $dwnldpath/MakeAddZips; then
   echo "  Terr$P1/MakeAddZips already exists - skipped. "
else
   sed "s?yyy?$P1?g" $projpath/MakeAddZips > $dwnldpath/MakeAddZips
   echo "MakeAddZips copied."
fi
#end proc body
if [ $local_debug = 1 ]; then
  popd
fi
echo "  InitLetter (RU) $P1 complete."
~/sysprocs/LOGMSG "InitLetter $P1 complete."
echo "  Now use Adobe/Reader and Calc to copy the letter writing addresses"
echo "  to a new sheet, saving the file as Lett$P1_TS.ods. Then edit the"
echo "  entries to proper columns and save as Lett$P1_TS.csv for import to"
echo "  Terr$P1_SC.db."
#end InitLetter
