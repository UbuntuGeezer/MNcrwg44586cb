#!/bin/bash
echo " ** DoSed.sh out-of-date **";exit 1
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
# DoSed.sh - Run sed to fix MakeExtractBas.tmp > MakeExtractBas.
#	4/24/22.	wmk.
#
# Usage. bash DoSed1.sh <basmodule> <xbafile>
#
#	<basmodule> = name of .bas module to extract
#	<xbafile> = .xba from which to extract; default Test.xba
#
# Exit.
#
# Modification History.
# ----------------------
# 3/8/22.	wmk.	original code.
# 4/24/22.	wmk.	*pathbase* env var included.
if [ -z "$folderbase" ];then
 if [ "$USER" = "ubuntu" ]; then
   export folderbase="/media/ubuntu/Windows/Users/Bill"
 else 
  export folderbase=$HOME
 fi
fi
if [ -z "$codebase" ];then
 codebase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$pathbase" ];then
 echo "*pathbase* env var not set - DoSed abandoned."
 exit 1
fi
if [ -z "$system_log" ]; then
 system_log=$folderbase"/ubuntu/SystemLog.txt"
fi
#
P1=$1
P2=$2
if [ -z "$P2" ];then
 P2=Test.xba
fi
#
projpath=$codebase/Projects-Geany/EditBas
echo "s?<basmodule>?$P1?g" > $projpath/sedatives.txt
echo "s?<xbafile>?$P2?g" >> $projpath/sedatives.txt
sed -f $projpath/sedatives.txt  $projpath/MakeExtractBas.tmp >  $projpath/MakeExtractBas
sed -f $projpath/sedatives.txt  $projpath/MakeDeleteXBAbas.tmp >  $projpath/MakeDeleteXBAbas
sed -f $projpath/sedatives.txt  $projpath/MakeReplaceBas.tmp >  $projpath/MakeReplaceBas
echo "DoSed complete."
# end DoSed1sh
