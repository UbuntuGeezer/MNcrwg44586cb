# from StackOverflow..
trap 'previous_command=$this_command;this_command=$BASH_COMMAND' DEBUG
#...
badcmd
cmd=$previous_command ret=$?
if [ $ret -ne 0 ];then echo "$cmd failed with error code $ret";fi
# end trapit
