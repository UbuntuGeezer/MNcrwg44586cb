echo "ready for trap..EXIT"
trap 'echo "exiting.. errcode=0"' EXIT 0
echo "past trap..EXIT"
