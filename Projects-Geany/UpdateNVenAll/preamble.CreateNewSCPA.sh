# preamble.CreateNewSCPA.sh
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
if [ -z "$TODAY" ];then
 echo "** Use 'export TODAY=yyyy-mm-dd' to set TODAY - CreateNeWSCPa abandoned"
  ~/sysprocs/LOGMSG "  TODAY not set - CreateNewSCPA abandoned."
  exit 1
fi
# end preamble.CreateNewSCPA.sh
