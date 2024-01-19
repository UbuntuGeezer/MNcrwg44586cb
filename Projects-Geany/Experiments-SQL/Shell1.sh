#!/bin/bash
echo " ** Shell1.sh out-of-date **";exit 1
echo " ** Shell1.sh out-of-date **";exit 1
# Shell1 - test shell for passing env var through..
echo "Entering Shell 1.."
echo "testpass = '$testpass'"
. ./Shell2.sh
echo "Back from Shell2..."
echo "testpass = '$testpass'"
# end Shell1
