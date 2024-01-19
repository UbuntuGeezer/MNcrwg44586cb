# preambledelrso.sh - check for "-p" parameter.
#	6/14/23.	wmk.
projpath=$codebase/Projects-Geany/DNCMgr
P1=${1^^}
export partial=0
if [ "$P1" == "-P" ];then
 export partial=1
fi
# end preambledelrso.sh
