--difftest.sql
-- .open 'SCPA_0205.db'
-- attach 'Terr86777.db ' as db2;

create temp table ChangeKeys
(PropID text, LastSold text, Hstead text,
primary key (PropID));

insert into ChangeKeys
select "account#",
"lastsaledate", "homestead(yesorno)"
from Data0205;

create temp table OldKeys
(PropID text, LastSold text, Hstead text,
primary key (PropID));

-- attach 'Terr86777.db' as db2;
insert into OldKeys
select "account #",
"last sale date", "homestead exemption"
from db2.nvenall;

with a as (select * from OldKeys)
select * from ChangeKeys
 where PropID in (select propid from OldKeys 
  where lastsold is not changekeys.lastsold);

--************************************************;
--the following query is golden for db14.SCPA_01-02.db,
-- db15.SCPA_02-05.db, db8.AuxSCPAData.db with SCPADiff_02-05.db as main;
INSERT OR IGNORE INTO Diff0205
 SELECT Data0205.* FROM db15.Data0205
   INNER JOIN db14.Data0102
    ON db15.Data0205."Account#" = db14.Data0102."Account#"
   INNER JOIN db8.AcctsNVen
    ON db15.Data0205."Account#" = db8.AcctsNVen."Account"
	WHERE db15.Data0205."LastSaleDate" <> db14.Data0102."LastSaleDate"
	    OR db15.Data0205."HomesteadExemption(YESORNO)"
	       <> db14.Data0102."HomesteadExemption(YESorNO)"
	ORDER BY db14.Data0102."Account#";
--**********************************************************;
with a as (select PropID from DiffAccts 
 where length(TErrID) = 0)
select "Account #" As Acct, "property Use code" as UseType
from Terr86777
where Acct in (select PropID from a);
