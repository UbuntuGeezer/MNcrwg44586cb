#!/bin/bash
# InitLetter - Initialize SC files in letter writing territory.
#	10/30/21.	wmk.
#
# Usage.	bash InitLetter.sh  <terrid>
#
#		<terrid> - territory ID for letter-writing territory (6xx)
#
# Exit.	Following files copied from SCNewLetter project to /SC-Downloads/Terryyy:
#
# Dependencies.
#
#	Exit.	LETTER, ~/Territory-PDFs/Letter_yyy.pdf, AddZips.sql, MakeAddZips
#			files copied to ~SCPA-Downloads/Terr<terrid>
#			~SCPA-Downloads/Terr<terrid>/Lettyyy_TS.pdf created.
#
# Modification History.
# ---------------------
# 2/21/23.	wmk.	*folderbase updated, *pathbase, *codebase added; notify-send
#			 removed; comments tidied.
# Legacy mods.
# 9/23/22.  wmk.    (automated) CB *codebase env var support.
# Legacy mods.
# 10/14/21.	wmk.	original code; adapted from InitLetter.
# 10/23/21.	wmk.	AddZips.sql, MakeAddZips added to files copied; projpath
#					environment var defined.
# 10/29/21.	wmk.	bug fix projpath being used for AddZips, MakeAddZips conditional;
#					'complete message' fixed.
# 10/30/21.	wmk.	code added to create Lettyyy_TS.pdf
#
if [ -z "$folderbase" ];then
 if [ "USER" = "ubuntu" ]; then
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
  bash ~/sysprocs/LOGMSG "   InitLetter (SC) initiated from Make."
  echo "   InitLetter (SC) initiated."
else
  bash ~/sysprocs/LOGMSG "   InitLetter (SC) initiated from Terminal."
  echo "   InitLetter (SC) initiated."
fi
#
if [ -z "$P1" ]; then
  echo "  InitLetter (SC) ignored.. must specify <terrid>." >> $system_log #
  echo "  InitLetter (SC) ignored.. must specify <terrid>."
  exit 1
else
  echo "  InitLetter (SC) $P1 - initiated from Terminal" >> $system_log #
  echo "  InitLetter (SC) $P1 - initiated from Terminal"
fi 
#
if [ $local_debug = 1 ]; then
 pushd ./
 cd ~/Documents		# write files to Documents folder
fi

#proc body here
dwnldpath=$pathbase/RawData/SCPA/SCPA-Downloads/Terr"$P1"
projpath=$codebase/Projects-Geany/SCNewLetter
if test -f $dwnldpath/LETTER;then 
 echo "  LETTER already present - skipped."
else
# cp LETTER $folderbase/$dwnldpath
 sed 's?yyy?$P1?g' LETTER > $dwnldpath/LETTER
 echo "LETTER copied."
fi
if test -f $pathbase/Territory-PDFs/Letter_"$P1".pdf; then
  if test -f $dwnldpath/Letter_"$P1".pdf; then
   echo "  Letter_"$P1".pdf already exists - skipped. "
  else
  # cp ~/Territory-PDFs/Letter_$P1.pdf $folderbase/$dwnldpath
   cp -pv $pathbase/Territory-PDFs/Letter_"$P1".pdf \
	 $dwnldpath
   echo "Letter_"$P1".pdf copied."
  fi
  fn2=Lett
  if test -f $dwnldpath/"$fn2$P1"_TS.pdf; then
   echo "  "$fn2$P1"_TS.pdf already exists - skipped. "
  else
   cp -pv $dwnldpath/Letter_"$P1".pdf \
    $dwnldpath/"$fn2$P1"_TS.pdf
   echo "$fn2$P1""_TS.pdf"" created."
  fi
else
  echo "  ** /Territory-PDFs/Letter_$P1.pdf not found - skipped **"
fi
if test -f $dwnldpath/AddZips.sql; then
 echo "  AddZips.sql already exists - skipped. "
else
# cp ~/projpath/AddZips.sql $folderbase/$dwnldpath
 sed "s?yyy?$P1?g" $projpath/AddZips.sql \
  > $dwnldpath/AddZips.sql
 echo "AddZips.sql copied."
fi
if test -f $dwnldpath/MakeAddZips; then
 echo "  MakeAddZips already exists - skipped. "
else
# cp ~/projpath/AddZips.sql $folderbase/$dwnldpath
 sed "s?yyy?$P1?g" $projpath/MakeAddZips \
  > $dwnldpath/MakeAddZips
 echo "MakeAddZips copied."
fi
#end proc body
if [ $local_debug = 1 ]; then
  popd
fi
echo "  InitLetter (SC) $P1 complete."
~/sysprocs/LOGMSG "InitLetter $P1 complete."
echo "  Now use Adobe/Reader and Calc to copy the letter writing addresses"
echo "  to a new sheet, saving the file as Lett$P1_TS.ods. Then edit the"
echo "  entries to proper columns and save as Lett$P1_TS.csv for import to"
echo "  Terr$P1_SC.db."
#end InitLetter

