--CollectMoveOuts.sql - collect addresses of moveouts from territory;
--	4/24/22.	wmk.
--
-- Modification History.
-- ---------------------
-- * 4/24/22.	wmk.	code generalized for FL/SARA/86777;*pathbase*, 
-- *			 *congterr*, *conglib* env vars introduced.
-- * Legacy mods.
-- 9/8/21.	wmk.	original code.
-- *
-- * Notes. CollectMoveOuts runs a difference query using the present
-- * Terrxxx_RU.db (main) comparing against the previous
-- * Terrxxx_RU.db (db12), locating UnitAddresses/Units in the previous
-- * db that are not in the current db. It will then integrate those
-- * records back into the current db with a "?" substituted for the
-- * old resident. This keeps all the addresses intact, but indicates
-- * those for which RefUSA did not find a current resident.
-- * This algorithm does not apply to SC data, since the SC addresses
-- * are static.
-- *;
-- below does not use unit;
with a AS (SELECT UnitAddress AS StreetAddr
 from Terr201_RUBridge)
select * from db12.Terr201_RUBridge
where UnitAddress NOT IN (Select StreetAddr from a); 
-- below uses unit;
with a AS (SELECT UnitAddress AS StreetAddr,
 Unit AS RUnit
 from Terr201_RUBridge)
select * from db12.Terr201_RUBridge
where UnitAddress NOT IN (Select StreetAddr from a
  where RUnit IS Unit); 
