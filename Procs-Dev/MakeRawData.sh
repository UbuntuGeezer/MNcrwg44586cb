#!/bin/bash
echo " ** MakeRawData.sh out-of-date **";exit 1
# MakeRawData.sh -  (Dev) Make RawData folders for Terr xxx.
# 4/28/23.	wmk.
#
#	Usage. bash MakeRawData.sh terrid [<state> <county> <congno>]
#		terrid  - territory id
#		<state> - 2 char state abbreviation
#		<county> - 4 char county abbreviation
#		<congno> - congregation number
#
#	Results.
#		Folder Terrxxx created in ~/RawData/RefUSA/RefUSA-Downloads
#			and ~/RawData/SCPA/SCPA-Downloads folders
#			on path ~/Territories
#		Folders Terrxxx and Terrxxx/Previous created in
#		    ~/RawData/RefUSA/RefUSA-Downloads
#			and ~/RawData/SCPA/SCPA-Downloads folders
#			on path ~/Territories
#		files Mapxxx_RU.csv and Mapxxx_SC.csv created empty in
#			RawData territory download folders
#
# Dependencies.
# selected folder(s)
# files/tables used
# assumptions
#
# Modification History.
# ---------------------
# 2/20/23.	wmk.	*TID definition moved to top; notify-send removed; comments
#			 tidied.
# 4/27/23,	wmk.	*basemake introduced; Mapxxx_RU.csv and Mapxxx_SC.created
#			 empty to allow database initialization; support for P1=' ' to
#			 create initial data segment.
# 4/28/23.	wmk.	bug fix *fdata corrected in SC section; remove create
#			 initial data segment code to
#			 NewTerritory/CreateDataSegment.sh
# Legacy mods.
# 4/3/22.	wmk.	<state> <county> <congno> parameters support; HOME
#			 changed to USER in host check.
# 4/7/22.	wmk.	folderbase improvements; *pathbase* support.
# 4/10/22.	wmk.	remove *jumpto* function.
# Legacy mods.
# 1/8/21.	wmk.	original shell
# 5/30/21.	wmk.	modified for multihost system support.
# 6/17/21.	wmk.	bug fixes; ($)folderbase not substituted within ';
#					changed from cd to test in directory conditional;
#					multihost code generalized.
# 6/27/21.	wmk.	superfluous "s removed; LOGMSG used.
# 8/29/21.	wmk.	added /Terrxxx and /Terrxxx/Previous folders to
#					subdirectories created for downstream support; cd,s
#					replaced with test -d; superfluous "s removed.
P1=$1
P2=${2^^}
P3=${3^^}
P4=$4
TID=$P1
if [ -z "$P1" ] || [ "$P1" == " " ];then
 echo "MakeRawData <terrid> [<state> <county> <congo>] missing parameter(s) - abandoned."
 exit 1
fi
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ]; then
  export folderbase=/media/ubuntu/Windows/Users/Bill
 else 
  export folderbase=$HOME
 fi
fi
if [ -z "$system_log" ]; then
 system_log=$folderbase/ubuntu/SystemLog.txt
fi
if [ -z "codebase" ];then
 export codebase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$pathbase" ];then
  export pathbase=$folderbase/Territories/$P2/$P3/$P4
fi
if [ ! -z "$P2" ];then
  if [ "$pathbase" != "$folderbase/Territories/$P2/$P3/$P4" ];then
   echo $pathbase
   echo "  MakeRawData *pathbase* does not match $folderbase/Territories/$P2/$P3/$P4 - abandoned."
   exit 1
  fi
fi
#
if [ -z "$system_log" ];then
 export system_log=$folderbase/ubuntu/SystemLog.txt
fi
~/sysprocs/LOGMSG "  MakeRawData $P1 $P2 $P3 $P4 - initiated from Terminal."
echo "  MakeRawData $P1 $P2 $P3 $P4 - initiated from Terminal."  
#procbodyhere
pushd ./ >>junk.txt
#  echo "  MakeRawData $1 - initiated from Terminal" >> $system_log #
cd $pathbase/RawData
TERR_BASE3=RefUSA/RefUSA-Downloads/Terr$TID
TERR_BASE5=RefUSA/RefUSA-Downloads/Terr$TID/Previous
TERR_BASE2=SCPA/SCPA-Downloads/TErr$TID
TERR_BASE4=SCPA/SCPA-Downloads/Terr$TID
TERR_BASE6=SCPA/SCPA-Downloads/Terr$TID/Previous
# ensure all RU paths exist with empty Mapxxx_RU.csv
fbase=Map$TID
fsuffx=.csv
cd $pathbase/$rupath
echo "changed to $PWD..."
fdata=_RU
if  test -d Terr$TID  ; then
 echo "  Terr$TID already exists.. skipped"
else
 mkdir Terr$TID
 echo "  $rupath/Terr$TID created."
 cd Terr$TID
 touch $fbase$fdata$fsuffx
 mkdir Previous
fi

# ensure all SC paths exist
cd $pathbase/$scpath
fdata=_SC
if  test -d Terr$TID  ; then
 touch $fbase$fdata$fsuffx
 echo "  Terr$TID already exists.. skipped"
else
 mkdir Terr$TID
 echo "  $scpath/Terr$TID created."
 cd Terr$TID
 touch $fbase$fdata$fsuffx
 mkdir Previous
fi
popd >>junk.txt
if test -f junk.txt;then
 rm junk.txt
fi
#endprocbody
~/sysprocs/LOGMSG "  MakeRawData $TID $P2 $P3 $P4 complete."
echo "  MakeRawData $TID $P2 $P3 $P4 complete."
#end MakeRawData.sh 
