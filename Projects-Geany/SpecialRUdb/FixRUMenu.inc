# FixRUMenu.i - Fix201RU.sql, Fix201RU.sh recipe definitions template.
#	6/2/21.	wmk.
#
# Dependencies.
# -------------
# 'make' vars:
#	postpath = filepath for folder containing Fix201RU.sh, Fix201RU.sql
#				(typically ~/RawData../RefUSA-Downloads/Terr201)
# Notes.
# ------
# FixRUMenu.i provides the make recipe for Fix201RU.sh.
# Fix201RU.sh will be considered out-of-date if Fix201RU.sql is newer.

$(postpath)Fix201RU.sh : $(postpath)Fix201RU.sql
	$(bashpath)FixAnyRU.sh 201

$(postpath)Fix201RU.sql : ; 

