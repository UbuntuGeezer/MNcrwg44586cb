#!/bin/bash
echo " ** ErrHandler.sh out-of-date **";exit 1
echo " ** ErrHandler.sh out-of-date **";exit 1
# ErrHandler - Error handler for all SyncAllData makefiles.
#	5/20/23.	wmk.
#	<cmdname> = command with error
#	<ec> = error code
P1=$1
P2=$2
echo "  in SyncAllData/ErrHandler..."
echo "  $MYPROC/command $cmdname blew up.. error = $ec"
# end ErrHandler
