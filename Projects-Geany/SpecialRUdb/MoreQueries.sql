-- more queries 12/8/21.
-- BirdBayDr.db;
 select * from db220.Spec_RUBridge
 where Unitaddress like '7__%'
 order by SUBSTR(UNitAddress,7,35),
  cast(substr(unitaddress,1,3) as integer),
  unit;
 
 -- SCPA_12-02.db;
select * from db219.Data1202
where "situsaddress(propertyaddress)"
like '6__   BIRD BAY DR%'
order by substr("situsaddress(propertyaddress)",
  7,35),
  cast(substr("situsaddress(propertyaddress)",1,3)
  AS INTEGER),
  SUBSTR("",36);
  
-- BirdBayDr.db;
 select * from db220.Spec_RUBridge
 where Unitaddress like '6__%'
 order by SUBSTR(UNitAddress,7,35),
  cast(substr(unitaddress,1,3) as integer),
  unit;
 
  select * from db220.Spec_RUBridge
 where Unitaddress like '612%'
    or UnitAddress like '618%';

ATTACH '/media/ubuntu/Windows/Users/Bill/Territories'
 || '/RawData/RefUSA/RefUSA-Downloads/Special'
 || '/BirdBayDr.db'
 AS db220;
 select * from db220.Spec_RUBridge
 where Unitaddress like '610%';
 
-- SCPA_12-02.db;
select * from db219.Data1202
where "situsaddress(propertyaddress)"
like '610   BIRD BAY%';

SELECT * FROM db19.Spec_RUBridge
WHERE UNITADDRESS LIKE '%BIRD BAY%';
pragma database_LIST;

SELECT * FROM NVENALL 
WHERE "SITUS ADDRESS (PROPERTY ADDRESS)"
LIKE '%BIRD BAY DR%'
ORDER BY SUBSTR("SITUS ADDRESS (PROPERTY ADDRESS)",
  7,29), CAST(substr("situs address (property address)",
   1,3) AS INTEGER);
   
