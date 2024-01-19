#!/bin/bash
# CreateDataSegment.sh -  (Dev) Make RawData folders for Terr xxx.
# 4/28/23.	wmk.
#
#	Usage. bash CreateDataSegment.sh  <state> <county> <congno>
#		<state> - 2 char state abbreviation
#		<county> - 4 char county abbreviation
#		<congno> - congregation number
#
#	Results.
#		Folder  ~/RawData/RefUSA/RefUSA-Downloads created
#			    ~/RawData/SCPA/SCPA-Downloads created
#				~/TerrData created
#			on path ~/Territories/FL/SARA/86777
#
# Dependencies.
# selected folder(s)
# files/tables used
# assumptions
#
# Modification History.
# ---------------------
# 4/28/23.	wmk.	original code; adapted from MakeRawData.
# Legacy mods.
# 2/20/23.	wmk.	*TID definition moved to top; notify-send removed; comments
#			 tidied.
# 4/27/23,	wmk.	*basemake introduced; Mapxxx_RU.csv and Mapxxx_SC.created
#			 empty to allow database initialization; support for P1=' ' to
#			 create initial data segment.
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
P1=${1^^}
P2=${2^^}
P3=$3
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ];then
 echo "CreateDataSegment <state> <county> <congno> missing parameter(s) - abandoned."
 exit 1
fi
basemake=1
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ]; then
  export folderbase=/media/ubuntu/Windows/Users/Bill
 else 
  export folderbase=$HOME
 fi
fi
if [ -z "codebase" ];then
 export codebase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$pathbase" ];then
  export pathbase=$folderbase/Territories/$P1/$P2/$P3
fi
#
if [ -z "$system_log" ];then
 export system_log=$folderbase/ubuntu/SystemLog.txt
fi
~/sysprocs/LOGMSG "  CreateDataSegment $P1 $P2 $P3 $P4 - initiated from Terminal."
echo "  CreateDataSegment $P1 $P2 $P3 - initiated from Terminal."  
#procbodyhere
pushd ./ >>junk.txt
#-------- make new data segment ------------
cd $folderbase
if ! test -d Territories;then
 mkdir Territories
fi
cd Territories
if ! test -d $P1;then
 mkdir $P1
fi
cd $P1
if ! test -d $P2;then
 mkdir $P2
fi
cd $P2
if ! test -d $P3;then
 mkdir $P3
fi
cd $P3
newpathbase=$folderbase/Territories/$P1/$P2/$P3
echo "PWD = '$newpathbase'"
# now have *newpathbase, create TerrData and RawData folders.
if ! test -d TerrData;then
 mkdir TerrData
fi
if ! test -d RawData;then
 mkdir RawData
fi
cd RawData
# create SCPA paths first.
if ! test -d SCPA;then
 mkdir SCPA
fi
cd SCPA
if ! test -d SCPA-Downloads;then
 mkdir SCPA-Downloads
fi
cd SCPA-Downloads
if ! test -d Previous;then
 mkdir Previous
fi
echo "RawData/SCPA paths created."
# create RefUSA paths.
cd $newpathbase/RawData
if ! test -d RefUSA;then
 mkdir RefUSA
fi
cd RefUSA
if ! test -d RefUSA-Downloads;then
 mkdir RefUSA-Downloads
fi
cd RefUSA-Downloads
if ! test -d Previous;then
 mkdir Previous
fi
echo "RawData/RefUSA paths created."
#-------- end make new data segment --------
#endprocbody
~/sysprocs/LOGMSG "  CreateDataSegment $P1 $P2 $P3 complete."
echo "  CreateDataSegment $P1 $P1 $P3 complete."
#end CreateDataSegment.sh 
