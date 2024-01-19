$(postpath)FixyyyRU.sh : $(postpath)FixyyyRU.sql
	$(bashpath)FixAnyRU.sh yyy

$(postpath)FixyyyRU.sql : ;

#$(postpath)FixyyyRU.sql : JustDoIt
#	echo "** FixyyyRU.sql is missing - find it or define it **"
#
#JustDoIt : ; $(ERR)
