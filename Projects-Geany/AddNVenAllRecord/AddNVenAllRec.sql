-- AddNVenAllRec.psq - AddNVenAllRec.sql template.
--	9/22/21.	wmk.
-- *
-- * Modification History.
-- * ---------------------
-- * 9/22/21.	wmk.	original code.
-- *
-- * Notes. sed substitutes property id for w www and download month/day
-- * for m 1 and d 1 within this query, writing the resultant to .sql.
-- *;

.open '/media/ubuntu/Windows/Users/Bill/Territories/DB-Dev/VeniceNTerritory.db'
ATTACH '/media/ubuntu/Windows/Users/Bill/Territories/RawData/SCPA/SCPA-Downloads'
 || '/SCPA_03-19.db'
 AS db15;
-- pragma db15.table_info(Data0319);
-- Note - fieldnames in Data0319 are blank-compressed;

INSERT INTO NVenAll
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
  ValueDataSource , ParcelCharacteristicsData , Status, '2021-03-19'
FROM Data0319
WHERE "Account#" IS '0405050027';
-- now add new record into NVenAccts table;
INSERT INTO NVenAccts
 VALUES('0405050027');
.quit
-- End AddNvenAllRec;
