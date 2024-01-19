#!/bin/bash
# tarsrch.1.sh
   echo " .tar file is : " 
   cat $TEMP_PATH/tarname.txt
   tar --list --wildcards \
