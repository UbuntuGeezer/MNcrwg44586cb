-- DiffAcctsFixes.sql
-- 7/24/21.	wmk.
select * from db30.sqlite_master
where type is "table";

pragma db30.table_info(diff0722);

select * from diffaccts 
where terrid is "103";

select * from DIFF0722 where
"SITUS ADDRESS (PROPERTY ADDRESS)"
 like '%avens dr%';
 
 with a AS (select * from diffaccts)
 select * from diff0722
inner join diffaccts
 on propid = "account #";
  where  is  propid is '103';

SELECT * from diff0722 
where "account #" in (SELECT PROPID from Diffaccts
 where propID is "account #" and terrid is '103'); 

-- * clear terrids from Nokomis prperties that have
-- * venice territory ID;
with a AS (select * from diffaccts 
where cast(terrid as int) < 200)
UPDATE DiffAccts
SET TerrID = ""
where propid in (select "account #" from Diff0722
 where "situs zip code" like '34275%'); 

with a AS (SELECT * FROM DIFFACCTS)
SELECT "ACCOUNT #" AS Acct,
 "SITUS ADDRESS (PROPERTY ADDRESS)" AS StreetAddr,
 "situs zip code" AS Zip FROM DIFF0722
 WHERE ZIP NOT LIKE '34285%' AND 
  "ACCOUNT #" IN (SELECT PropID FROM a
   where cast(terrid AS int) < 200);
 
 update diffaccts
SET TERRID = "311" 
 WHERE PROPID IS '0385160021';

 select * from diffaccts
 WHERE PROPID IS '0385160021';
 
with a AS (select * from diff0722)
update diffaccts
SET TERRID = 
CASE
WHEN PROPID IN (SELECT "ACCOUNT #" FROM a
 WHERE "situs zip code" like '34275%')
 THEN ""
ELSE TERRID
END
where terrid IS '103';

-- this one didnt work..
with a AS (SELECT * FROM DIFFACCTS)
update diffaccts 
set terrid =
case
when propid in (SELECT "ACCOUNT #" AS Acct
FROM DIFF0722
 WHERE "situs ZIP code" NOT LIKE '34285%' AND 
  "ACCOUNT #" IN (SELECT PropID FROM a
   where cast(terrid AS int) < 200)  )
then ""
else terrid
end;
