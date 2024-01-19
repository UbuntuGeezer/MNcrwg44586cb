# preamble.DiffsToCongTerr.sh
#
# Modification History.
# 11/27/22.	wmk.   original code.
if [ -z "$TODAY" ];then
 echo "** Use 'export TODAY=yyyy-mm-dd' to set TODAY - DiffsToNVenAll abandoned"
  ~/sysprocs/LOGMSG "  TODAY not set - DiffsToCongTerr abandoned."
  exit 1
fi
#	Environment vars:
NAME_BASE="Terr"
SC_DB="_SC.db"
RU_DB="_RU.db"
SC_SUFFX="_SCBridge"
RU_SUFFX="_RUBridge"
# end preamble.DiffsToCongTerr.sh
