# Preamble.sh - preamble for UpdateSCBridge.
echo " ** Preamble.sh out-of-date **";exit 1
#	5/12/23.	wmk.
#jumpto function definition
function jumpto
{
    label=$1
    cmd=$(sed -n "/$label:/{:a;n;p;ba};" $0 | grep -v ':$')
    eval "$cmd"
    exit
}
export thisid=$$
if [ -z "$build_log" ];then
 export build_log=$TEMP_PATH/BuildLog.txt
fi
