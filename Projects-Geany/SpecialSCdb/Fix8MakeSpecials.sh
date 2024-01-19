#!/bin/bash
# MakeSpecials - fix db= deficiencies in MakeSpecials for Terr8xx.
#	6/5/23.	wmk.
# 
# Modification History.
# ---------------------
# 6/5/23.	wmk.	*pathbase corrected to FL/SARA/86777; OBSOLETE territory 
#			 detection; comments tidied.
# Legacy mods.
# 5/15/22.	wmk.	original shell; adapted from FL/../Fix6MakeSpecials.
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
#
# Notes. Operations performed to port to SpecialSCdb (from SpecialRUdb)
#	name change from Fix6MakeSpecials to Fix8Make specials
#	pathname from FL/SARA/86777 to TX/HDLG/99999
P1=$1
if [ -z "$P1" ];then
 echo "Fix8MakeSpecials <terrid> missing parameter - abandoned."
 exit 1
fi
firstchar=${P1:0:1}
if [ "$firstchar" != "6" ];then
 echo "Fix8MakeSpecials <terrid> <> '6xx' - abandoned."
 exit 1
fi
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ];then
  export folderbase=/media/ubuntu/Windows/Users/Bill
 else
  export folderbase=$HOME
 fi
fi
TEMP_PATH=$HOME/temp
if [ -z "$codebase" ];then
 codebase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories/FL/SARA/86777
fi
srcpath=$folderbase/Territories/RawData/RefUSA/RefUSA-Downloads/Terr$P1
targpath=$pathbase/RawData/RefUSA/RefUSA-Downloads/Terr$P1
if test -f $targpath/OBSOLETE;then
 echo " ** target territory $P1 OBSOLETE - Fix8MakeSpecials exiting..**"
 exit 2
fi
echo "initiating Fix8MakeSpecials $P1 ..."
# check that both files exist...
if ! test -f $srcpath/MakeSpecials || ! test -f $targpath/MakeSpecials ;then
 echo "Fix8MakeSpecials $P1 source or target MakeSpecials missing - abandoned."
 exit 1
fi
# check target already modified...
grep -e "5/14/22." $targpath/MakeSpecials > $TEMP_PATH/scratchfile
if [ $? -eq 0 ];then
 grep -e "5/14/22.a" $targpath/MakeSpecials > $TEMP_PATH/scratchfile
 if [ $? -eq 0 ];then
  echo "Fix8MakeSpecials Terr$P1/MakeSpecials already fixed - skipped."
  exit 0
 else
  doallmods=0
 fi
else
 doallmods=1
fi
# check target for .PHONY and .ONESHELL statements...
grep -e ".PHONY" $targpath/MakeSpecials > $TEMP_PATH/scratchfile
if [ $? -ne 0 ];then
 echo "Fix8MakeSpecials Terr$P1/MakeSpecials missing .PHONY statement - abandoned."
 exit 1
fi
grep -e ".ONESHELL" $targpath/MakeSpecials > $TEMP_PATH/scratchfile
if [ $? -ne 0 ];then
 echo "Fix8MakeSpecials Terr$P1/MakeSpecials missing .ONESHELL statement - abandoned."
 exit 1
fi
mawk -f getdbnames.txt $srcpath/MakeSpecials > sedDBs.txt
cat sedDBs.txt
echo ""
#sed -f sedDBs.txt $pathbase/RawData/RefUSA/RefUSA-Downloads/Terr$P1/MakeSpecials
if [ $doallmods -eq 1 ];then
 sed -i '1 a# 5/14/22.      wmk.   (automated) add paths, dbnames, MHP, LETTER vars.' $targpath/MakeSpecials
else
 sed -i '1 a# 5/14/22.a      wmk.   (automated) add paths, dbnames, MHP, LETTER vars.' $targpath/MakeSpecials
fi
if [ $doallmods -eq 1 ];then
 sed -i -f sedIPaths.txt $targpath/MakeSpecials
 sed -i -f sedDBs.txt $targpath/MakeSpecials
fi
sed -i -f sedISpecPath.txt $targpath/MakeSpecials
echo "Fix8MakeSpecials $P1 complete."
