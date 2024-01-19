#!/bin/bash
# cknewfiles.sh - check for new files in all folders.
# 7/12/22.	wmk.
#
# Usage. bash  cknewfiles.sh <foldertype>
#
#	<foldertype> = [PROCS | SCRAW | RURAW | GEANY | BASIC | MAINDBS | RELEASE
#					| TERRDATA | BSCRAW | BRURAW | BTERRDATA ]
#
# Modification History.
# ---------------------
# 6/3/22.	wmk.	original code.
# 6/7/22.	wmk.	*recurs* env var added with -R for recursion into folders
#			 having subdirectories needing to be checked.
# 6/9/22.	wmk.	-R added to GEANY to pick up Tracking.
# 7/12/22.	wmk.	DONOTCALLS added to subdirectories.	
P1=$1
if [ -z "$P1" ];then
 echo "cknewfiles [procs|scraw|ruraw|geany|basic|maindbs|release|terrdata] procs defaulted."
 P1=Procs
fi
folder=${P1^^}
if [ -z "$congterr" ];then
 echo " cknewfiles *congterr* not set - abandoned."
 exit a
fi
shellpath=$pathbase/Procs-Dev
recurs=
pushd  ./ > $TEMP_PATH/scratchfile
case $folder in
"PROCS") 
  cd $pathbase/Procs-Dev
  dumpname=Procs
  ;;
"PROCSBLD")
  cd $pathbase/Procs-Build
  dumpname=ProcBld
  ;;
"SCRAW")
  cd $pathbase/RawData/SCPA/SCPA-Downloads
  dumpname=RawDataSC
  recurs=-R
  ;;
"RURAW")
  cd $pathbase/RawData/RefUSA/RefUSA-Downloads
  dumpname=RawDataRU
  recurs=-R
  ;;
"GEANY")
  cd $pathbase/Projects-Geany
  dumpname=Geany
  recurs=-R
  ;;
"BASIC")
  cd $pathbase/Basic
  dumpname=Basic
  ;;
"DONOTCALLS")
  cd $pathbase/DoNotCalls
  dumpname=DoNotCalls
  ;;
"INCLUDE")
  cd $pathbase/include
  dumpname=Include
  ;;
"MAINDBS")
  cd $pathbase/DB-Dev
  dumpname=MainDBs
  ;;
"RELEASE")
  cd $pathbase/ReleaseData
  dumpname=Release
  recurs=-R
  ;;
"TERRDATA")
  cd $pathbase/TerrData
  dumpname=TerrData
  recurs=-R
  ;;
"BRURAW")
  cd $pathbase/BRawData/RefUSA/RefUSA-Downloads
  dumpname=BRawDataRU
  recurs=-R
  ;;
"BSCRAW")
  cd $pathbase/BRawData/SCPA/SCPA-Downloads
  dumpname=BRawDataSC
  recurs=-R
  ;;
"BTERRDATA")
  cd $pathbase/BTerrData
  dumpname=BTerrData
  recurs=-R
  ;;
*)
 cd $pathbase/Procs-Dev
 ;;
esac
ls -lh $recurs > $TEMP_PATH/WholeList.txt
sed -i '/^dr/d' $TEMP_PATH/WholeList.txt
awk -f $shellpath/awkgetdirs.txt $TEMP_PATH/WholeList.txt > $TEMP_PATH/FileList.txt
# echo " check $TEMP_PATH/FileList.txt"
# exit 0
file=$TEMP_PATH/FileList.txt
nextlevel=nextlevel
while read -e;do
 if [ $REPLY -nt $pathbase/log/$congterr$dumpname$nextlevel.txt ];then
  echo "$dumpname..$REPLY"
 fi;
done<$file
popd > $TEMP_PATH/scratchfile
# end cknewfiles
