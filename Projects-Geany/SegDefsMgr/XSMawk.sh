#!/bin/bash
# XSMawk.sh - execute *mawk on Special.segdefs. 3/22/23. wmk.
mawk -F "|" '{print $3}' $TEMP_PATH/Special.segdefs.cs > $TEMP_PATH/Special.segdefs.csv
