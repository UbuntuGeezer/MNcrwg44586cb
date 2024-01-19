#!/bin/bash
echo " ** InitSpecial.sh out-of-date **";exit 1
echo " ** InitSpecial.sh out-of-date **";exit 1
#InitSpecial.sh - Create initial file set for territory RU Special processing.
# 7/2/23.	wmk.
#
#	Usage. bash InitSpecial.sh  <terrid> [<special-db>] [<mhp-parcelid>]
#		<terrid> = territory ID  for which to create files.
#		<special-db> = (optional) MHP database name (e.g. BayIndiesMHP)
#		<mhp-parcelid> = (optional) MHP property ID (e.g. 0403130002)
#		/Projects-Geany/RUNewLetter/AddZips.sql MakeAddZips = code to
#		  add zip codes to letter-writing territories 6xx
#
# Dependencies.
#
#	Exit.	SPECIAL, RegenSpecDB.*, SyncTerrToSpec.*, MakeRegenSpecDB,
#			MakeSyncTerrToSpec, SpecxxxRU.sql, MakeSpecTerrQuery files copied
#			to ~RefUSA-Downloads/Terr<terrid>
#
# Modification History.
# ---------------------
# 6/5/23.	wmk.	OBSOLETE territory detection added; comments tidied.
# 7/2/23.	wmk.	NOMAP territory detection added;
# Legacy mods.
# 4/24/22.	wmk.	code generalized for FL/SARA/86777;*pathbase*, 
#			 *congterr*, *conglib* env vars introduced.
# 4/26/22.	wmk.	minor corrections.
# 5/29/22.	wmk.	bug fix terrs 268, 269 SpecRU.MHP.sql not being copied;
#			 bug fix - removed sedMakeSpecials.txt edit of MHP MakeSpecials.  
# 9/23/22.  wmk.   (automated) CB *codebase env var support.
# 10/4/22.  wmk.   (automated) fix *pathbase for CB system.
# Legacy mods.
# 6/28/21.	wmk.	original code (multihost support).
# 7/6/21.	wmk.	multihost code generalized.
# 8/15/21.	wmk.	change to sed to preset territory in copied files;
#					superfluous "s removed; SetSpecTerrs.sql added.
# 8/16/21.	wmk.	SpecxxxRU.sql added to copied files.
# 8/21/21.	wmk.	MakeSpecTerrQuery added to copied files.
# 9/5/21.	wmk.	MakeSpecials added to copied files.
# 9/9/21.	wmk.	conditional added for MakeSetSpecTerrs, MakeSetMHPSpecTerrs.
# 9/10/21.	wmk.	268, 269 BayIndies exceptions added to conditional.
# 9/12/21.	wmk.	postrun message changed to use InitSpecSed project;
#					MakeSetMHPSpecTerrs conditional corrected; message
#					indentation	made consistent; jumpto funcion removed.
# 10/12/21.	wmk.	change to use RegenSpecDB.sql in place of RegenSpecDB.sq;
#					use SyncTerrToSpec.sql in place of SyncTerrToSpec.sq.
# 10/13/21.	wmk.	MakeSetSpecials message corrected to MakeSpecials.
# 10/14/21.	wmk.	message spacing adjustments.
# 10/24/21.	wmk.	Specialxxx.dblist.txt added to file list copied; altprojbase
#					var added; AddZips, MakeAddZips conditional for letter
#					territories.
# 10/25/21.	wmk.	bug fixes where sed regexp string in 's not allowing P1 env
#					var to substitute; copy Specialxxx.dblist.txt keeping name,
#					but editing yyy	to territory ID to provide generic code for
#					InitSedEdit.
# 11/12/21.	wmk.	MHP territory ID conditional to copy different files for
#					RegenSpecDB, Specxxx.sql for terrids 235-251, 268, 269, 
#					261-264,317-321.
# 11/13/21.	wmk.	MHP territory ID conditional supporting P2 = <special-db>,
#					P3 = owningparcel; automate MakeSpecials editing for MHP.
# 11/14/21.	wmk.	bug fix change 318 lower bound to 317.
# 12/28/21.	wmk.	notify-send conditional; change to use $ USER env var.
#
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ];then
  export folderbase=/media/ubuntu/Windows/Users/Bill
   terrbase=/media/ubuntu/Windows/Users/Bill
 else
  export folderbase=$HOME
   terrbase=$HOME
 fi
fi
if [ -z "$codebase" ];then
 codebase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories/FL/SARA/86777
fi
if [ -z "$congterr" ];then
 export congterr=FLSARA86777
fi
if [ -z "$conglib" ];then
 export conglib=FLsara86777
fi
#
P1=$1
P2=$2
P3=$3
local_debug=0	# set to 1 for debugging
#local_debug=1
#
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "   InitSpecial initiated from Make."
  echo "   InitSpecial initiated."
else
  ~/sysprocs/LOGMSG "   InitSpecial initiated from Terminal."
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
#procbodyhere
dwnldpath=$pathbase/RawData/RefUSA/RefUSA-Downloads/Terr$P1
if test -f $dwnldpath/OBSOLETE;then
 echo " ** Territory $P1 OBSOLETE - InitSpecial exiting.. **"
 exit 2
fi
altprojbase=$codebase/Projects-Geany
firstchartid=${P1:0:1}
if test -f $dwnldpath/SPECIAL;then 
 echo "  SPECIAL already present - skipped."
else
# cp SPECIAL $dwnldpath
 sed "{s?xxx?$P1?g;s?\$P1?$P1?g}" SPECIAL > $dwnldpath/SPECIAL
 echo "SPECIAL copied."
fi
if test -f $dwnldpath/RegenSpecDB.sql; then
 echo "  RegenSpecDB.sql already exists - skippped. "
else
# cp RegenSpecDB.sql $dwnldpath
 if [ $P1 -ge 235 ] && [ $P1 -le 251 ];then
  sed "s?xxx?$P1?g" RegenSpecDB.MHP.sql > $dwnldpath/RegenSpecDB.sql
  if [ ! -z "$P2" ];then
   sed -i "s?<special-db>?$P2?g" $dwnldpath/RegenSpecDB.sql
  fi
  if [ ! -z "$P3" ];then
   sed -i "s?<mhp-parcelid>?$P3?g" $dwnldpath/RegenSpecDB.sql
  fi
 elif [ $P1 -eq 268 ] || [ $P1 -eq 269 ];then
  sed "s?xxx?$P1?g" RegenSpecDB.MHP.sql > $dwnldpath/RegenSpecDB.sql
  if [ ! -z "$P2" ];then
   sed -i "s?<special-db>?$P2?g" $dwnldpath/RegenSpecDB.sql
  fi
  if [ ! -z "$P3" ];then
   sed -i "s?<mhp-parcelid>?$P3?g" $dwnldpath/RegenSpecDB.sql
  fi
 elif [ $P1 -ge 261 ] && [ $P1 -le 264 ];then
  sed "s?xxx?$P1?g" RegenSpecDB.MHP.sql > $dwnldpath/RegenSpecDB.sql
  if [ ! -z "$P2" ];then
   sed -i "s?<special-db>?$P2?g" $dwnldpath/RegenSpecDB.sql
  fi
  if [ ! -z "$P3" ];then
   sed -i "s?<mhp-parcelid>?$P3?g" $dwnldpath/RegenSpecDB.sql
  fi
 elif [ $P1 -ge 317 ] && [ $P1 -le 321 ];then 
  sed "s?xxx?$P1?g" RegenSpecDB.MHP.sql > $dwnldpath/RegenSpecDB.sql
  if [ ! -z "$P2" ];then
   sed -i "s?<special-db>?$P2?g" $dwnldpath/RegenSpecDB.sql
  fi
  if [ ! -z "$P3" ];then
   sed -i "s?<mhp-parcelid>?$P3?g" $dwnldpath/RegenSpecDB.sql
  fi
 else
   sed "s?xxx?$P1?g" RegenSpecDB.sql > $dwnldpath/RegenSpecDB.sql
 fi
 echo "RegenSpecDB.sql copied."
fi
# determine if NOMAP territory and copy appropriate Sync query.
if test -f $dwnldpath/NOMAP;then
 if test -f $dwnldpath/SyncNOMAPTerr.sql; then
  echo "  SyncNOMAPTerr.* already exists - skipped."
 else
  # cp SyncNOMAPTerr.* $dwnldpath
  sed "{s?xxx?$P1?g}" SyncNOMAPTerr.psq \
   > $dwnldpath/SyncNOMAPTerr.sql
  echo "SyncNOMAPTerr.sql copied."
 fi
else
 if test -f $dwnldpath/SyncTerrToSpec.sql; then
  echo "  SyncTerrToSpec.* already exist - skipped."
 else
  # cp SyncTerrToSpec.* $dwnldpath
  sed "{s?xxx?$P1?g;s?\$P1?$P1?g}" SyncTerrToSpec.sql \
   > $dwnldpath/SyncTerrToSpec.sql
  echo "SyncTerrToSpec.sql copied."
 fi
fi	# NOMAP conditional
if test -f $dwnldpath/MakeRegenSpecDB; then
 echo "  MakeRegenSpecDB already exists - skipped."
else
 cp MakeRegenSpecDB.tmp $dwnldpath
 sed "s?xxx?$P1?g" MakeRegenSpecDB.tmp > $dwnldpath/MakeRegenSpecDB
 echo "MakeRegenSpecDB copied."
fi
f1=Spec$P1
f2=RU.sql
if test -f $dwnldpath/$f1$f2; then
 echo "  $f1$f2 exists - skipped."
else
 fname=Spec$P1
 fsufx=RU
 if [ $P1 -ge 235 ] && [ $P1 -le 251 ];then
  sed "s?xxx?$P1?g" SpecxxxRU.sql > $dwnldpath/$fname$fsufx.MHP.sql
  if [ ! -z "$P2" ];then
   sed -i "s?<special-db>?$P2?g" $dwnldpath/$fname$fsufx.MHP.sql
  fi
  if [ ! -z "$P3" ];then
   sed -i "s?<mhp-parcelid>?$P3?g" $dwnldpath/$fname$fsufx.MHP.sql
  fi
 elif [ $P1 -eq 268 ] || [ $P1 -eq 269 ];then
  sed "s?xxx?$P1?g" SpecxxxRU.sql > $dwnldpath/$fname$fsufx.MHP.sql
  if [ ! -z "$P2" ];then
   sed -i "s?<special-db>?$P2?g" $dwnldpath/$fname$fsufx.MHP.sql
  fi
  if [ ! -z "$P3" ];then
   sed -i "s?<mhp-parcelid>?$P3?g" $dwnldpath/$fname$fsufx.MHP.sql
  fi
 elif [ $P1 -ge 261 ] && [ $P1 -le 264 ];then
  sed "s?xxx?$P1?g" SpecxxxRU.sql > $dwnldpath/$fname$fsufx.MHP.sql
  if [ ! -z "$P2" ];then
   sed -i "s?<special-db>?$P2?g" $dwnldpath/$fname$fsufx.MHP.sql
  fi
  if [ ! -z "$P3" ];then
   sed -i "s?<mhp-parcelid>?$P3?g" $dwnldpath/$fname$fsufx.MHP.sql
  fi
 elif [ $P1 -ge 317 ] && [ $P1 -le 321 ];then
  sed "s?xxx?$P1?g" SpecxxxRU.sql > $dwnldpath/$fname$fsufx.MHP.sql
  if [ ! -z "$P2" ];then
   sed -i "s?<special-db>?$P2?g" $dwnldpath/$fname$fsufx.MHP.sql
  fi
  if [ ! -z "$P3" ];then
   sed -i "s?<mhp-parcelid>?$P3?g" $dwnldpath/$fname$fsufx.MHP.sql
  fi
 else
  sed "s?xxx?$P1?g" SpecxxxRU.sql > $dwnldpath/$fname$fsufx.sql
 fi
 echo "$fname$fsufx.sql copied."
fi
if test -f $dwnldpath/MakeSpecTerrQuery; then
 echo "  MakeSpecTerrQuery exists - skipped."
else
 sed "s?xxx?$P1?g" MakeSpecTerrQuery > $dwnldpath/MakeSpecTerrQuery
 echo "MakeSpecTerrQuery copied."
fi
if test -f $dwnldpath/NOMAP;then
 if test -f $dwnldpath/MakeSyncNOMAPTerr; then
  echo "  MakeSyncNOMAPTerr* already exists - skipped."
 else
  cp MakeSyncNOMAPTerr.tmp $dwnldpath
  sed "s?xxx?$P1?g" MakeSyncNOMAPTerr.tmp \
   > $dwnldpath/MakeSyncNOMAPTerr
  echo "MakeSyncNOMAPTerr copied."
 fi
else
 if test -f $dwnldpath/MakeSyncTerrToSpec; then
  echo "  MakeSyncTerrToSpec* already exists - skipped."
 else
  cp MakeSyncTerrToSpec.tmp $dwnldpath
  sed "s?xxx?$P1?g" MakeSyncTerrToSpec.tmp \
   > $dwnldpath/MakeSyncTerrToSpec
  echo "MakeSyncTerrToSpec copied."
 fi
fi	# end NOMAP
# test if MHP for SetMHPSpecTerrs, SetSpecTerrs.
if [ $P1 -ge 235 ] && [ $P1 -le 251 ] || [ $P1 -ge 261 ] && [ $P1 -le 264 ] \
 || [ $P1 -ge 317 ] && [ $P1 -le 321 ] || [ $P1 -eq 268 ] || [ $P1 -eq 269 ];then
 if test -f $dwnldpath/SetMHPSpecTerrs.sql; then
  echo "  SetMHPSpecTerrs.sql already exists - skipped."
 else
  sed "s?xxx?$P1?g" SetSpecTerrs.MHP.sql > $dwnldpath/SetMHPSpecTerrs.sql
  if [ ! -z "$P2" ];then
   sed -i "s?<special-db>?$P2?g" $dwnldpath/SetMHPSpecTerrs.sql
  fi
  if [ ! -z "$P3" ];then
   sed -i "s?<mhp-parcelid>?$P3?g" $dwnldpath/SetMHPSpecTerrs.sql
  fi
  echo "SetMHPSpecTerrs.sql copied."
 fi
else
 if test -f $dwnldpath/SetSpecTerrs.sql; then
  echo "  SetSpecTerrs.sql already exists - skipped."
 else
  sed "s?xxx?$P1?g" SetSpecTerrs.sql > $dwnldpath/SetSpecTerrs.sql
  echo "SetSpecTerrs.sql copied."
 fi
fi
# end test for MHP SetSpecTerrs.
# test if MHP for MakeSetMHPSpecTerrs, MakeSetSpecTerrs.
if [ $P1 -ge 235 ] && [ $P1 -le 251 ] || [ $P1 -ge 261 ] && [ $P1 -le 264 ] \
 || [ $P1 -ge 317 ] && [ $P1 -le 321 ] || [ $P1 -eq 268 ] || [ $P1 -eq 269 ];then
 if test -f $dwnldpath/MakeSetMHPSpecTerrs; then
  echo "  MakeSetMHPSpecTerrs already exists - skipped."
 else
  cp MakeSetSpecTerrs.tmp $dwnldpath
 sed "s?xxx?$P1?g" MakeSetMHPSpecTerrs.tmp > $dwnldpath/MakeSetMHPSpecTerrs
  echo "MakeSetMHPSpecTerrs copied."
 fi
else
 if test -f $dwnldpath/MakeSetSpecTerrs.tmp; then
  echo "  MakeSetSpecTerrs already exists - skipped."
 else
  cp MakeSetSpecTerrs.tmp $dwnldpath
 sed "s?xxx?$P1?g" MakeSetSpecTerrs.tmp > $dwnldpath/MakeSetSpecTerrs
  echo "MakeSetSpecTerrs copied."
 fi
fi
# end MHP conditional
# begin ClearMHPruBridge, MakeClearMHPruBridge conditional.
if [ $P1 -ge 235 ] && [ $P1 -le 251 ] || [ $P1 -ge 261 ] && [ $P1 -le 264 ] \
 || [ $P1 -ge 317 ] && [ $P1 -le 321 ] || [ $P1 -eq 268 ] || [ $P1 -eq 269 ];then
 if test -f $dwnldpath/ClearMHPruBridge.sql; then
  echo "  ClearMHPruBridge.sql already exists - skipped."
 else
  sed "s?xxx?$P1?g" ClearMHPruBridge.psq > $dwnldpath/ClearMHPruBridge.sql
  echo "ClearMHPruBridge.sql copied."
 fi
 if test -f $dwnldpath/MakeClearMHPruBridge; then
  echo "  MakeClearMHPruBridge already exists - skipped."
 else
  sed "s?xxx?$P1?g" MakeClearMHPruBridge.tmp > $dwnldpath/MakeClearMHPruBridge
  echo "ClearMHPruBridge.sql copied."
 fi
fi
# end ClearMHPruBridge, MakeClearMHPruBridge conditional.
if test -f $dwnldpath/MakeSpecials; then
 echo "  MakeSpecials already exists - skipped."
else
 sed "s?xxx?$P1?g"  MakeSpecials > $dwnldpath/MakeSpecials
 echo "MakeSpecials copied."
fi
# Specialxxx.dblist.txt added to be copied.
if test -f $dwnldpath/Specialxxx.dblist.txt; then
 echo "  Specialxxx.dblist.txt already exists - skipped."
else
# cp Specialxxx.dblist.txt $dwnldpath/Specialxxx.dblist.txt
 sed "{s?yyy?$P1?g;s?\$P1?$P1?g}" Specialxxx.dblist.txt > $dwnldpath/Specialxxx.dblist.txt
 echo "Specialxxx.dblist.txt copied."
fi
# Letter territories begin with '6'; AddZips.sql and MakeAddZips required.
firstchar=${P1:0:1}
if [ "$firstchar" == "6" ];then
 if test -f $dwnldpath/AddZips.sql; then
  echo "  AddZips.sql already exists - skipped."
 else
  # cp AddZips.sql $dwnldpath/AddZips.sql
  sed "{s?xxx?$P1?g;s?\$P1?$P1?g}" $altprojbase/RUNewLetter/AddZips.sql  \
   > $dwnldpath/AddZips.sql
  echo "AddZips.sql copied."
 fi
 if test -f $dwnldpath/MakeAddZips; then
  echo "  MakeAddZips already exists - skipped."
 else
  # cp MakeAddZips $dwnldpath/MakeAddZips
  sed "{s?yyy?$P1?g;s?\$P1?$P1?g}" $altprojbase/RUNewLetter/MakeAddZips  \
   > $dwnldpath/MakeAddZips
  echo "MakeAddZips copied."
 fi
fi
#endprocbody
if [ $local_debug = 1 ]; then
  popd
fi
if [ "$USER" != "vncwmk3" ];then
 notify-send "InitSpecial" "complete - $P1"
fi
echo "  InitSpecial $P1 complete."
~/sysprocs/LOGMSG "InitSpecial $P1 complete."
echo "  Now use InitSpecSed project to change xxx to the territory ID in"
echo "  the RegenSpecDB.sq and SyncTerrToSpec.sq files"
echo "  and the MakeRegenSpecDB.tmp and MakeSyncTerrToSpec.tmp"
echo "  files to their respective files with no .tmp extensions."
echo "  This also edits the <special-db> names into the RegenSpecDB.sq"
echo "  file ATTACH statements."
#end InitSpecial
