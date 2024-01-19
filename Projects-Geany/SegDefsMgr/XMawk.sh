#!/bin/bash
mawk -F "|" '{print $3}' $TEMP_PATH/Terr308.segdefs.cs > $TEMP_PATH/Terr308.segdefs.csv
