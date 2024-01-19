-- * SCNewImport.psq - SCNewImport.sql template.
-- *	1/14/23.	wmk.
-- *
-- * Modification History.
-- * ---------------------
-- * 1/14/23.	wmk.	original code; adapted from AddTerr86777Record.sql.
-- * Legacy mods.
-- * 6/5/22.	wmk.	original code; adapted from AddNVenAllRec;
-- *			 *pathbase* support; AnySQLtoSH now required; year change
-- *			 to 2022 in query.
-- * 6/6/22.	wmk.	mod to use IGNORE instead of REPLACE to leave current
-- *			 records intact; header corrected from AddNVenAll to Add86777.
-- *
-- * Notes. sed substitutes mm for @ @ and dd for z z
-- * for m 1 and d 1 within this query, writing the resultant to .sql.
-- *;

.open '/home/vncwmk3/Territories/FL/SARA/86777/DB-Dev/Terr86777.db'
ATTACH '/home/vncwmk3/Territories/FL/SARA/86777/RawData/SCPA/SCPA-Downloads'
 || '/SCPA_01-13.db'
 AS db15;
-- pragma db15.table_info(Data0113);
-- Note - fieldnames in Datam1d1 are blank-compressed;
DROP TABLE IF EXISTS NewImport;
CREATE TEMP TABLE NewImport(
 "Account#" TEXT, Owner1 TEXT, Owner2 TEXT, Owner3 TEXT, MailingAddress1 TEXT,
 MailingAddress2 TEXT, MailingCity TEXT, MailingState TEXT, MailingZipCode TEXT,
  MailingCountry TEXT, "SitusAddress(PropertyAddress)" TEXT, SitusCity TEXT, 
  SitusState TEXT, SitusZipCode TEXT, PropertyUseCode TEXT, Neighborhood TEXT, 
  Subdivision TEXT, TaxingDistrict TEXT, Municipality TEXT, WaterfrontCode TEXT, 
  "HomesteadExemption(YESorNO)" TEXT, HomesteadExemptionGrantYear TEXT, 
  Zoning TEXT, ParcelDesc1 TEXT, ParcelDesc2 TEXT, ParcelDesc3 TEXT, 
  ParcelDesc4 TEXT, "Pool(YESorNO)" TEXT, TotalLivingUnits TEXT, 
  "LandAreaS.F." TEXT, GrossBldgArea TEXT, LivingArea TEXT, Bedrooms TEXT, 
  Baths TEXT, HalfBaths TEXT, YearBuilt TEXT, LastSaleAmount TEXT, 
  LastSaleDate TEXT, LastSaleQualCode TEXT, PriorSaleAmount TEXT, 
  PriorSaleDate TEXT, PriorSaleQualCode TEXT, JustValue TEXT, 
  AssessedValue TEXT, TaxableValue TEXT, LinktoPropertyDetailPage TEXT, 
  ValueDataSource TEXT, ParcelCharacteristicsData TEXT, Status TEXT);
.mode csv
.headers off
.import '/home/vncwmk3/Territories/FL/SARA/86777/RawData/SCPA/SCPA-Downloads/Terr900/Full900_SC.csv' NewImport
INSERT OR REPLACE INTO Terr86777
SELECT "Account#" , Owner1 , Owner2 , Owner3 , MailingAddress1 ,
 MailingAddress2 , MailingCity , MailingState , MailingZipCode ,
  MailingCountry , "SitusAddress(PropertyAddress)" , SitusCity , 
  SitusState , SitusZipCode , PropertyUseCode , Neighborhood , 
  Subdivision , TaxingDistrict , Municipality , WaterfrontCode , 
  "HomesteadExemption(YESorNO)" , HomesteadExemptionGrantYear , 
  Zoning , ParcelDesc1 , ParcelDesc2 , ParcelDesc3 , 
  ParcelDesc4 , "Pool(YESorNO)" , TotalLivingUnits , 
  "LandAreaS.F." , GrossBldgArea , LivingArea , Bedrooms , 
  Baths , HalfBaths , YearBuilt , LastSaleAmount , 
  LastSaleDate , LastSaleQualCode , PriorSaleAmount , 
  PriorSaleDate , PriorSaleQualCode , JustValue , 
  AssessedValue , TaxableValue , LinktoPropertyDetailPage , 
  ValueDataSource , ParcelCharacteristicsData , Status, '2023-01-13'
FROM NewImport;
INSERT OR IGNORE INTO AllAccts
 SELECT "Account#" FROM NewImport;
.quit
-- End SCNewImport;
