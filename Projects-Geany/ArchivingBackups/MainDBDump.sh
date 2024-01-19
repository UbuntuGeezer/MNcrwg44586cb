#!/bin/bash
# MainDBDump.sh - Dump of main DB-Dev databases to DBdev.tar.
#	9/16/21.	wmk.
echo "MainDBDump is out-of date - abandoned."
exit 1
if [ "$USER" == "ubuntu" ];then
 folderbase=/media/ubuntu/Windows/Users/Bill
else
 folderbase=$HOME
fi
cd $folderbase/Territories
tar --create \
    --file MainDBDev.tar \
    DB-Dev
~/sysprocs/LOGMSG "  MainDBDump to Territories complete."
echo "MainDBDump to Territories complete."
# end MainDBDump.sh
