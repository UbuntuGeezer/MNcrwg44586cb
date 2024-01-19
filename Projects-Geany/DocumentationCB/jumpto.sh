#jumpto function definition
echo " ** jumpto.sh out-of-date **";exit 1
echo " ** jumpto.sh out-of-date **";exit 1
function jumpto
{
    label=$1
    cmd=$(sed -n "/$label:/{:a;n;p;ba};" $0 | grep -v ':$')
    eval "$cmd"
    exit
}
