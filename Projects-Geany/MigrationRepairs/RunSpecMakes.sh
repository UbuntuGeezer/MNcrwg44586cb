#!/bin/bash
echo " ** RunSpecMakes.sh out-of-date **";exit 1
echo " ** RunSpecMakes.sh out-of-date **";exit 1
# RunSpecMakes.sh - Run all "special" .sh makefiles for territory xxx.
#	12/18/22.	wmk.
#
# Usage. bash  RunSpecMakes.sh [<terrid>]
#
#	<terrid> = (optional) territory Id for which to run makefiles
#				default is last 3 chars of *PWD
P1=$1
if [ -z "$P1" ];then
 len=${#PWD}
 len3=$((len-3))
 P1=${PWD:len3:3}
 fi
 echo "  Running makefiles for terrritory $P1..."
 pushd ./ > $TEMP_PATH/scratchfile
  cd $pathbase/$rupath/Terr$P1
  echo "changed to folder Terr$P1..."
  rm RegenSpecDB.sh
  rm SetSpecTerrs.sh
  rm SyncTerrToSpec.sh
  make -f MakeRegenSpecDB
  make -f MakeSetSpecTerrs
  make -f MakeSyncTerrToSpec
  ls -lh RegenSpecDB.sh
  ls -lh SetSpecTerrs.sh
  ls -lh SyncTerrToSpec.sh
 popd > $TEMP_PATH/scratchfile
 # end RunSpecMakes.sh
