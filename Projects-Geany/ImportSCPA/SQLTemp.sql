-- * CreateNewSCPA.psq/sql - Create new SCPA full database
-- * 4/4/23.	wmk.
-- *
-- * Modification History.
-- *---------------------
-- * 4/26/22.   wmk.    *pathbase* support.
-- * 4/4/23.	wmk.	separator set to |.
-- Legacy mods.
-- 9/30/20.	wmk.	original code.
-- 8/25/21.	wmk.	documented and improved.
-- 9/29/21.	wmk.	changed from mm dd to m 2 d 2 to avoid problems
--					with sed editing dd into fields containing 'address'.
-- 11/3/21.	wmk.	revert to using $ folderbase, replacing 'folderbase';
--			 superfluous "s removed; PRIMARY KEY added to table
--			 definition; column DownloadDate added.
-- 1/2/22.	wmk.	change welded date to $ TODAY.
--
-- Notes. Raw download data on file Dataxxyy.csv where xxyy is mmdd;
-- sed modifies this SQL, changing mm and dd to the correct values
--;
.cd '/home/vncwmk3/Territories/FL/SARA/86777/RawData/SCPA/SCPA-Downloads'
.open 'SCPA_05-28.db'
DROP TABLE IF EXISTS Data0528;
CREATE TABLE Data0528 
( "Account#" , Owner1 , Owner2 , Owner3 , MailingAddress1 , 
MailingAddress2 , MailingCity , MailingState , MailingZipCode , 
MailingCountry , "SitusAddress(PropertyAddress)" , SitusCity , 
SitusState , SitusZipCode , PropertyUseCode , Neighborhood , 
Subdivision , TaxingDistrict , Municipality , WaterfrontCode , 
"HomesteadExemption(YESorNO)" , HomesteadExemptionGrantYear , 
Zoning , ParcelDesc1 , ParcelDesc2 , ParcelDesc3 , 
ParcelDesc4 , "Pool(YESorNO)" , TotalLivingUnits , "LandAreaS.F." , 
GrossBldgArea , LivingArea , Bedrooms , Baths , HalfBaths , 
YearBuilt , LastSaleAmount , LastSaleDate , LastSaleQualCode , 
PriorSaleAmount , PriorSaleDate , PriorSaleQualCode , JustValue , 
AssessedValue , TaxableValue , LinktoPropertyDetailPage , 
ValueDataSource , ParcelCharacteristicsData , "Status",
PRIMARY KEY("Account#") );
-- .show     show current settings
.mode csv
-- make sure are running on path /Territories/SCPA-Downloads;
.separator |
.headers ON
.import '/home/vncwmk3/Territories/FL/SARA/86777/RawData/SCPA/SCPA-Downloads/Data0528.csv' Data0528
-- add DownloadDate column for convenient updating NVenAll;
ALTER TABLE Data0528 ADD COLUMN DownloadDate;
UPDATE Data0528
SET DownloadDate = "2023-05-28";
.quit
-- ** END CreateNewSCPA.sql **********;
