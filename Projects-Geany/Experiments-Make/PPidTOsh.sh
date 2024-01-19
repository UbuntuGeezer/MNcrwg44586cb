#!/bin/bash
# PPidTOsh.sh - Extract current process ID to shell.
# 5/12/23.	wmk.
#
# Usage. bash  PPidTOsh.sh
#
# Entry. environment var $ $ is current process ID. 
#
# Dependencies.
#
# Modification History.
# ---------------------
# 5/12/23.	wmk.	original shell.
#
# Notes. environment var *thisid is set to $ $ on entry.
#	environment var *build_log set up immediately after *TEMP_PATH.
#
# This code is selectively cloned into any process where traceback
# of involved processes is desired. Processes using this code will likely
# also be using the *jumpto function for error handling.
#
export thisid=$$
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
  ~/sysprocs/LOGMSG "  PPidTOsh - initiated from Make"
  echo "  PPidTOsh - initiated from Make"
else
  ~/sysprocs/LOGMSG "  PPidTOsh - initiated from Terminal"
  echo "  PPidTOsh - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
if [ -z "$build_log" ];then
 export build_log=$TEMP_PATH/BuildLog.txt
fi
#	Environment vars:
if [ -z "$TODAY" ];then
 . ~/GitHub/TerritoriesCB/Procs-Dev/SetToday.sh
#TODAY=2022-04-22
fi
#procbodyhere
 grep PPid /proc/$$/task/$$/status | \
 mawk \
 '{print "#!/bin/bash";print "export idtext="$2;print "echo \"this process id=$thisid\"";print "echo \"parent process id=$idtext\""}' > temp.sh
chmod +x temp.sh
sed -i '1,4d' temp.sh
. ./temp.sh
# at this point *idtext env var contains process ID that
# can be passed to child processes.
ps $idtext
#endprocbody
echo "  PPidTOsh complete."
~/sysprocs/LOGMSG "  PPidTOsh complete."
# end PPidTOsh.sh
