# preambleClear.s/.sh - ClearTerrSegs preamble.
#	2/15/23.	wmk.
#	3/5/23.		wmk.	change *P1 to yyy so DoSedSegDefs edits properly.
echo "WARNING: you are about to clear the segment definitions"
read -p " for territory yyy... continue (y/n)? "
yn=${REPLY^^}
if [ "$yn" == "N" ];then
 echo "  Review TerrID.db segment definitions for territory yyy."
 echo "   ClearTerrSegs abandoned at user request."
 exit 1
else
 echo "  Proceeding to clear segment definitions for territory yyy... "
fi
# end preambleClear.sh
