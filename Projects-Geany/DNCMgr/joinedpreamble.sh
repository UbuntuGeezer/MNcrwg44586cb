# adminpreamble.sh - check for admnistrator logged in.
#	6/8/23.	wmk.
projpath=$codebase/Projects-Geany/DNCMgr
. $projpath/WhosLoggedIn.sh
if [ "$adminwho" == "" ];then 
 echo " ** No administrator logged in - MakeCleanupDNCs exiting. **"
 exit 2
fi
