-- * Report Properties not in Territories (PolyTerri, MultiMail);
select count() TerrID from DiffAccts
where TerrID is '0';

with a as (select PropID from DiffAccts
where TerrID is '0')
select "Account#" Acct, trim(substr("situsaddress(propertyaddress)",1,35)) StreetAddr,
trim(substr("situsaddress(propertyaddress)",36)) Unit
from Diff0528
where "Account#" IN (SELECT PropID FROM a)
order by trim(substr(StreetAddr,instr(StreetAddr,' '))),
 cast(substr(StreetAddr,1,instr(StreetAddr,' ')-1) as integer);
