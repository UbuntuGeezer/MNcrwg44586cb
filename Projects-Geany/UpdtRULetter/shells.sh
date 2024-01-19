# shells.sh - local shells as commands.
#	9/3/23.	wmk.
function cdp(){
cd $WINGIT_PATH/TerritoriesCB/MNcrwg44586/Procs-Dev
if [ -z "$P1" ];then cd $P1;fi
}
