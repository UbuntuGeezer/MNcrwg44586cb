#!/bin/bash
echo " ** MakeCodeSegment.sh out-of-date **";exit 1
# MakeCodeSegment.sh -  (Dev) Make code segments folders for cong territory.
# 4/28/23.	wmk.
#
#	Usage. bash MakeCodeSegment.sh [<state> <county> <congno>
#		<state> - 2 char state abbreviation
#		<county> - 4 char county abbreviation
#		<congno> - congregation number
#
#	Results.
#		GitHub/TerritoriesCB/<congno>/<county folder created
#		 if <congno> = 86777, only GitHub/TerritoriesCB folder created
#		GitHub/TerritoriesCB/<congno>/<county>/Procs-Dev folder created
#		GitHub/TerritoriesCB/<congno>/<county>/Projects-Geany folder created
#
# Dependencies.
# selected folder(s)
# files/tables used
# assumptions
#
# Modification History.
# ---------------------
# 4/28/23.	wmk.	original code; adpated from MakeRawData.
# Legacy mods.
# 2/20/23.	wmk.	*TID definition moved to top; notify-send removed; comments
#			 tidied.
# 4/27/23,	wmk.	*basemake introduced; Mapxxx_RU.csv and Mapxxx_SC.created
#			 empty to allow database
#			 initialization.
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
#
# Notes. MakeCodeSegment only creates the paths for the main code segment
# software. Two projects are created empty in Projects-Geany to facilitate
# importing a similar <congno><county> code segment via a tar archive
# reload: DocumentationCB, and ArchivingBackups. It is left to the system
# administrator to load these projects from another system and modify them
# if they are used as a basis for the new congregation territory.
#
# The code segment (and data segment) are specific for a <congno> and <county>.
# This is because congregation numbers must be separated on the master system,
# and counties must be separated if there are multiple counties within a <congno>
# assigned territory.
P1=${1^^}
P2=${2^^}
P3=$3
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ];then
 echo "MakeCodeSegment <state> <county> <congno> missing parameter(s) - abandoned."
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
#
if [ -z "$system_log" ];then
 export system_log=$folderbase/ubuntu/SystemLog.txt
fi
~/sysprocs/LOGMSG "  MakeCodeSegment $P1 $P2 $P3 - initiated from Terminal."
echo "  MakeCodeSegment $P1 $P2 $P3 - initiated from Terminal."  
#procbodyhere
pushd ./ >>junk.txt
#------------- new cong territory system ----------------
# this special-cases congno 86777, the original, but will make
# separate code base folder system GitHub/TerritoriesCB/<congno>/<county>
# for all other <congno> values.
if [ $basemake -ne 0 ]; then
 cd $folderbase
 echo "creating code segment..."
 if ! test -d $folderbase/GitHub;then
  echo " creating GitHub..."
  mkdir GitHub
 fi
 cd GitHub
 if ! test -d $folderbase/GitHub/TerritoriesCB;then
  echo " creating TerritoriesCB..."
  mkdir TerritoriesCB
 fi
 cd TerritoriesCB
 if [ "$P3" != "86777" ];then
  echo " creating $P3 codebase folder..."
  mkdir $P3
  cd $P3
  if ! test -d $P2;then
   echo " creating $P3/$P2 codebase folder..."
   mkdir $P2
  fi
  cd $P2
 fi
 if ! test -d Projects-Geany;then
  echo " creating Projects-Geany.."
  mkdir Projects-Geany
 fi
 if ! test -d Procs-Dev;then
  echo " creating Procs-Dev..."
  mkdir Procs-Dev
 fi
 cd Projects-Geany
 mkdir ArchivingBackups
 echo " Projects-Geany/ArchivingBackups folder created."
 mkdir DocumentationCB
 echo " Projects-Geany/DocumentationCB folder created."
 echo "code segment creation complete."
 echo " Reminder: still need data segment..."
fi		# end make new code segment...
#-------- make new data segment ------------
popd >>junk.txt
if test -f junk.txt;then
 rm junk.txt
fi
#endprocbody
~/sysprocs/LOGMSG "  MakeCodeSegment $P1 $P2 $P3 complete."
echo "  MakeCodeSegment $P1 $P2 $P3 complete."
#end MakeCodeSegment.sh 
