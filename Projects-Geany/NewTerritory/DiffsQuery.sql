with a as (select OwningParcel As Acct,
 CongTerrID as Terr from Terr218_SCBRIDGE)
UPDATE DiffAccts
set TerrID =
case 
when PropID in (Select Acct from a)
 then (select Terr from a
  where Acct IS Propid)
else TerrID
end
WHERE PropID in (SELECT Acct from a);
