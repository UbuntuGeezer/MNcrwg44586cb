#!/bin/bash
#TestSQL.sh - test batch running of sqlite..
#	9/22/20.	wmk.
echo ".shell ls" > SQLTemp.sql
echo ".quit" >> SQLTemp.sql
sqlite3 <SQLTemp.sql
ENDSQL "ran TestSQL.sh successfully" #
