#!/bin/bash
# CloneSpecial.sh - Clone initial file set for territory SC Special processing.
#	5/10/23.	wmk.
#
#	Usage. bash CloneSpecial.sh  <srcterr> <targterr>
#		<srcterr> = territory ID to clone from
#		<targterr> = territory ID to clone into
#
# Dependencies.
#
#	Exit.	SPECIAL, RegenSpecDB.sq, SyncTerrToSpec.sq, MakeRegenSpecDB.tmp,
#			MakeSyncTerrToSpec.tmp, MakeSpecTerrQuery, MakeSetSpecTerrs.tmp,
#			SetSpecTerrs.sql
#			files copied from Terr<srcterr> to ~SCPA-Downloads/Terr<targterr>
#
# Modification History.
# ---------------------
# 9/23/22.  wmk.    (automated) CB *codebase env var support.
# 5/10/23.	wmk.	consistency corrections to always *sed .sql from source;
#			 bug fix srcpath in *sed SyncTerrToSpec.sql; mod to use -s for file
#			 check so will copy over 0-length files; comments tidied.
# Legacy mods.
# 6/19/22.	wmk.	original code; adapted from InitSpecial
# 1/25/23.	wmk.	comments tidied; jumpto references eliminated.
# Legacy mods.
# 4/12/22.	wmk.	modified for TX/HDLG/99999; HOME replaced with USER in host
#			 check.
# 5/15/22.  wmk.    (automated) pathbase corrected to FL/SARA/86777.
# 5/30/22.  wmk.    (automated) pathbase corrected to FL/SARA/86777.
# Legacy mods.
# 7/25/21.	wmk.	adapted from CloneSpecial.sh (RU).
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
P1=$1	# source territory ID
P2=$2	# target territory ID
if [ -z "$P1" ] || [ -z "$P2" ];then
 echo "CloneSpecial <srcterrid> <targterrid> missing parameter(s) - abandoned."
 exit 1
fi
local_debug=0	# set to 1 for debugging
#local_debug=1
#
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  bash ~/sysprocs/LOGMSG "   CloneSpecial initiated from Make."
  echo "   CloneSpecial initiated."
else
  bash ~/sysprocs/LOGMSG "   CloneSpecial initiated from Terminal."
  echo "   CloneSpecial initiated."
fi
TEMP_PATH=$HOME/temp
#
~/sysprocs/LOGMSG "  CloneSpecial $P1 $P2- initiated from Terminal."
echo "  CloneSpecial $P1 $P2 - initiated from Terminal"
#procbodyhere
targpath=$pathbase/RawData/SCPA/SCPA-Downloads/Terr$P2
srcpath=$pathbase/RawData/SCPA/SCPA-Downloads/Terr$P1
# SPECIAL
if test -s $targpath/SPECIAL;then 
 echo " SPECIAL already present - skipped."
else
# cp $srcpath/SPECIAL $targpath
 sed "s?$P1?$P2?g" $srcpath/SPECIAL > $targpath/SPECIAL
 echo "   SPECIAL copied."
fi
# RegenSpecDB
if test -s $targpath/RegenSpecDB.sql; then
 echo " RegenSpecDB.sql already exists - skipped. "
else
# cp $srcpath/RegenSpecDB.* $targpath
 sed "s?$P1?$P2?g" $srcpath/RegenSpecDB.sql > $targpath/RegenSpecDB.sql
 echo "   RegenSpecDB.sql copied."
fi
#   SyncTerrToSpec
if test -s $targpath/SyncTerrToSpec.sql; then
 echo " SyncTerrToSpec.sql already exists - skipped."
else
# cp $srcpath/SyncTerrToSpec.psq $targpath
 sed "s?$P1?$P2?g" $srcpath/SyncTerrToSpec.sql \
  > $targpath/SyncTerrToSpec.sql
 echo "   SyncTerrToSpec.psq copied."
fi
# MakeRegenSpecDB
if test -s $targpath/MakeRegenSpecDB; then
 echo " MakeRegenSpecDB already exists - skipped."
else
# cp $srcpath/MakeRegenSpecDB.tmp $targpath
 sed "s?$P1?$P2?g" $srcpath/MakeRegenSpecDB > $targpath/MakeRegenSpecDB
 echo "   MakeRegenSpecDB copied."
fi
#  MakeSyncTerrToSpec
if test -s $targpath/MakeSyncTerrToSpec; then
 echo " MakeSyncTerrToSpec already exists - skipped."
else
# cp $srcpath/MakeSyncTerrToSpec $targpath
 sed "s?$P1?$P2?g" $srcpath/MakeSyncTerrToSpec > $targpath/MakeSyncTerrToSpec
 echo "   MakeSyncTerrToSpec copied."
fi
# MakeSpecTerrQuery
if test -s $targpath/MakeSpecTerrQuery; then
 echo " MakeSpecTerrQuery already exists - skipped."
else
 cp $srcpath/MakeSpecTerrQuery $targpath
 # sed 's?$P1?$P2?g' $srcpath/MakeSpecTerrQuery > $targpath/MakeSpecTerrQuery
 echo "   MakeSpecTerrQuery copied."
fi
# SetSpecTerrs
if test -s $targpath/MakeSetSpecTerrs; then
 echo " MakeSetSpecTerrs already exists - skipped."
else
# cp $srcpath/MakeSetSpecTerrs $targpath
 sed "s?$P1?$P2?g" $srcpath/MakeSetSpecTerrs  > $targpath/MakeSetSpecTerrs
 echo "   MakeSetSpecTerrs copied."
fi
if test -s $targpath/MakeSpecials; then
 echo " MakeSpecials already exists - skipped."
else
# cp $srcpath/MakeSetSpecTerrs $targpath
 sed "s?$P1?$P2?g" $srcpath/MakeSpecials > $targpath/MakeSpecials
 echo "   MakeSpecials copied."
fi
if test -s $targpath/SetSpecTerrs.sql; then
 echo " SetSpecTerrs.sql already exists - skipped."
else
# cp $srcpath/SetSpecTerrs.sql  $targpath/SetSpecTerrs.sql
 sed "s?$P1?$P2?g" $srcpath/SetSpecTerrs.sql > $targpath/SetSpecTerrs.sql
 echo "   SetSpecTerrs.sql copied."
fi
#touch $targpath/Spec$P1SC.sql
fname=Spec
fsufx=SC
if test -s $targpath/$fname$P1$fsufx.sql; then
 echo " $fname$P1$fsufx.sql already exists - skipped."
else
 sed "s?$P1?$P2?g" $srcpath/SpecxxxSC.sql > $targpath/$fname$P1$fsufx.sql
 echo "   $fname$P1$fsufx.sql created."
fi
#endprocbody
echo "  CloneSpecial $P1 $P2 complete."
~/sysprocs/LOGMSG "CloneSpecial $P1 $P2 complete."
echo "  Now use 'sed' to change xxx to the territory ID in"
echo "  the RegenSpecDB.sq and SyncTerrToSpec.sq files"
echo "  and the MakeRegenSpecDB.tmp and MakeSyncTerrToSpec.tmp"
echo "  files to their respective files with no .tmp extensions."
echo "  Manually edit the <special-db> names into the RegenSpecDB.sq"
echo "  file ATTACH statements."
#end CloneSpecial

