# folders.sh - function definitions for TerritoriesCB folders. 9/20/22. wmk.
function cda(){
 cd ~/GitHub/TerritoriesCB
}
function cdab(){
 cd ~/GitHub/TerritoriesCB/Projects-Geany/ArchivingBackups
}
function cdg(){
 P1=$1
 cd ~/GitHub/$P1
}
function cdj(){
 P1=$1
 cd ~/GitHub/TerritoriesCB/Projects-Geany/$P1
}
function cdp(){
 cd ~/GitHub/TerritoriesCB/Procs-Dev
}
function huh(){
 echo "TerritoriesCB/folders.sh functions:"
 echo "cda - change to TerritoriesCB/ folder."
 echo "cdab - change to ArchivingBackups project folder."
 echo "cdg - change to GitHub/*P1 project folder."
 echo "cdj - change to TerritoriesCB/*P1 project folder."
 echo "cdp - change to TerritoriesCB/Procs-Dev folder."
 echo "huh - list this list to terminal."
}
function help(){
 huh
 }
