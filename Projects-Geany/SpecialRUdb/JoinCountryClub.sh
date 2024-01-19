#!/bin/bash
echo " ** JoinCountryClub.sh out-of-date **";exit 1
echo " ** JoinCountryClub.sh out-of-date **";exit 1
# JoinCountryClub.sh - Merge all CountryClubMHP street downloads into CountryClubJoined.csv
#	3/22/23.	wmk.
#
# Modification History.
# ---------------------
# 12/7/22.	wmk.	original shell.
# 3/22/23.	wmk.	cat order alphabetized.

cd $pathbase/$rupath/Special
cat BogieSt.csv CarefreeSt.csv\
    ClubhouseRd.csv  GreenCirN.csv GreenCirS.csv LeisureSt.csv \
    StymiePl.csv TurfSt.csv WaterwayN.csv WaterwayS.csv \
 > CountryClubJoined.csv
echo "  CountryClubMHP .csv,s merged into CountryClubJoined.csv..."
#echo "  use cp -pv CountryClubJoined.csv CountryCllubMHP.csv when generating database."
echo "  run sed '/First Name/d' CountryClubJoined > CountryClubMHP.csv when generating database."
echo "  JoinCountryClubMHP complete."
# end JoinCountryClub.sh 
