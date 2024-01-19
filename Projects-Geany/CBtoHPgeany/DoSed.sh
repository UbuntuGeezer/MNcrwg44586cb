#!/bin/bash
echo " ** DoSed.sh out-of-date **";exit 1
echo " ** DoSed.sh out-of-date **";exit 1
# DoSed.sh - sed editing for CBtoHPgeany project.
#	4/1/22.	wmk.
#
# Usage.	bash DoSed.sh  projname  hostname
#
# Exit.	MakeMigrateGeany.tmp -> MakeMigrateGeany
P1=$1
P2=$2
if [ -z "$P1" ];then
 echo "DoSed.sh  <projname> [<hostname>] missing parameter(s) - abandoned."
 exit 0
fi
if [ -z "$P2" ];then
 P2=HP
fi
sed "{s?projname?$P1?g;s?convtype?$P2?g}" MakeMigrateGeany.tmp > MakeMigrateGeany
# end DoSed.sh
