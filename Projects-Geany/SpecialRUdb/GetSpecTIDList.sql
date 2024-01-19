-- GetSpecTIDList.sql - Extract territory ID list from <special-db>.
--		11/8/21.	wmk.
-- open <special-id>.db
select terrid from TerrList
where terrid is not null 
 and length(trim(terrid)) > 0
 order by terrid;
