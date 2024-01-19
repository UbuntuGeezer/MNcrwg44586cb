#!/bin/bash
mawk -F "|" '{print $3}' $TEMP_PATH/Terryyy.segdefs.cs > $TEMP_PATH/Terryyy.segdefs.csv
