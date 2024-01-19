# Archiving.sh - Archiving functions source file. 9/5/22. wmk.
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
function IncDumpGeany(){
DoMore=1
P1=${1^^}
P2=${2^^}
P3=$3
P4=${4^^}
P5=$5
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ];then
 echo "IncDumpGeany <state> <county> <congno> [-u <mount-name> ] missing parameter(s) - abandoned."
 DoMore=0
fi
if [ $DoMore -ne 0 ];then
 if [ ! -z "$P4" ];then
  if [ "$P4" != "-U" ];then
   echo "** IncDumpTerr <state> <county> <congno> <terrid> [-u <mount-name>] unrecognized option $P4 - abandoned. **"
   DoMore=0
  fi
 fi
fi	# end DoMore
if [ $DoMore -ne 0 ];then
 if [ -z "$P5" ];then
  echo "** IncDumpGeany <state> <county> <congno> <terrid> [-u <mount-name>] missing <mount-name> - abandoned. **"
  DoMore=0
 fi
fi  # end DoMore
if [ $DoMore -ne 0 ];then
 if [ ! -z "$P4" ];then
  if ! test -d $U_DISK/$P5;then
   echo "$P5 not mounted... Mount flash drive $P5"
   read -p "  Drive mounted and continue (y/n)? "
   yn=${REPLY^^}
   if [ "$yn" != "Y" ];then
    echo "IncDumpGeany abandoned at user request."
    DoMore=0
   else
    if ! test -d $U_DISK/$P5;then
     echo "$P5 still not mounted - IncDumpGeany abandoned."
     DoMore=0
    else
     "echo continuing with $P5 mounted..."
    fi
   fi
  fi
 fi	# end P4
fi # end DoMore
echo "P1 = : '$P1'"
echo "P2 = : '$P2'"
echo "P3 = : '$P3'"
echo "P4 = : '$P4'"
echo "P5 = : '$P5'"
echo "parameter tests complete."
#exit
if [ $DoMore -ne 0 ];then
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
  pathbase=$folderbase/Territories
 fi
 if [ -z "$congterr" ];then
  export congterr=FLSARA86777
 fi
 if [ "$P1$P2$P3" != "$congterr" ];then
  echo "*congterr* = :$congterr"
  echo "** $P1$P2$P3 mismatch with *congterr* - FlashBacks abandoned **"
  DoMore=0
 fi
 local_debug=0	# set to 1 for debugging
 #local_debug=1
 #
 # handle case where called from Make.
 if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  bash ~/sysprocs/LOGMSG "   IncDumpGeany initiated from Make."
  echo "   IncDumpGeany initiated."
 else
  bash ~/sysprocs/LOGMSG "   IncDumpGeany initiated from Terminal."
  echo "   IncDumpGeany initiated."
 fi
 TEMP_PATH=$folderbase/temp
#
 if [ $local_debug = 1 ]; then
  pushd ./
  cd ~/Documents		# write files to Documents folder
 fi
fi # end DoMore
#proc body here
#DoMore=0		# stop short..
if [ $DoMore -ne 0 ];then
 pushd ./ > $TEMP_PATH/scratchfile
 if [ -z "$P5" ];then
  dump_path=$pathbase
 else
  dump_path=$U_DISK/$P5/$congterr
 fi
 cd $dump_path
 geany=Geany
 level=level
 nextlevel=nextlevel
 newlevel=newlevel
 # if $dump_path/log/$congterr$geany.snar-0 does not exist, initialize and perform level 0 tar.
 if ! test -f $dump_path/log/$congterr$geany.snar-0;then
  # initial archive
  if ! test -d $dump_path/log;then
   mkdir log
  fi
  echo "0" > $dump_path/log/$congterr$geany$level.txt
  echo "1" > $dump_path/log/$congterr$geany$nextlevel.txt
  archname=$congterr$geany.0.tar
  echo $archname
  pushd ./
  cd $pathbase
  tar --create \
	  --listed-incremental=$dump_path/log/$congterr$geany.snar-0 \
	  --file=$dump_path/archname \
	  Projects-Geany
  ~/sysprocs/LOGMSG "  IncDumpGeany $P1 $P2 $P3 $P4 $P5 complete."
  popd
  echo "  IncDumpGeany $P1 $P2 $P3 $P4 $P5 complete."
  DoMore=0
fi # end DoMore
if [ $DoMore -ne 0 ];then
# this is a level-1 tar incremental.
  oldsnar=$congterr$geany.snar-0
 awk '{$1++; print $0}' $dump_path/log/$congterr$geany$nextlevel.txt \
   > $dump_path/log/$congterr$geany$newlevel.txt
 file=$dump_path/log/$congterr$geany$nextlevel.txt
 echo "file = :'$file'"
 while read -e;do
  export archname=$congterr$geany.$REPLY.tar
  export snarname=$oldsnar
  echo $archname
  pushd ./
  cd $pathbase
  tar --create \
	--listed-incremental=$dump_path/log/$snarname \
	--file=$dump_path/$archname \
	Projects-Geany
  popd
 done <$file
 cp $dump_path/log/$congterr$geany$newlevel.txt $dump_path/log/$congterr$geany$nextlevel.txt
fi # end DoMore
#
popd > $TEMP_PATH/scratchfile
#end proc body
if [ $local_debug = 1 ]; then
  popd
fi
#jumpto EndProc
#EndProc:
~/sysprocs/LOGMSG "  IncDumpGeany $P1 $P2 $P3 $P4 $P5 complete."
echo "  IncDumpGeany $P1 $P2 $P3 $P4 $P5 complete."
fi # end DoMore
}	# end IncDumpGeany
function ReloadGeany(){
DoMore=1
isAll=0
P1=$1			# <filespec>
P2=${2,,}		# [ -o | -u | -uo ]
P3=$3			# <mount-name>
P4=${4^^}		# <state><county><congno> (*congterr)
if [ "$P1" == "!" ];then
 isAll=1
fi
if [ -z "$P1" ];then
 echo "ReloadGeany <filespec> [-u|-ou|-uo <mountname>] [<state><county><congno>] missing parameter(s) - abandoned."
 DoMore=0
fi
if [ $DoMore -ne 0 ];then
 # if P2 is present, P3 must also.
 # to specify P4, P2, P3 must be present, but may be empty strings.
 if  [ ! -z "$P2" ] && $([ "${P2:1:1}" == "u" ] || [ "${P2:2:1}" == "u" ]) && [ -z "$P3" ];then
  echo "ReloadGeany <filespec> [-u <mountname>] [<state><county><congno>] missing parameter(s) - abandoned."
  echo "P1 = : $P1"	# filespec
  echo "P2 = : $P2"	# -o -uo -ou -u
  echo "P3 = : $P3"	# <mount-name>
  echo "P4 = : $P4"	# <state><county><congno>
  DoMore=0
 fi
fi	 # end DoMore
if [ $DoMore -ne 0 ];then
 if [ ! -z "$P2" ];then
  P2=${2,,}
  if [ "$P2" != "-u" ] && [ "$P2" != "-ou" ] && [ "$P2" != "-uo" ]&& [ "$P2" != "-o" ];then
   echo "ReloadGeany <filespec> [-u <mountname>] [<state><county><congo>] unrecognized '-' option - abandoned."
   DoMore=0
  fi
 fi
fi	# end DoMore
if [ $DoMore -ne 0 ];then
 if [ "${P2:1:1}" == "u" ] || [ "${P2:2:1}" == "u" ] ;then
  if ! test -d $U_DISK/$P3;then
   echo "** $P3 not mounted - mount $P3..."
   read -p "  then press {enter} or 'q' to quit: "
   yq=${REPLY^^}
   if [ "$yq" == "Q" ];then
    echo "  ReloadGeany abandoned, drive not mounted."
    sysprocs/LOGMSG "  ReloadGeany abandoned, drive not mounted."
    DoMore=0
   fi
  fi
 fi
fi	# end DoMore
if [ $DoMore -ne 0 ];then
 if [ "${P2:1:1}" == "o" ] || [ "${P2:2:1}" == "o" ] ;then
  writeover=--overwrite
 else
  writeover=--keep-newer-files
 fi
 echo "P4 = : $P4"
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
  pathbase=$folderbase/Territories
 fi
 if [ -z "$congterr" ];then
  export congterr=FLSARA86777
 fi
 if [ -z "$P4" ];then
  P4=${congterr^^}
 fi
 #if [ "$P4" != "$congterr" ];then
 # echo "*congterr* = :$congterr"
 # echo "** $P1$P2$P3 mismatch with *congterr* - ReloadGeany abandoned **"
 # DoMore=0
 #fi
 # debugging code...
 #echo "P1 = : $P1"
 #echo "P2 = : $P2"
 #echo "P3 = : $P3"
 #echo "P4 = : $P4"
 #echo "isAll = $isAll"
 #echo "ReloadGeany parameter tests complete"
 #exit 0
 # end debugging code.
 local_debug=0	# set to 1 for debugging
 #local_debug=1
 #
 # handle case where called from Make.
 if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "   ReloadGeany $P1 $P2 $P3 $P4 initiated from Make."
  echo "   ReloadGeany initiated."
 else
  ~/sysprocs/LOGMSG "   ReloadGeany $P1 $P2 $P3 $P4 initiated from Terminal."
  echo "   ReloadGeany initiated."
 fi
 TEMP_PATH="$folderbase/temp"
 #
 if [ $local_debug = 1 ]; then
  pushd ./
  cd ~/Documents		# write files to Documents folder
 fi
fi # end DoMore
if [ $DoMore -ne 0 ];then
 #proc body here
 pushd ./ > $TEMP_PATH/scratchfile
 if [ -z "$P3" ];then
  dump_path=$pathbase
 else
  dump_path=$U_DISK/$P3/$P4
 fi
 arch_path=${pathbase:1:50}
 geany=Geany
 level=level
 nextlevel=nextlevel
 newlevel=newlevel
 # check for .snar file.
 if ! test -f $dump_path/log/$congterr$geany.snar-0;then
  echo "** cannot locate .snar file.. abandoned."
  DoMore=0
 fi
 # cat ./log/$congterr$geany$nextlevel.txt
 awk '{$1--; print $0}' $dump_path/log/$congterr$geany$nextlevel.txt > $TEMP_PATH/LastTarLevel.txt
 file=$TEMP_PATH/LastTarLevel.txt
 while read -e;do
 #  echo "Last *tar* level = : $REPLY"
  lastlevel=$REPLY
 done < $file
 seq 0 $lastlevel > $TEMP_PATH/TarLevelList.txt
 # seq 0 $lastlevel
 file=$TEMP_PATH/TarLevelList.txt
 echo "Reloading from $P4$geany.*.tar incremental dumps..."
 while read -e;do
   echo " Processing $geany.$REPLY.tar."
    pushd ./
    cd $pathbase
   if [ $isAll -eq 0 ];then
    tar --extract \
     --file=$dump_path/$P4$geany.$REPLY.tar \
     --wildcards    \
     $writeover \
    Projects-Geany/$P1
   else
    tar --extract \
     --file=$dump_path/$P4$geany.$REPLY.tar \
     --wildcards    \
     $writeover \
    Projects-Geany
   fi
   popd
 done < $file
 echo "  ReloadGeany $P1 $P2 $P3 $P4 complete."
 ~/sysprocs/LOGMSG "  ReloadGeany $P1 $P2 $P3 $P4 complete."
fi	# end DoMore
}
function RestartIncGeany(){
DoMore=1
P1=${1^^}	# state
P2=${2^^}	# county
P3=$3		# congno
P4=${4^^}	# -u
P5=$5		# mount-name
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ];then
 echo "RestartIncGeany <state> <county> <congno> [-u <mount-name>] missing parameter(s) - abandoned."
 DoMore=0
fi
if [ $DoMore -ne 0 ];then
 if [ -z "$P4" ];then
  if ! test -d $U_DISK/$P5;then
   echo "$P5 not mounted... Mount flash drive $P5"
   read -p "  Drive mounted and continue (y/n)? "
   yn=${REPLY^^}
   if [ "$yn" != "Y" ];then
    echo "IncDumpGeany abandoned at user request."
    DoMore=0
   else
    if ! test -d $U_DISK/$P5;then
     echo "$P5 still not mounted - IncDumpGeany abandoned."
     DoMore=0
    else
    "echo continuing with $P5 mounted..."
    fi
   fi
  fi
 fi
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
 if [ "$folderbase/Territories/$P1/$P2/$P3" != "$pathbase" ];then
  echo "pathbase: $pathbase"
  echo "$folderbase/Territories/$P1/$P2/$P3 does not match *pathbase* - abandoned."
  DoMore=0
 fi
 if [ -z "$congterr" ];then
  export congterr=FLSARA86777
 fi
 if [ "$P1$P2$P3" != "$congterr" ];then
  echo "*congterr* = :$congterr"
  echo "** $P1$P2$P3 mismatch with *congterr* - RestartIncGeany abandoned **"
  DoMore=0
 fi
fi 	# end DoMore
if [ $DoMore -ne 0 ];then
 local_debug=0	# set to 1 for debugging
 #local_debug=1
 #
 # handle case where called from Make.
 if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  bash ~/sysprocs/LOGMSG "   RestartIncGeany initiated from Make."
  echo "   RestartGeany initiated."
 else
  bash ~/sysprocs/LOGMSG "   RestartIncGeany initiated from Terminal."
  echo "   RestartGeany initiated."
 fi
 TEMP_PATH=$folderbase/temp
 if [ "$NOPROMPT" == "" ];then NOPROMPT=0;fi;if [ $NOPROMPT -ne 1 ];then
  echo " **WARNING - proceeding will remove all prior Geany incremental dump files!**"
  read -p "OK to proceed (Y/N)? "
  ynreply=${REPLY,,}
  if [ "$ynreply" == "y" ];then
   echo "  Proceeding to remove prior incremental dump files..."
  else
   ~/sysprocs/LOGMSG "  User halted RestartIncGeany."
   echo " Stopping RestartIncGeany - secure Geany incremental backups.."
   DoMore=0
  fi
 fi 	# end system_log
fi   # end DoMore
#
if [ $DoMore -ne 0 ];then
 if [ $local_debug = 1 ]; then
  pushd ./
  cd ~/Documents		# write files to Documents folder
 fi
 #proc body here
 pushd ./ > $TEMP_PATH/scratchfile
 if [ ! -z "$5" ];then
  dump_path=$U_DISK/$5/$congterr
 else
  dump_path=$pathbase
 fi		# end flash drive
 cd $dump_path
 geany=Geany
 level=level
 nextlevel=nextlevel
 if test -f $dump_path/log/$congterr$geany$level.txt;then
  rm $dump_path/log/$congterr$geany$level.txt
 fi
 echo "0" > $dump_path/log/$congterr$geany$nextlevel.txt
 if test -f $dump_path/log/$congterr$geany.snar-0; then
  rm $dump_path/log/$congterr$geany.snar-0
 fi
 if test -f $dump_path/$congterr$geany.0.tar; then
  rm $dump_path/$congterr$geany*.tar
 fi
 popd > $TEMP_PATH/scratchfile
#end proc body
 if [ $local_debug = 1 ]; then
  popd
 fi
fi	# end DoMore
#jumpto EndProc
#EndProc:
~/sysprocs/LOGMSG "  RestartIncGeany $P1 $P2 $P3 $P4 $P5 complete."
echo "  RestartIncGeany $P1 $P2 $P3 $P4 $P5 complete"
}
function IncDumpTerr(){
}
function ReloadTerr(){
}
function RestartIncTerr(){
}
