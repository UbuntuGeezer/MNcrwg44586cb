-- * FillGaps86777.psq.sql- module description.
-- * 3/5/23.	wmk.
-- *
-- * Modification History.
-- * ---------------------
-- * 3/5/23.	wmk.	original code.
-- *
-- * Notes. FillGaps86777 adds new records to Terr86777 from a diffs file of
-- * records extracted from SPCA_mm-dd.db. The diffs are obtained by using
-- * the parcel IDs from Terr86777 then selecting any records from SCPA_mm-dd.db
-- * Datammdd with street constraints where the Account#,s are not in the
-- * parcel IDs from Terr86777. The import .csv should be named something like
-- * Diffsmmdd.csv.
-- *;
.open '/home/vncwmk3/Territories/FL/SARA/86777/DB-Dev/Terr86777.db'
CREATE TABLE Diffs0113 ( "Account #" TEXT NOT NULL, "Owner 1" TEXT,
 "Owner 2" TEXT, "Owner 3" TEXT, "Mailing Address 1" TEXT,
 "Mailing Address 2" TEXT, "Mailing City" TEXT, "Mailing State" TEXT, 
 "Mailing Zip Code" TEXT, "Mailing Country" TEXT, 
 "Situs Address (Property Address)" TEXT, "Situs City" TEXT, 
 "Situs State" TEXT, "Situs Zip Code" TEXT, "Property Use Code" TEXT, 
 "Neighborhood" TEXT, "Subdivision" TEXT, "Taxing District" TEXT, 
 "Municipality" TEXT, "Waterfront Code" TEXT, "Homestead Exemption" TEXT, 
 "Homestead Exemption Grant Year" TEXT, "Zoning" TEXT, "Parcel Desc 1" TEXT, 
 "Parcel Desc 2" TEXT, "Parcel Desc 3" TEXT, "Parcel Desc 4" TEXT, 
 "Pool (YES or NO)" TEXT, "Total Living Units" TEXT, "Land Area S. F." TEXT, 
 "Gross Bldg Area" TEXT, "Living Area" TEXT, "Bedrooms" TEXT, "Baths" TEXT, 
 "Half Baths" TEXT, "Year Built" TEXT, "Last Sale Amount" TEXT, 
 "Last Sale Date" TEXT, "Last Sale Qual Code" TEXT, "Prior Sale Amount" TEXT, 
 "Prior Sale Date" TEXT, "Prior Sale Qual Code" TEXT, "Just Value" TEXT, 
 "Assessed Value" TEXT, "Taxable Value" TEXT, 
 "Link to Property Detail Page" TEXT, "Value Data Source" TEXT, 
 "Parcel Characteristics Data" TEXT, "Status" TEXT, "DownloadDate" TEXT, 
 PRIMARY KEY("Account #") );
.mode csv
.separator |
.headers off
.import '/home/vncwmk3/Territories/FL/SARA/86777/RawData/SCPA/SCPA-Downloads/Terr211/Diffs0113.csv' Diffs0113 
INSERT OR IGNORE INTO Terr86777
SELECT * from Diffs0113;
.quit
-- * END FillGaps86777.sql;
