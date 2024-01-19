#!/bin/bash
echo " ** MovManyCsvs.sh out-of-date **";exit 1
echo " ** MovManyCsvs.sh out-of-date **";exit 1
# MovManyCsvs.sh - Move special downloads from *DWNLD_PATH with multiple .csvs to RU/Special.
#	6/15/23.	wmk.
#
# Modification History.
# ---------------------
# 12/8/22.	wmk.	original code.
# 6/15/23.	wmk.	use *DWNLD_PATH env var.
#
cp -pv $DWNLD_PATH/AvensCohosh-1.csv  $pathbase/$rupath/Special
cp -pv $DWNLD_PATH/AvensCohosh-2.csv  $pathbase/$rupath/Special
cp -pv $DWNLD_PATH/BayIndiesN-1.csv  $pathbase/$rupath/Special
cp -pv $DWNLD_PATH/BayIndiesN-2.csv  $pathbase/$rupath/Special
cp -pv $DWNLD_PATH/BayIndiesN-3.csv  $pathbase/$rupath/Special
cp -pv $DWNLD_PATH/BayIndiesS-1.csv  $pathbase/$rupath/Special
cp -pv $DWNLD_PATH/BayIndiesS-2.csv  $pathbase/$rupath/Special
cp -pv $DWNLD_PATH/BrennerPark-1.csv  $pathbase/$rupath/Special
cp -pv $DWNLD_PATH/BrennerPark-2.csv  $pathbase/$rupath/Special
cp -pv $DWNLD_PATH/CapriIslesBlvd-1.csv  $pathbase/$rupath/Special
cp -pv $DWNLD_PATH/CapriIslesBlvd-2.csv  $pathbase/$rupath/Special
cp -pv $DWNLD_PATH/CapriIslesBlvd-3.csv  $pathbase/$rupath/Special
cp -pv $DWNLD_PATH/CountryClubMHP-1.csv  $pathbase/$rupath/Special
cp -pv $DWNLD_PATH/CountryClubMHP-2.csv  $pathbase/$rupath/Special
cp -pv $DWNLD_PATH/SawgrassN-1.csv  $pathbase/$rupath/Special
cp -pv $DWNLD_PATH/SawgrassN-2.csv  $pathbase/$rupath/Special
cp -pv $DWNLD_PATH/SawgrassS-1.csv  $pathbase/$rupath/Special
cp -pv $DWNLD_PATH/SawgrassS-2.csv  $pathbase/$rupath/Special
cp -pv $DWNLD_PATH/TheEsplanade-1.csv  $pathbase/$rupath/Special
cp -pv $DWNLD_PATH/TheEsplanade-2.csv  $pathbase/$rupath/Special
cp -pv $DWNLD_PATH/WaterfordNE-1.csv  $pathbase/$rupath/Special
cp -pv $DWNLD_PATH/WaterfordNE-2.csv  $pathbase/$rupath/Special
cp -pv $DWNLD_PATH/WaterfordNW-1.csv  $pathbase/$rupath/Special
cp -pv $DWNLD_PATH/WaterfordNW-2.csv  $pathbase/$rupath/Special
