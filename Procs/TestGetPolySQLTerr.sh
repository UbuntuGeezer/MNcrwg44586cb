#!/bin/bash
#TestGetPolySQLTerr.sh - test get territory from PolyTerr.db/TerrProps..
#	9/22/20.	wmk.
#	10/19/20.	wmk.	Territories folder moved up 2 levels
echo ".open /media/ubuntu/Windows/Users/Bill/Territories/PolyTerri.db" > SQLTemp.sql
echo ".output GetTerr115.csv" >> SQLTemp.sql
echo ".read /media/ubuntu/Windows/Users/Bill/Territories/Queries-SQL/PolyTerri-Queries/QGetTerr.sql" >> SQLTemp.sql
echo ".quit" >> SQLTemp.sql
sqlite3 <SQLTemp.sql
ENDSQL "TestGetPolySQLTerr complete - .csv on file GetTerr115.csv"
