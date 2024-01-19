--Useful queries...

-- * query to grab range of unitaddress numbers from Special RU Bridge;
select * from Special_Bridge 
where cast(SUBSTR(UnitAddress,1,4) AS INT) >= 1101 
AND cast(SUBSTR(UNitAddress,1,4) AS INT) <= 1522
ORDER BY UNitAddress
;

-- * query to find grab a range of house numbers from Special RU polygon;
select * from Special_Poly 
where cast("house number" as int) >= 1101
and cast("house number" as int) <= 1522
order by "house number";

-- query to find max property ID for a given multidwelling unitaddress;
with a AS (select cast(owningparcel as int) as PropNum,
 unitaddress from Terr210_SCBridge
 where unitaddress like '634%')
Select * from Terr210_SCBridge
where cast(owningparcel as int) 
 in (select max(PropNum) from a)

