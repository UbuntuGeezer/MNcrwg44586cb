#procbodyhere
files copied to target territory from SpecialRUdb folder:
#-- SPECIAL
#-- RegenSpecDB.sql OR RegenSpecDB.MHP.sql > RegenSpecDB.sql
#-- SyncTerrToSpec.sql > SyncTerrToSpec.sql
#-- MakeRegenSpecDB.tmp > MakeRegenSpecDB
#-- SpecxxxRU.sql > [SpecxxxRU.MHP.sql | SpecxxxRU.sql]
#-- MakeSpecTerrQuery
#-- MakeSyncTerrToSpec.tmp > MakeSyncTerrToSpec
#-- SetSpecTerrs.MHP.sql | SetSpecTerrs.sql
#--	> SetSpecTerrs.MHP.sql | SetSpecTerrs.sql
#-- MakeSetMHPSpecTerrs.tmp | MakeSetSpecTerrs.tmp 
#--	> MakeSetMHPSpecTerrs | MakeSetSpecTerrs
#-- ClearMHPruBridge.psq > ClearMHPruBridge.sql
#-- MakeClearMHPruBridge.tmp > MakeClearMHPruBridge
#-- MakeSpecials > MakeSpecials
#-- Specialxxx.dblist.txt > Specialxxx.dblist.txt
#-- [RUNewLetter/AddZips.sql, MakeAddZips] > [AddZips.sql, MakeAddZips]

#---- code below -----
#-- SPECIAL
 sed "{s?xxx?$P1?g;s?\$P1?$P1?g}" SPECIAL > $dwnldpath/SPECIAL

#-- RegenSpecDB.sql | RegenSpecDB.MHP.sql > RegenSpecDB.sql
# cp RegenSpecDB.sql $dwnldpath
# mobile home parks terr 235-251, 268-269, 261-264, 317-321.
 if [ $P1 in range above... ];then
  sed "s?xxx?$P1?g" RegenSpecDB.MHP.sql > $dwnldpath/RegenSpecDB.sql
  if [ ! -z "$P2" ];then
   sed -i "s?<special-db>?$P2?g" $dwnldpath/RegenSpecDB.sql
  fi
  if [ ! -z "$P3" ];then
   sed -i "s?<mhp-parcelid>?$P3?g" $dwnldpath/RegenSpecDB.sql
  fi
# not mobile home park
   sed "s?xxx?$P1?g" RegenSpecDB.sql > $dwnldpath/RegenSpecDB.sql
 echo "RegenSpecDB.sql copied."

#-- SyncTerrToSpec.sql
# cp SyncTerrToSpec.* $dwnldpath
 sed "{s?xxx?$P1?g;s?\$P1?$P1?g}" SyncTerrToSpec.sql \
   > $dwnldpath/SyncTerrToSpec.sql
 echo "SyncTerrToSpec.sql copied."

#--
# cp MakeRegenSpecDB.tmp $dwnldpath
 sed "s?xxx?$P1?g" MakeRegenSpecDB.tmp > $dwnldpath/MakeRegenSpecDB
 echo "MakeRegenSpecDB copied."

#-- SpecxxxRU.MHP.sql | SpecxxxRU.sql
f1=Spec$P1
f2=RU.sql
# mobile home parks terr 235-251, 268-269, 261-264, 317-321.
 fname=Spec$P1
 fsufx=RU
 if [ $P1 in range above... ];then
  sed "s?xxx?$P1?g" SpecxxxRU.sql > $dwnldpath/$fname$fsufx.MHP.sql
  if [ ! -z "$P2" ];then
   sed -i "s?<special-db>?$P2?g" $dwnldpath/$fname$fsufx.MHP.sql
  fi
  if [ ! -z "$P3" ];then
   sed -i "s?<mhp-parcelid>?$P3?g" $dwnldpath/$fname$fsufx.MHP.sql
  fi

#-- MakeSpecTerrQuery
if test -f $dwnldpath/MakeSpecTerrQuery; then
 echo "  MakeSpecTerrQuery exists - skipped."
else
 sed "s?xxx?$P1?g" MakeSpecTerrQuery > $dwnldpath/MakeSpecTerrQuery
 echo "MakeSpecTerrQuery copied."
fi

#-- MakeSyncTerrToSpec.tmp > MakeSyncTerrToSpec
 cp MakeSyncTerrToSpec.tmp $dwnldpath
 sed "s?xxx?$P1?g" MakeSyncTerrToSpec.tmp \
  > $dwnldpath/MakeSyncTerrToSpec
 echo "MakeSyncTerrToSpec copied."

#-- SetSpecTerrs.MHP.sql | SetSpecTerrs.sql > SetSpecTerrs.MHP.sql | SetSpecTerrs.sql
# mobile home parks terr 235-251, 268-269, 261-264, 317-321.
if [ $P1 in range above...];then
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
# non-mobile home park
  sed "s?xxx?$P1?g" SetSpecTerrs.sql > $dwnldpath/SetSpecTerrs.sql
  echo "SetSpecTerrs.sql copied."

#-- MakeSetMHPSpecTerrs.tmp | MakeSetSpecTerrs.tmp > 
#--	MakeSetMHPSpecTerrs | MakeSetSpecTerrs
# mobile home parks terr 235-251, 268-269, 261-264, 317-321.
# test if MHP for MakeSetMHPSpecTerrs, MakeSetSpecTerrs.
if [ $P1 in range above... ];then
  cp MakeSetSpecTerrs.tmp $dwnldpath
 sed "s?xxx?$P1?g" MakeSetMHPSpecTerrs.tmp > $dwnldpath/MakeSetMHPSpecTerrs
  echo "MakeSetMHPSpecTerrs copied."
# non mobile home park
  cp MakeSetSpecTerrs.tmp $dwnldpath
 sed "s?xxx?$P1?g" MakeSetSpecTerrs.tmp > $dwnldpath/MakeSetSpecTerrs
  echo "MakeSetSpecTerrs copied."

#-- ClearMHPruBridge.psq > ClearMHPruBridge.sql
#-- MakeClearMHPruBridge.tmp > MakeClearMHPruBridge
# begin ClearMHPruBridge, MakeClearMHPruBridge conditional.
# mobile home parks terr 235-251, 268-269, 261-264, 317-321.
if [ $P1 in range above... ];then
  sed "s?xxx?$P1?g" ClearMHPruBridge.psq > $dwnldpath/ClearMHPruBridge.sql
  echo "ClearMHPruBridge.sql copied."
 fi
 if test -f $dwnldpath/MakeClearMHPruBridge; then
  echo "  MakeClearMHPruBridge already exists - skipped."
# MakeClearMHPruBridge
  sed "s?xxx?$P1?g" MakeClearMHPruBridge.tmp > $dwnldpath/MakeClearMHPruBridge
  echo "ClearMHPruBridge.sql copied."
# end ClearMHPruBridge, MakeClearMHPruBridge conditional.

#-- MakeSpecials > MakeSpecials
 sed "s?xxx?$P1?g"  MakeSpecials > $dwnldpath/MakeSpecials

#-- Specialxxx.dblist.txt
 sed "{s?yyy?$P1?g;s?\$P1?$P1?g}" Specialxxx.dblist.txt > $dwnldpath/Specialxxx.dblist.txt

# -- [RUNewLetter/AddZips.sql, MakeAddZips] > [AddZips.sql, MakeAddZips]
# Letter territories begin with '6'; AddZips.sql and MakeAddZips required.
  sed "{s?xxx?$P1?g;s?\$P1?$P1?g}" $altprojbase/RUNewLetter/AddZips.sql  \
   > $dwnldpath/AddZips.sql
  echo "AddZips.sql copied."

  sed "{s?yyy?$P1?g;s?\$P1?$P1?g}" $altprojbase/RUNewLetter/MakeAddZips  \
   > $dwnldpath/MakeAddZips
  echo "MakeAddZips copied."

#endprocbody
