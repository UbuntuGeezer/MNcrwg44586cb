#!/bin/bash
echo " ** cknewfiles.sh out-of-date **";exit 1
# cknewfiles.sh - check for new files in all folders.
# 9/20/22.	wmk.
#
# Usage. bash  cknewfiles.sh <foldertype>
#
#	<foldertype> = [PROCS | SCRAW | RURAW | GEANY | BASIC | MAINDBS | RELEASE
#					| TERRDATA | BSCRAW | BRURAW | BTERRDATA ]
#
# Modification History.
# ---------------------
# 9/20/22.	wmk.	modified for Chromebook; directory tests added before *cd commands.
# Legacy mods.
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
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ];then
  export folderbase=/media/ubuntu/Windows/Users/Bill
 else
  export folderbase=$HOME
 fi
fi
if [ -z "$pathbase" ];then
 pathbase=$folderbase/GitHub/TerritoriesCB
fi
TEMP_PATH=$HOME/temp
folder=${P1^^}
shellpath=$pathbase/Procs-Dev
recurs=
pushd  ./ > $TEMP_PATH/scratchfile
dumpname=
case $folder in
"PROCS") 
  if test -d $pathbase/Procs-Dev;then 
   cd $pathbase/Procs-Dev
   dumpname=Procs
  fi
  ;;
"PROCSBLD")
  if test -d $pathbase/Procs-Build;then 
  cd $pathbase/Procs-Build
  dumpname=ProcBld
  fi
  ;;
"SCRAW")
  if test -d $pathbase/RawData/SCPA/SCPA-Downloads;then 
  cd $pathbase/RawData/SCPA/SCPA-Downloads
  dumpname=RawDataSC
  recurs=-R
  fi
  ;;
"RURAW")
  if test -d $pathbase/RawData/RefUSA/RefUSA-Downloads;then 
  cd $pathbase/RawData/RefUSA/RefUSA-Downloads
  dumpname=RawDataRU
  recurs=-R
  fi
  ;;
"GEANY")
  if test -d $pathbase/Projects-Geany;then 
  cd $pathbase/Projects-Geany
  dumpname=Geany
  recurs=-R
  fi
  ;;
"BASIC")
  if test -d $pathbase/Basic;then 
  cd $pathbase/Basic
  dumpname=Basic
  fi
  ;;
"DONOTCALLS")
  if test -d $pathbase/DoNotCalls;then 
  cd $pathbase/DoNotCalls
  dumpname=DoNotCalls
  fi
  ;;
"INCLUDE")
  if test -d $pathbase/include;then 
  cd $pathbase/include
  dumpname=Include
  fi
  ;;
"MAINDBS")
  if test -d $pathbase/DB-Dev;then 
  cd $pathbase/DB-Dev
  dumpname=MainDBs
  fi
  ;;
"RELEASE")
  if test -d $pathbase/ReleaseData;then 
  cd $pathbase/ReleaseData
  dumpname=Release
  recurs=-R
  fi
  ;;
"TERRDATA")
  if test -d $pathbase/TerrData;then 
  cd $pathbase/TerrData
  dumpname=TerrData
  recurs=-R
  fi
  ;;
"BRURAW")
  if test -d $pathbase/BRawData/RefUSA/RefUSA-Downloads;then 
  cd $pathbase/BRawData/RefUSA/RefUSA-Downloads
  dumpname=BRawDataRU
  recurs=-R
  fi
  ;;
"BSCRAW")
  if test -d $pathbase/BRawData/SCPA/SCPA-Downloads;then 
  cd $pathbase/BRawData/SCPA/SCPA-Downloads
  dumpname=BRawDataSC
  recurs=-R
  fi
  ;;
"BTERRDATA")
  if test -d $pathbase/BTerrData;then 
  cd $pathbase/BTerrData
  dumpname=BTerrData
  recurs=-R
  fi
  ;;
*)
 cd $pathbase/Procs-Dev
 ;;
esac
if [ ! -z "$dumpname" ];then
 ls -lh $recurs > $TEMP_PATH/WholeList.txt
 if [ $? -ne 0 ];then
  exit 0
 fi
 sed -i '/^dr/d' $TEMP_PATH/WholeList.txt
 awk -f $shellpath/awkgetdirs.txt $TEMP_PATH/WholeList.txt > $TEMP_PATH/FileList.txt
 # echo " check $TEMP_PATH/FileList.txt"
 # exit 0
 file=$TEMP_PATH/FileList.txt
 # 
 cb=CB
 while read -e;do
  if [ $REPLY -nt $pathbase/$cb$dumpname.0.tar ];then
   echo "$dumpname..$REPLY"
  fi;
 done<$file
fi	# non-empty dumpname
popd > $TEMP_PATH/scratchfile
# end cknewfiles
