-- * BuildPropTerr.sql - Create table PropTerr in "from scratch" <sc-special-db>.
-- *	12/24/22.	wmk.
CREATE TABLE PropTerr (
"Account #" TEXT NOT NULL, "Owner 1" TEXT, "Owner 2" TEXT, "Owner 3" TEXT,
"Mailing Address 1" TEXT, "Mailing Address 2" TEXT, "Mailing City" TEXT, 
"Mailing State" TEXT, "Mailing Zip Code" TEXT, "Mailing Country" TEXT, 
"Situs Address (Property Address)" TEXT, "Situs City" TEXT, "Situs State" TEXT, 
"Situs Zip Code" TEXT, "Property Use Code" TEXT, "Neighborhood" TEXT, 
"Subdivision" TEXT, "Taxing District" TEXT, "Municipality" TEXT, 
"Waterfront Code" TEXT, "Homestead Exemption" TEXT, 
"Homestead Exemption Grant Year" TEXT, "Zoning" TEXT, "Parcel Desc 1" TEXT, 
"Parcel Desc 2" TEXT, "Parcel Desc 3" TEXT, "Parcel Desc 4" TEXT, 
"Pool (YES or NO)" TEXT, "Total Living Units" TEXT, "Land Area S. F." TEXT, 
"Gross Bldg Area" TEXT, "Living Area" TEXT, "Bedrooms" TEXT, "Baths" TEXT, 
"Half Baths" TEXT, "Year Built" TEXT, "Last Sale Amount" TEXT, 
"Last Sale Date" TEXT, "Last Sale Qual Code" TEXT, "Prior Sale Amount" TEXT, 
"Prior Sale Date" TEXT, "Prior Sale Qual Code" TEXT, "Just Value" TEXT, 
"Assessed Value" TEXT, "Taxable Value" TEXT, 
"Link to Property Detail Page" TEXT, "Value Data Source" TEXT, 
"Parcel Characteristics Data" TEXT, "Status" TEXT, DownloadDate TEXT, 
TID TEXT, 
PRIMARY KEY("Account #") );
