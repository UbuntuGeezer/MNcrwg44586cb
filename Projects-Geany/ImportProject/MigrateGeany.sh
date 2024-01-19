#!/bin/bash
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
# MigrateGeany.sh - shell template for MigrateGeany.sh
#	9/21/22.	wmk.
#
# Usage.	bash MigrateGeany.sh  <projname> [<targhost>]
#
#	<projname> = <projname>.geany source file to migrate
#	<targhost> = (optional) target host suffix to append to <projname>
#				  producing <projname><targhost>.geany
#				  valid values: "HP"  "WHP"
#				  "HP" is default
#	If <targhost> is specified, it takes precedence over the environment
#	var *hosttype*. (See Entry conditions below.)
#
# Entry. The files sedativesHP.txt and sedativesWHP.txt are the *sed*
#	utility directives files for migrating the .geany files.
#
#	If the environment var *hosttype* is defined, it will specify
# 	the host type (e.g. "HP" or "WHP"). The <targhost> parameter on the
# 	bash invocation will supercede the environment var spec.
#
# 	Environment var *folderbase* is the root directory that the
# 	target .geany file will substitute for the directory */home/vncwmk3*.
# 	The */home/vncwmk3* directory is the root directory for the ChromeBook
# 	system.
#
# The target Geany folder is always *pathbase*/Projects-Geany
#
# Modification History.
# ---------------------
# 5/28/22.	wmk.	modified for FL/SARA/86777.
# 9/21/22.	wmk.	CB added for Chromebook /GitHub conversion.
# Legacy mods.
# 3/30/22.	wmk.	original code.
# 4/6/22.	wmk.	*folderbase* improvements.
# 5/15/22.  wmk.   (automated) pathbase corrected to TX/HDLG/99999.
# 5/21/22.	wmk.	comments improved; mandatory parameters checked;
#			 sedativesHP.txt pathname fixes improved.
# 
# Notes.	for development purposes, the *HP* host will be considered
# the primary Geany files host. The ChromeBook host will continue to
# use the "vanilla" project names, since this is the preferred development
# host. The entire MigrateGeany project has been extended to facilitate
# recovery from a ChromeBook system crash onto the older HP laptop system.
#
# DoSed.sh in the project stores the project name and host suffix into
# the MigrateGeany.sh shell for execution. The MakeImportProject *makefile*
# completes the process of generating and executing the MigrateGeany.sh shell.
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
 echo "** Environment var *pathbase* not set - MigrateGeany.sh abandoned."
 exit 1
fi
P1=$1
P2=$2
host=${2^^}
if [ -z "$P1" ];then
 echo "MigrateGeany.sh  <project> [<host>] - missing parameter(s) - abandoned."
 exit 0
fi
if [ -z "$P2" ];then
 if [ -z "$hosttype" ];then
  P2=HP
 else
  P2=$hosttype
 fi
fi
echo "MigrateGeany will use project files from $pathbase..."
read -p " is this correct (y/n)? "
yn=${REPLY^^}
if [ "$yn" != "Y" ];then
 echo "MigrateGeany cancelled by user with *pathbase* conflict"
 exit 0
fi
echo "hosttype = ""$P2"" "
echo "MigrateGeany.sh initiated."
~/sysprocs/LOGMSG "  MigrateGeany.sh initiated."
projbase=$codebase/Projects-Geany/ImportProject
cd $codebase/Projects-Geany
if ! test -f $P1.geany;then
 echo "Cannot locate $P1.geany - MigrateGeany abandoned."
 ~/sysprocs/LOGMSG "  Cannot locate $P1.geany - MigrateGeany abandoned."
else
case $P2 in
"CB")
 echo " initiating CB GitHub conversion..."
 sed -f $projbase/sedativesCBG.txt \
  $P1.geany > $P1$P2.geany
 echo "MigrateGeany.sh $P1 $P2
 complete."
 ~/sysprocs/LOGMSG "  MigrateGeany.sh  $P1 $P2 complete.";;
"HP")
 echo " initiating HP conversion..."
 sed -f $projbase/sedativesHP.txt \
  $P1.geany > $P1$P2.geany
 echo "MigrateGeany.sh complete."
 ~/sysprocs/LOGMSG "  MigrateGeany.sh  $P1 $P2 complete.";;
"WHP")
 echo " initiating WHP conversion..."
 sed -f $projbase/sedativesWHP.txt \
  $P1.geany > $P1$P2.geany;;
*)
 echo "MigrateGeany - unrecognized target host option $P2 ... - abandoned."
 exit 1;;
esac
fi
exit 0
# end MigrateGeany.sh
