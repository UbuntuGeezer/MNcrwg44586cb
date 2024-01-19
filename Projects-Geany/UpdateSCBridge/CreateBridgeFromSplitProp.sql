-- CreateBridgeFromSplitProp.sql - Use SplitProps to add to Bridge table.
-- * use data from splitprops to populate Bridge table.
WITH a AS (select * from splitprops 
where owningparcel in (SELECT "account #" 
from Diff0619) 
 AND CongTerrID IS "642")
INSERT INTO Terr642_SCBridge
( "OwningParcel" ,
"UnitAddress",
"Unit" , "Resident1" ,
"Phone1" ,  "Phone2" ,
"RefUSA-Phone" , "SubTerritory",
"CongTerrID" , "DoNotCall" ,
"RSO" , "Foreign" ,
"RecordDate" ,
"SitusAddress" , "PropUse" ,
"DelPending" ,
"RecordType" )
SELECT 
OwningParcel ,
UnitAddress, Unit,
Resident1,
Phone1,
Phone2,
"RefUSA-Phone",Subterritory,
"642" , DoNotCall ,
RSO , "Foreign" ,
RecordDate ,
SitusAddress ,
PropUse ,
DelPending,
""
 FROM SplitProps
 WHERE "ACCOUNT #"
  NOT IN (SELECT OWNINGPARCEL FROM a)
  AND CongTerrID IS "642";
