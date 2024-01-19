#!/bin/bash
#InitSpecial.sh - Create initial file set for territory SC Special processing.
#	6/5/23.	wmk.
#
#	Usage. bash InitSpecial.sh  <terrid>
#		<terrid> = territory ID  for which to create files.
#
# Dependencies.
#
#	Exit.	SPECIAL, RegenSpecDB.sq, SyncTerrToSpec.sq, MakeRegenSpecDB.tmp,
#			MakeSyncTerrToSpec.tmp, MakeSpecTerrQuery, MakeSetSpecTerrs.tmp,
#			SetSpecTerrs.sql
#			files copied to ~SCPA-Downloads/Terr<terrid>
#
# Modification History.
# ---------------------
# 6/5/23.	wmk.	OBSOLETE territory detection added.
# Legacy mods.
# 5/8/23.	wmk.	comments tidied.
# 5/9/23.	wmk.	procbodyhere, endprocbody corrected; blocks reordered and
#			 commented; notify-send removed.
# 5/10/23.	wmk.	bug fix missing \ in sed for SyncTerrToSpec.psq;
#			 MakeSyncTerrToSpec corrected to MakeSyncTerrToSpec.tmp in copy to
#			 target; use -s in file tests so will overwrite 0-length files.
# Legacy mods.
# 4/12/22.	wmk.	modified for TX/HDLG/99999; HOME replaced with USER in host
#			 check.
# 5/15/22.  wmk.    (automated) pathbase corrected to FL/SARA/86777.
# 5/30/22.  wmk.    (automated) pathbase corrected to FL/SARA/86777.
# 9/23/22.  wmk.    (automated) CB *codebase env var support.
# Legacy mods.
# 7/25/21.	wmk.	adapted from InitSpecial.sh (RU).
# 8/13/21.	wmk.	log message corrected; source paths for cp,s corrected;
#			 SpecxxxSC.sql touch added; add "copied" messages.
# 8/15/21.	wmk.	cp changed to sed for appropriate files' SetSpecTerrs.sql
#			 added to copied files; SpecxxxSC.sql created.
# 8/21/21.	wmk.	Exit files list updated.
# 8/22/21.	wmk.	RegenSpecDB.sc corrected to .sq; *s eliminated in names;
#			 "exists" message spacing standardized.
# 9/3/21.	wmk.	MakeSpecTerrQuery.tmp corrected to MakeSpecTerrQuery.
# 9/6/21.	wmk.	MakeSpecials copy added via sed.
# 11/2/21.	wmk.	RegenSpecDB.sq changed to .sql;xxx edited into
#			 SetSpecTerrs.sql. sed command strings " instead of '
#			 to force substitution for $ P1;yyy edited into SPECIAL.
# 11/27/21.	wmk.	bug fix MakeSetSpecTerrs.tmp not edited to MakeSetSpecTerrs
#			 in target directory.

# function definition
function jumpto
{
    label=$1
    cmd=$(sed -n "/$label:/{:a;n;p;ba};" $0 | grep -v ':$')
    eval "$cmd"
    exit
}
if [ -z "$folderbase" ];then
 if [ "$USER" = "ubuntu" ]; then
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
TEMP_PATH=$HOME/temp
#
P1=$1
local_debug=0	# set to 1 for debugging
#local_debug=1
#
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  bash ~/sysprocs/LOGMSG "   InitSpecial initiated from Make."
  echo "   InitSpecial initiated."
else
  bash ~/sysprocs/LOGMSG "   InitSpecial initiated from Terminal."
  echo "   InitSpecial initiated."
fi
TEMP_PATH=$HOME/temp
#
if [ -z "$P1" ]; then
  echo "  InitSpecial ignored.. must specify <terrid>." >> $system_log #
  echo "  InitSpecial ignored.. must specify <terrid>."
  exit 1
else
  echo "  InitSpecial $P1 - initiated from Terminal" >> $system_log #
  echo "  InitSpecial $P1 - initiated from Terminal"
fi 
#
if [ $local_debug = 1 ]; then
 pushd ./
 cd ~/Documents		# write files to Documents folder
fi
#
#procbodyhere
dwnldpath=$pathbase/RawData/SCPA/SCPA-Downloads/Terr$P1
projpath=$codebase/Projects-Geany/SpecialSCdb
# OBSOLETE
if test -f $dwnldpath/OBSOLETE;then
 echo " ** Territory $P1 OBSOLETE - SpecialSCdb/InitSpecial exiting..."
 exit 2
fi
# SPECIAL
if test -s $dwnldpath/SPECIAL;then 
 echo " SPECIAL already present - skipped."
else
# cp $projpath/SPECIAL $dwnldpath
 sed "s?yyy?$P1?g" $projpath/SPECIAL \
   > $dwnldpath/SPECIAL
 echo "   SPECIAL copied."
fi
# RegenSpecDB
if test -s $dwnldpath/RegenSpecDB.sql; then
 echo " RegenSpecDB.sql already exists - skipped. "
else
# cp $projpath/RegenSpecDB.* $dwnldpath
 sed "s?xxx?$P1?g" $projpath/RegenSpecDB.psq \
  > $dwnldpath/RegenSpecDB.sql
 echo "   RegenSpecDB.sql copied."
fi
# SetSpecTerrs
if test -s $dwnldpath/SetSpecTerrs.sql; then
 echo " SetSpecTerrs.sql already exists - skipped."
else
# cp $projpath/SetSpecTerrs.sql  $dwnldpath/SetSpecTerrs.sql
 sed "s?xxx?$P1?g" $projpath/SetSpecTerrs.sql \
  > $dwnldpath/SetSpecTerrs.sql
 echo "   SetSpecTerrs.sql copied."
fi
#   SyncTerrToSpec
if test -s $dwnldpath/SyncTerrToSpec.sql; then
 echo " SyncTerrToSpec.sql already exists - skipped."
else
# cp $projpath/SyncTerrToSpec.psq $dwnldpath
 sed "s?xxx?$P1?g" $projpath/SyncTerrToSpec.psq \
  > $dwnldpath/SyncTerrToSpec.sql
 echo "   SyncTerrToSpec.psq copied."
fi
# MakeSetSpecTerrs
if test -s $dwnldpath/MakeSetSpecTerrs; then
 echo " MakeSetSpecTerrs already exists - skipped."
else
# cp $projpath/MakeSetSpecTerrs.tmp $dwnldpath
 sed "s?xxx?$P1?g" $projpath/MakeSetSpecTerrs.tmp  \
  > $dwnldpath/MakeSetSpecTerrs
 echo "   MakeSetSpecTerrs copied."
fi
#  MakeSyncTerrToSpec
if test -s $dwnldpath/MakeSyncTerrToSpec; then
 echo " MakeSyncTerrToSpec already exists - skipped."
else
# cp $projpath/MakeSyncTerrToSpec.tmp $dwnldpath
 sed "s?xxx?$P1?g" $projpath/MakeSyncTerrToSpec.tmp \
  > $dwnldpath/MakeSyncTerrToSpec
 echo "   MakeSyncTerrToSpec copied."
fi
# MakeSpecTerrQuery
if test -s $dwnldpath/MakeSpecTerrQuery; then
 echo " MakeSpecTerrQuery already exists - skipped."
else
 cp $projpath/MakeSpecTerrQuery $dwnldpath
 # sed 's?xxx?$P1?g' $projpath/MakeSpecTerrQuery.tmp > $dwnldpath/MakeSpecTerrQuery
 echo "   MakeSpecTerrQuery copied."
fi
# MakeRegenSpecDB
if test -s $dwnldpath/MakeRegenSpecDB; then
 echo " MakeRegenSpecDB.tmp already exists - skipped."
else
 cp $projpath/MakeRegenSpecDB.tmp $dwnldpath
 sed "s?xxx?$P1?g" $projpath/MakeRegenSpecDB.tmp \
  > $dwnldpath/MakeRegenSpecDB
 echo "   MakeRegenSpecDB.tmp copied."
fi
# MakeSpecials
if test -s $dwnldpath/MakeSpecials; then
 echo " MakeSpecials already exists - skipped."
else
# cp $projpath/MakeSpecials $dwnldpath
 sed "s?xxx?$P1?g" $projpath/MakeSpecials \
  > $dwnldpath/MakeSpecials
 echo "   MakeSpecials copied."
fi
#touch $dwnldpath/Spec$P1SC.sql
# SpecxxxSC.sql
fname=Spec
fsufx=SC
if test -s $dwnldpath/$fname$P1$fsufx.sql; then
 echo " $fname$P1$fsufx.sql already exists - skipped."
else
 sed "s?xxx?$P1?g" $projpath/SpecxxxSC.sql \
  > $dwnldpath/$fname$P1$fsufx.sql
 echo "   $fname$P1$fsufx.sql created."
fi
#endprocbody
if [ $local_debug = 1 ]; then
  popd
fi
jumpto EndProc
EndProc:
echo "  InitSpecial $P1 complete."
~/sysprocs/LOGMSG "InitSpecial $P1 complete."
echo "  Now use 'sed' to change xxx to the territory ID in"
echo "  the RegenSpecDB.sq and SyncTerrToSpec.sq files"
echo "  and the MakeRegenSpecDB.tmp and MakeSyncTerrToSpec.tmp"
echo "  files to their respective files with no .tmp extensions."
echo "  Manually edit the <special-db> names into the RegenSpecDB.sq"
echo "  file ATTACH statements."
#end InitSpecial

