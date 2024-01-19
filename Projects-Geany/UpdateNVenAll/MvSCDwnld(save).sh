# MvSCDwnld.sh - Copy SCPA_Public.xlsx from MyFiles/Downloads to SCPA-Downloads.
echo " ** MvSCDwnld(save).sh out-of-date **";exit 1
echo " ** MvSCDwnld(save).sh out-of-date **";exit 1
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
#	3/19/22.	wmk.
#
# Usage> bash MvSCDwnld.sh  mm dd
#
#	mm - month of download
#	dd - day of download
#
# Entry. MyFiles/Downloads/'SCPA Public.xlsx' is current SCPA download
#		 from date mm/dd of current year.
#
# Exit.	/SCPA/SCPA-Downloads/SCPA-Public_mm-dd.xlsx is current SCPA
#		download.
#
# Modification History.
# ---------------------
# 3/19/22.	wmk.	original code.
P1=$1
P2=$2
if [ "$USER" == "ubuntu" ];then
 folderbase=/media/ubuntu/Windows/Users/Bill
else
 folderbase=$HOME
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
if ! test -f $CRM_BASE/Downloads/'SCPA Public.xlsx';then
 echo "'SCPA Public.xlsx' download file not found - MVSCDwnld abanooned."
 ~/sysprocs/LOGMSG "  'SCPA Public.xlsx' download file not found - MVSCDwnld abanooned."
 exit 1
else
 cp -uv $CRM_BASE/Downloads/'SCPA Public.xlsx' \
  $folderbase/Territories/RawData/SCPA/SCPA-Downloads/SCPA-Public_$P1-$P2.xlsx
fi
#endprochere
if [ "$USER" != "vncwmk3" ];then
 notify-send "MVSCDwnld" "$mm $dd complete."
fi
echo "MVSCDwnld complete."
~/sysprocs/LOGMSG "  MVSCDwnld complete."
