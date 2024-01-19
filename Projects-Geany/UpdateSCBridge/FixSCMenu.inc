#FixSCMenu.in - Recipe for Fix141SC.sh, Fix141SC.sql.
#	4/25/22.	wmk.
#
# Modification History.
# ---------------------
# 3/30/21.	wmk.	original code.
# 4/25/22.	wmk.	/s insertedt in path references.

$(postpath)/Fix141SC.sh : $(postpath)/Fix141SC.sql
	$(bashpath)/FixAnySC.sh 141

# if no .sql, touch it so get empty file to read..
$(postpath)/Fix141SC.sql : 
	touch $(postpath)/Fix141SC.sql 

