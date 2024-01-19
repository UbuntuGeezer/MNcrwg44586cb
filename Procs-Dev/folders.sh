# folders.sh - function definitions for TerritoriesCB folders. 9/3/23. wmk.
function setaliases(){
alias cda='cda'
alias cdab='cdab'
alias cdc='cdc'
alias cdd='cdd'
alias cdg='cdg'
alias cdj='cdj'
alias cdp='cdp'
alias cds='cds'
alias cdt='cdt'
alias cdts='cdts'
alias cds='cds'
alias cdss='cdss'
echo "aliases set."
echo "WINUBUNTU_PATH = '$WINUBUNTU_PATH'"
echo "WINGIT_PATH = '$WINGIT_PATH'"
}
function cda(){
 cd $WINGIT_PATH/TerritoriesCB
}
function cdab(){
 cd $WINGIT_PATH/TerritoriesCB/MNcrwg44586/Projects-Geany/ArchivingBackups
}
function cdc(){
 cd $folderbase/Territories/MN/CRWG/44586
 if [ ! -z "$1" ];then cd $1;fi
}
function cdd(){
 cd $folderbase/Territories/MN/CRWG/44586/DB-Dev
}
function cdg(){
 P1=$1
 cd $WINGIT_PATH/$P1
}
function cdj(){
 P1=$1
 cd $WINGIT_PATH/TerritoriesCB/MNcrwg44586/Projects-Geany/$P1
}
function cdp(){
 cd $WINGIT_PATH/TerritoriesCB/MNcrwg44586/Procs-Dev
}
function cdt(){
 cd $WINGIT_PATH/MN/CRWG/44586/RawData/RefUSA/RefUSA-Downloads
}
function cdts(){
 cd $WINGIT_PATH/MN/CRWG/44586/RawData/RefUSA/RefUSA-Downloads/Special
}
function cds(){
 cd $WINGIT_PATH/MN/CRWG/44586/RawData/SCPA/SCPA-Downloads
}
function cdss(){
 cd $WINGIT_PATH/MN/CRWG/44586/RawData/SCPA/SCPA-Downloads/Special
}
function huh(){
 echo "TerritoriesCB/folders.sh functions:"
 echo "cda - change to TerritoriesCB/ folder."
 echo "cdab - change to ArchivingBackups project folder."
 echo "cdg - change to GitHub/*P1 project folder."
 echo "cdj - change to TerritoriesCB/*P1 project folder."
 echo "cdp - change to TerritoriesCB/Procs-Dev folder."
 echo "cdt - change to Territories//FL..RawData../RefUSA-Downloads folder."
 echo "cdts - change to Territories/FL../RawData../RefUSA-Download/Special folder."
 echo "cds - change to Territories/FL../RawData../SCPA-Downloads folder."
 echo "cdss - change to Territories/FL../RawData../SCPA-Downloads/Special folder."
 echo "huh - list this list to terminal."
}
function help(){
 huh
 }
