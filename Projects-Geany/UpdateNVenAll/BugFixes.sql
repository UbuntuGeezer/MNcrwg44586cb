-- This query fixes a big introduced with the 6/19 and 7/22/21
-- SCPA full downloads, where "different" records had these fields
-- all set to their literal field names;
with a AS (SELECT "ACCOUNT #" AS Acct FROM NVenAll
WHERE Acct IS '0172160015' or Acct IS '0173010001')
select "account#","homesteadexemption(yesorno)" FROM Data0722
  where "account#" IN (SELECT Acct FROM a
   where Acct is "account#");
-- fix records here;
with a AS (SELECT "ACCOUNT #" AS Acct FROM NVenAll
WHERE "HOMESTEAD EXEMPTION" like 'homestead exemption%') 
UPDATE NVenAll
SET "HOMESTEAD EXEMPTION" = 
case 
when "ACCOUNT #" IN (select Acct FROM a)
 then (select "homesteadexemption(yesorno)" FROM Data0722
  where "account#" IS NVenAll."Account #")
else "HOMESTEAD EXEMPTION"
end,
"SITUS STATE" = 
case 
when "ACCOUNT #" IN (select Acct FROM a)
 then (select "situsstate" FROM Data0722
  where "account#" IS NVenAll."Account #")
else "SITUS STATE"
end,
"TAXING DISTRICT" = 
case 
when "ACCOUNT #" IN (select Acct FROM a)
 then (select "taxingdistrict" FROM Data0722
  where "account#" IS NVenAll."Account #")
else "TAXING DISTRICT"
end,
"WATERFRONT CODE" =
case 
when "ACCOUNT #" IN (select Acct FROM a)
 then (select "waterfrontcode" FROM Data0722
  where "account#" IS NVenAll."Account #")
else "WATERFRONT CODE"
end,
"HOMESTEAD EXEMPTION GRANT YEAR" =
case 
when "ACCOUNT #" IN (select Acct FROM a)
 then (select "homesteadexemptiongrantyear" FROM Data0722
  where "account#" IS NVenAll."Account #")
else "HOMESTEAD EXEMPTION GRANT YEAR"
end,
"PARCEL DESC 1" =
case 
when "ACCOUNT #" IN (select Acct FROM a)
 then (select "parceldesc1" FROM Data0722
  where "account#" IS NVenAll."Account #")
else "PARCEL DESC 1"
end,
"PARCEL DESC 2" =
case 
when "ACCOUNT #" IN (select Acct FROM a)
 then (select "parceldesc2" FROM Data0722
  where "account#" IS NVenAll."Account #")
else "PARCEL DESC 2"
end,
"PARCEL DESC 3" =
case 
when "ACCOUNT #" IN (select Acct FROM a)
 then (select "parceldesc3" FROM Data0722
  where "account#" IS NVenAll."Account #")
else "PARCEL DESC 3"
end
WHERE "HOMESTEAD EXEMPTION" like 'homestead exemption%';
