#!/bin/bash
echo " ** SpecAnyRU.sh out-of-date **";exit 1
#SpecAnyRU.sh - Add shell header and epilogue to SpecyyyRU.sh file.
# 10/4/22.	wmk.
#
#	Usage. bash SpecAnyRU <terrid>
#		<terrid> - territory ID
#
# Dependencies.
#	environment var folderbase set; points to base for /Territories.
#	SpecXXXRU.sh file is raw SQL converted to shell statements which
#	  write the raw SQL to a file SQLTemp.sql. This shell forms the
#	  basis for the resultant shell created by SpecAnyRU.
#
# Modification History.
# ---------------------
# 10/4/22.	wmk.	*codebase support.
# Legacy mods.
# 5/5/22.	wmk.	*pathbase* support.
# Legacy mods.
# 7/16/21.	wmk.	original shell; adapted from SpecAnySC.
#					mv changed to cp in script when creating .tmp;
#					bug fix in XSC1, XSC2 assignments.
# 8/16/21.	wmk.	fix RefUSA in targpath.
P1=$1
if [ -z "$folderbase" ];then
 if [ "$USER" = "ubuntu" ]; then
  export folderbase=/media/ubuntu/Windows/Users/Bill
 else 
  export folderbase=$HOME
 fi
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories/FL/SARA/86777
fi
if [ -z "$pathbase" ];then
 export codebase=$HOME/GitHub/TerritoriesCB
fi
if [ -z "$system_log" ]; then
 system_log=$folderbase/ubuntu/SystemLog.txt
fi
echo "in SpecAnyRU; systemlog: '$system_log'"
~/sysprocs/LOGMSG "  SpecAnyRU $P1 initiated."
FN=Spec
RU=RU
SC="SC"
TBASE=Terr
TN=Terr
HDR=hdr
XSC="XXXSC"
XRU=XXXRU
SFX1=_1
SFX2=_2
XRU1=$XRU$SFX1
XRU2=$XRU$SFX2
XSC1=$XSC$SFX1
XSC2=$XSC$SFX2
targpath="$pathbase/RawData/RefUSA/RefUSA-Downloads/$TBASE$P1"
bashpath="$pathbase/Procs-Dev"
#	touch $targpath/$FN$P1.tmp
	if test -f $targpath/$FN$P1.tmp;then
	 rm $targpath/$FN$P1.tmp
	fi
	bash $bashpath/SQLtoSH.sh RefUSA/RefUSA-Downloads/$TBASE$P1 $FN$P1$RU
	#echo "check $targpath/$FN$P1$RU.sh..."
	#exit 1
	cp $targpath/$FN$P1$RU.sh $targpath/$FN$P1.tmp
	#echo "check $targpath/$FN$P1.tmp..."
	#exit 1
	touch $targpath/$FN$P1$RU.sh
	rm $targpath/$FN$P1$RU.sh
	echo "$HDR$FN$XRU1.sh $HDR$FN$XRU2.sh being cat'd..."
	cat $bashpath/$HDR$FN$XRU1.sh $targpath/$FN$P1.tmp $bashpath/$HDR$FN$XRU2.sh > $targpath/$FN$P1$RU.sh
	#echo "check $targpath/$FN$P1$RU.sh..."
	#exit 1
	#awk 'NR>=1 && NR<=38' $bashpath/$HDR$FN$XSC.sh > $targpath/$FN$P1$SC.sh
	#echo "bash ~/sysprocs/LOGMSG \"   $FN$P1$SC initiated from make.\"" >> $targpath/$FN$P1$SC.sh
	#echo "echo \"   $FN$P1$SC initiated from make.\"" >> $targpath/$FN$P1$SC.sh
	#awk '{print}' $targpath/$FN$P1.tmp >> $targpath/$FN$P1$SC.sh
	#awk 'NR>=39' $bashpath/$HDR$FN$XSC.sh >> $targpath/$FN$P1$SC.sh
	echo "bash ~/sysprocs/LOGMSG \"   $FN$P1$RU complete.\"" >> $targpath/$FN$P1$RU.sh
	echo "echo \"   $FN$P1$RU complete.\"" >> $targpath/$FN$P1$RU.sh
	echo "s/XXX/$P1/g" > sedative.txt
	sed -i -f sedative.txt $targpath/$FN$P1$RU.sh
~/sysprocs/LOGMSG "  SpecAnyRU $P1 complete."
echo "SpecAnyRU $P1 complete."
# end SpecAnyRU.sh
