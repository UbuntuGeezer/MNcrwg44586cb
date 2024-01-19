-- * Add86777Rec.psq - AddNVenAllRec.sql template.
-- *	6/6/22.	wmk.
-- *
-- * Modification History.
-- * ---------------------
-- * 6/5/22.	wmk.	original code; adapted from AddNVenAllRec;
-- *			 *pathbase* support; AnySQLtoSH now required; year change
-- *			 to 2022 in query.
-- * 6/6/22.	wmk.	mod to use IGNORE instead of REPLACE to leave current
-- *			 records intact; header corrected from AddNVenAll to Add86777.
-- * 5/26/23.	wmk.	correct year in SELECT to 2023.
-- *
-- * Notes. sed substitutes property id for w www and download month/day
-- * for m 1 and d 1 within this query, writing the resultant to .sql.
-- *;

.open '/home/vncwmk3/Territories/FL/SARA/86777/DB-Dev/Terr86777.db'
ATTACH '/home/vncwmk3/Territories/FL/SARA/86777/RawData/SCPA/SCPA-Downloads'
 || '/SCPA_05-28.db'
 AS db15;
-- pragma db15.table_info(Data0528);
-- Note - fieldnames in Data0528 are blank-compressed;

INSERT OR IGNORE INTO Terr86777
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
  ValueDataSource , ParcelCharacteristicsData , Status, '2023-05-28'
FROM Data0528
WHERE "Account#" IS '0385050020';
-- now add new record into AllAccts table;
INSERT OR IGNORE INTO AllAccts
 VALUES('0385050020');
.quit
-- End Add86777Rec;
