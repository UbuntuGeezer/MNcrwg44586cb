#!/bin/bash
echo " ** MovCountryClub.sh out-of-date **";exit 1
echo " ** MovCountryClub.sh out-of-date **";exit 1
# MovCountryClub.sh - Copy all CountryClubMHP street downloads into RU/Special.
#	6/15/23.	wmk.
#
# Modification History.
# ---------------------
# 3/24/23.	wmk.	original shell.
# 6/15/23.	wmk.	*DWNLD_PATH env var used; *pathbase/*rupath used.
cd $pathbase/$rupath/Special
cp -pv $DWNLD_PATH/BogieSt.csv $pathbase/$rupath/Special
cp -pv $DWNLD_PATH/CarefreeSt.csv $pathbase/$rupath/Special
cp -pv $DWNLD_PATH/ClubHouseRd.csv $pathbase/$rupath/Special
cp -pv $DWNLD_PATH/GreenCirN.csv $pathbase/$rupath/Special
cp -pv $DWNLD_PATH/GreenCirS.csv $pathbase/$rupath/Special
cp -pv $DWNLD_PATH/LeisureSt.csv $pathbase/$rupath/Special
cp -pv $DWNLD_PATH/StymiePl.csv $pathbase/$rupath/Special
cp -pv $DWNLD_PATH/TurfSt.csv $pathbase/$rupath/Special
cp -pv $DWNLD_PATH/WaterwayN.csv $pathbase/$rupath/Special 
cp -pv $DWNLD_PATH/WaterwayS.csv  $pathbase/$rupath/Special
echo "  CountryClubMHP .csv,s moved to RefUSA-Downloads/Special..."
echo "  use JoinCountryClub to join all CountryClubMHP files into CountryClubMoved.csv."
echo "  run sed '/First Name/d' CountryClubMoved > CountryClubMHP.csv when generating database."
echo "  MovCountryClubMHP complete."
# end MovCountryClub.sh 
