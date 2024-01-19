#!/bin/bash
echo " ** ListDwnldDates.sh out-of-date **";exit 1
echo " ** ListDwnldDates.sh out-of-date **";exit 1
# ListDwnldDates.sh - List territory download dates.
# 6/29/23.	wmk.
#
# Usage. bash  ListDwnldDates.sh <terrid> RU|SCPA [-d|-s|-ds|-sd]
#
#	<terrid> = territory ID
#	RU|SCPA = RU - RefUSA, SCPA - SCPA, ! = both
#		if '!' both 
#	-d = (optional) include DWNLD_PATH files
#	-s = (optional) include *rupath/Special files
#
# Entry. *rupath/Terr<terrid>/Map<terrid>_RU.csv = latest download file.
#		 *scpath/Terr<terrid>/<terrid>M.db = latest <terrid> SCBridge update.
#		 *scpath/SCPA_mm-dd.db = latest SCPA download database
#		 *rupath/Special/*.csv = latest special db RU downloads.
#	 	 *projpath/DBList.txt = special db .csv list for -s option.
#
# Exit. Map<terrid>_RU.csv file date output to terminal.
#		Map<terrid>_SC file dates output to terminal.
#
# Dependencies.
#
# Modification History.
# ---------------------
# 6/27/23.	wmk.	original shell.
# 6/29/23.	wmk.	-s -sd -ds parameters documented.
# Notes. 
#
# P1=<terrid>
#
P1=$1
P2=${2^^}
P3=${3^^}
if [ -z "$P1" ];then
 echo "ListDwnldDates <terrid>|- [RU|SCPA|!] [-d|-s|-ds|-sd] missing parameter(s) - abandoned."
 read -p "Enter ctrl-c to remain in Terminal: "
 exit 1
fi
doterr=1
if [ "$P1" == "-" ];then
 doterr=0
fi
if [ "$P2" != "RU" ] && [ "$P2" != "SCPA" ] && [ "$P2" != "!" ];then
 echo "ListDwnldDates <terrid>|- [RU|SCPA|!] [-d] p2 unrecognized - abandoned."
 read -p "Enter ctrl-c to remain in Terminal: "
 exit 1
fi
both=0
if [ "$P2" == "!" ];then
 both=1
fi
if [ ! -z "$P3" ];then
 if [ "$P3" != "-D" ] && [ "$P3" != "-S" ] && [ "$P3" != "-DS" ] && [ "$P3" != "-SD" ];then
  echo "ListDwnldDates <terrid> [RU|SCPA|!] [-d|-s|-ds|-sd] '-' option unrecognized - abandoned."
  read -p "Enter ctrl-c to remain in Terminal: "
  exit 1
 fi
 dodwnld=0
 dospecl=0
 if [[ "$P3" == *"D"* ]];then
  dodwnld=1
 fi
 if [[ "$P3" == *"S"* ]];then
  dospecl=1
 fi
fi	# P3 present
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ]; then
  export folderbase=/media/ubuntu/Windows/Users/Bill
 else
   export folderbase=$HOME
 fi
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories/FL/SARA/86777
fi
if [ -z "$codebase" ];then
 export pathbase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "  ListDwnldDates - initiated from Make"
  echo "  ListDwnldDates - initiated from Make"
else
  ~/sysprocs/LOGMSG "  ListDwnldDates - initiated from Terminal"
  echo "  ListDwnldDates - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 . ~/GitHub/TerritoriesCB/Procs-Dev/SetToday.sh
#TODAY=2022-04-22
fi
#procbodyhere
if test -f $TEMP_PATH/dirlist.txt;then rm $TEMP_PATH/dirlist.txt;fi
projpath=$codebase/Projects-Geany/DwnldMgr
pushd ./ > /dev/null
if [ $dodwnld -ne 0 ];then
 ls -lh ~/Downloads/*.csv >> $TEMP_PATH/dirlist.txt
fi
if [ $P2 == "RU" ] || [ $both -ne 0 ];then
 if [ $dospecl -ne 0 ];then
  cd $pathbase/RawData/RefUSA
  ls -lh ./RefUSA-Downloads/Special/*.csv > $TEMP_PATH/speclist.txt
  # field 8 is filename; use mawk to cherry pick matching lines
  # by loading array with DBList.txt from *projpath
  # DBList.txt has names w/o .csv suffix
  cd $projpath
  fn=DBList.txt
  echo "ready to enter *mawk for /Special.."
#  read -p "Enter ctrl-c to remain in Terminal: "
#  exit 0
  mawk -v linesfile=$fn -f awkspeclist.txt $TEMP_PATH/speclist.txt >> $TEMP_PATH/dirlist.txt
  echo "back from *mawk"
#  read -p "Enter ctrl-c to remain in Terminal: "
#  exit 0  
 fi
 if [ $doterr -ne 0 ];then
  cd $pathbase/$rupath/Terr$P1
  suffx=_RU.csv
  ls -lh Map$P1$suffx >> $TEMP_PATH/dirlist.txt
 fi
fi
if [ $P2 == "SC" ] || [ $both -ne 0 ];then
 cd $pathbase/$scpath
 ls -lh SCPA_*.db >> $TEMP_PATH/dirlist.txt
 if [ $dospecl -ne 0 ];then
  cd $pathbase/RawData/SCPA
  ls -lh ./SCPA-Downloads/Special/*.csv >> $TEMP_PATH/dirlist.txt
 fi
 if [ $doterr -ne 0 ];then
  cd $pathbase/$scpath/Terr$P1
  m=M.csv
  p=P.csv
  ls -lh Updt$P1$m >> $TEMP_PATH/dirlist.txt
  ls -lh Updt$P1$p >> $TEMP_PATH/dirlist.txt
 fi
fi
mawk 'BEGIN{p=1}{if( index($8,"all") > 0)p=0;;if(p) print $8 "  " $6 " " $7;else p=1}' $TEMP_PATH/dirlist.txt
popd > /dev/null
#endprocbody
echo "  ListDwnldDates complete."
~/sysprocs/LOGMSG "  ListDwnldDates complete."
# end ListDwnldDates.sh
