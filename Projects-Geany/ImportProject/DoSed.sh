#!/bin/bash
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
# DoSed.sh - sed editing for CBtoHPgeany project.
#	9/20/22.	wmk.
#
# Usage.	bash DoSed.sh  srcpath projname [foldername]
#
#	<srcpath> = source path (usually a /Projects-Geany folder)
#	<projname> = project file to migrate
#	<foldername> = (optional) Projects-Geany folder to import files to
#
# Exit.	MakeImportProject.tmp -> MakeImportProject.
#
# Modification History.
# ---------------------
# 9/20/22.	wmk.	modified for Chromebooks.
# Legacy mods.
# 5/28/22.	wmk.	modified for FL/SARA/86777
# Legacy mods.
# 4/1/22.	wmk.	original code.
# 5/15/22.	wmk.	*pathbase*, *xpathbase* support.
P1=$1
P2=$2
P3=$3
# if called from Build menu, env vars not set.
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ];then
  export folderbase=/media/ubuntu/Windows/Users/Bill
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
if [ -z "$xpathbase" ];then
 export xpathbase=$folderbase/Territories
fi
# use *xpathbase*/Projects-Geany as default source path
if [ -z "$P1" ];then
 echo "  srcpath not specified - using *xpathbase*/Projects-Geany"
 P1=$xcodebase/Projects-Geany
fi
if [ -z "$P2" ];then
 echo "DoSed.sh  <srcpath> <projname> [<destpath>] missing parameter(s) - abandoned."
 exit 0
fi
if [ -z "$P3" ];then
 P3=$codebase/Projects-Geany/$P2
fi
sed "{s?<proj-name>?$P2?g;s?<source-path>?$P1?g;s?<dest-path>?$P3?g}" \
  MakeImportProject.tmp > MakeImportProject
# end DoSed.sh
