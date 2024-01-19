#!/bin/bash
echo " ** ResetRUdb.sh out-of-date **";exit 1
echo " ** ResetRUdb.sh out-of-date **";exit 1
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
# 10/4/22.    wmk.   (automated) fix *pathbase for CB system.
terr=Terr
rudb=_RU.db
P1=$1
cp -p $pathbase/$rupath/$terr$P1/Previous/$terr$P1$rudb $pathbase/$rupath/$terr$P1
./ClearRUBridge.sh $P1
echo " ResetRUdb $P1 complete."
