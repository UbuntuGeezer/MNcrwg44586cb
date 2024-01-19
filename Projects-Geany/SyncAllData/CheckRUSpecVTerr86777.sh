#!/bin/bash
echo " ** CheckRUSpecVTerr86777.sh out-of-date **";exit 1
echo " ** CheckRUSpecVTerr86777.sh out-of-date **";exit 1
# CheckRUSpecVTerr86777.sh - Check RU /Special db record dates against Terr86777 dates.
#
# Usage. bash CheckRUSpecVTerr86777.sh <spec-db>
#
#	<spec-db> = /Special database to check against Terr86777 for out-of-date
#
# Entry.
#	 RUSpecV86777.sql created by DoSed1 to compare records.
# 
# Notes. CheckRUSpecVTerr86777 gets the OwningParcel and RecordDate fields 
# from the <spec-db>.db.Spec_RUBridge table and compares them against the 
# "Account #" and DownloadDate fields from Terr86777 where 
# OwningParcel = "Account #". If any corresponding Terr86777 record is newer,
# the <spec-db>.db will be considered out-of-date because the SC data has
# been udpated since the last <spec-db>.db download.
