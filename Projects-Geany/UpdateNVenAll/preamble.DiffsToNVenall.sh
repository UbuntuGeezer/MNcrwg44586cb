# preamble.DiffsToNVenAll.sh
echo " ** preamble.DiffsToNVenall.sh out-of-date **";exit 1
echo " ** preamble.DiffsToNVenall.sh out-of-date **";exit 1
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
if [ -z "$TODAY" ];then
 echo "** Use 'export TODAY=yyyy-mm-dd' to set TODAY - DiffsToNVenAll abandoned"
  ~/sysprocs/LOGMSG "  TODAY not set - DiffsToNVenAll abandoned."
  exit 1
fi
#	Environment vars:
NAME_BASE="Terr"
SC_DB="_SC.db"
RU_DB="_RU.db"
SC_SUFFX="_SCBridge"
RU_SUFFX="_RUBridge"
# end preamble.CreateNewSCPA.sh
