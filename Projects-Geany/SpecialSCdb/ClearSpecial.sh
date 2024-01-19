#!/bin/bash
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
# ClearSpecial.sh - Clear out files so InitSpecial does full initialize.
#	6/19/22.	wmk.
#
# Modification History.
# ---------------------
# 6/19/22.	wmk.	original code; adapted from RU/ClearSpecial.
# Legacy mods.
# 4/26/22.	wmk.	*pathbase* support.
# Legacy mods.
# 9/11/21.	wmk.	original code.
# 10/25/21.	wmk.	AddZips, MakeAddZips, Specialxxx.dblist.txt added to list
#			 of files to clear; RegenSpecDB, SyncTerrToSpec .sq > .sql.
# 11/1/21.	wmk.	mod to remove all records from letter territory 6xx.
# 1/4/22.	wmk.	$ rp test made consistent with " strings.
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
 export pathbase=$folderbase/Territories
fi
if [ -z "$congterr" ];then
 export congterr=FLSARA86777
fi
if [ -z "$conglib" ];then
 export conglib=FLsara86777
fi
P1=$1
if [ -z "$P1" ];then
 echo "ClearSpecial <terrid> missing parameter - abandoned."
 exit 1
fi
read -p "You will clear SC files in territory $P1! Are you sure (Y/N)? "
rp=${REPLY,,}
if [ "$rp" != "y" ];then echo "ClearSpecial abandoned.";exit 0;fi
cd $pathbase/RawData/SCPA/SCPA-Downloads/Terr$P1
fn1=Spec$P1
fn2=SC.sql
if test -f SPECIAL;then rm SPECIAL;fi
if test -f $fn1$fn2;then rm $fn1$fn2;fi
if test -f RegenSpecDB.sql;then rm RegenSpecDB.*;fi
if test -f SetSpecTerrs.sql;then rm SetSpecTerrs.*;fi
if test -f SetMHPSpecTerrs.sql;then rm SetMHPSpecTerrs.*;fi
if test -f SyncTerrToSpec.sql;then rm SyncTerrToSpec.*;fi
if test -f AddZips.sql;then rm AddZips.*;fi
if test -f Specialxxx.dblist.txt;then rm Specialxxx.dblist.txt;fi
if test -f MakeSpecials;then rm MakeSpecials;fi
if test -f MakeRegenSpecDB;then rm MakeRegenSpecDB*;fi
if test -f MakeSetSpecTerrs;then rm MakeSetSpecTerrs*;fi
if test -f MakeSetMHPSpecTerrs;then rm MakeSetMHPSpecTerrs*;fi
if test -f MakeSyncTerrToSpec;then rm MakeSyncTerrToSpec*;fi
if test -f MakeAddZips;then rm MakeAddZips*;fi
# code to conditionally clear records from letter Terr$P1.db.
firstchar=${P1:0:1}
if [ "$firstchar" == "6" ];then
   fbase=Terr$P1
   fsuffx=_SC.db
   tblsuffx=_SCBridge
   echo "-- * Empty Terr$P1 _SCBridge table;" > SQLTemp.sql
   echo ".open ""$folderbase/Territories/$scpath/$fbase/$fbase$fsuffx"" " \
    >> SQLTemp.sql
   echo "DELETE FROM $fbase$tblsuffx;" >> SQLTemp.sql
   echo ".quit" >> SQLTemp.sql
   sqlite3 < SQLTemp.sql
   echo "$fbase$tblsuffx records cleared."
fi
echo "Territory $P1  SC specials cleared."
# end ClearSpecial.sh
