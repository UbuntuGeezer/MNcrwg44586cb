# MvSCDwnld.sh - Copy SCPA_Public.xlsx from MyFiles/Downloads to SCPA-Downloads.
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
#	5/26/22.	wmk.
#
# Usage> bash MvSCDwnld.sh  mm dd
#
#	mm - month of download
#	dd - day of download
#
# Entry. *pathbase*/Downloads/'SCPA Public.xlsx' is current SCPA download
#		 from date mm/dd of current year.
#		*TODAY* environment var set to download date.
#
# Exit.	/SCPA/SCPA-Downloads/SCPA-Public_mm-dd.xlsx is current SCPA
#		download.
#
# Modification History.
# ---------------------
# 3/19/22.	wmk.	original code.
# 4/26/22.	wmk.	*pathbase* support.
# 4/27/22.	wmk.	-p option added to *cp* to preserve date.
# 5/26/22.	wmk.	Entry conditions corrected for *pathbase*; P1 P2 mandatory
#			 parameters check.
P1=$1
P2=$2
if [ -z "$P1" ] || [ -z "$P2" ];then
 echo "MvSCDwnld <mm> <dd> missing parameter(s) - abandoned."
 exit 1
fi
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ];then
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
if [ -z "$TODAY" ];then
 echo "MvSCDwnld - env var TODAY not set - abandoned."
 exit 1
fi
if [ -z "$P1" ] || [ -z "$P2" ];then
 echo "MVSCDwnld <mm> <dd> - missing parameter(s) - abandoned."
 exit 1
fi
echo "MVSCDwnld initiated."
~/sysprocs/LOGMSG " MVSCDwnld $P1 $P2 initiated."
#procstarthere
if ! test -f $folderbase/Downloads/'SCPA Public.xlsx';then
 echo "'SCPA Public.xlsx' download file not found - MVSCDwnld abanooned."
 ~/sysprocs/LOGMSG "  'SCPA Public.xlsx' download file not found - MVSCDwnld abanooned."
 exit 1
else
 cp -puv $folderbase/Downloads/'SCPA Public.xlsx' \
  $pathbase/RawData/SCPA/SCPA-Downloads/SCPA-Public_$P1-$P2.xlsx
fi
#endprochere
if [ "$USER" != "vncwmk3" ];then
 notify-send "MvSCDwnld" "$mm $dd complete."
fi
echo "MvSCDwnld complete."

~/sysprocs/LOGMSG "  MvSCDwnld complete."
# end MvSCDwnld
