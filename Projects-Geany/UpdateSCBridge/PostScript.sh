if [ $? -eq 0 ];then
echo " ** PostScript.sh out-of-date **";exit 1
 jumpto NormalExit
# PostScript.sh - test postscript for UpdateSCBridge.sh
#   5/12/23. wmk
# end test postscript
else
 # error handling.
 ~/sysprocs/BLDMSG "  ** $MYPROJ $P1 - sqlite3 FAILED **"
  grep PPid /proc/$$/task/$$/status | \
 mawk \
 '{print "#!/bin/bash";print "export idtext="$2;print "echo \"this process id=$thisid\"";print "echo \"parent process id=$idtext\""}' > temp.sh
 chmod +x temp.sh
 sed -i '1,4d' temp.sh
 . ./temp.sh
# at this point *idtext env var contains process ID that
# can be passed to child processes.
 ps $idtext >> $build_log
 exit 1
fi
jumpto NormalExit
NormalExit:
