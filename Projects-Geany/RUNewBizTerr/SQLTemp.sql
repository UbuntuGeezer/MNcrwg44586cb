-- SQLTemp.sql - RUNewTerr raw .csv to .db.
.cd '/media/ubuntu/Windows/Users/Bill/Territories/FL/SARA/86777'
.cd './BRawData/RefUSA/RefUSA-Downloads'
.cd './Terr521'
.open Terr521_RU.db 
DROP TABLE IF EXISTS Terr521_RURaw;
CREATE TABLE Terr521_RURaw
( CompanyName , ExecutiveFirstName , ExecutiveLastName ,
  Address , City , State , ZIPCode , CreditScoreAlpha ,
  ExecutiveGender , ExecutiveTitle , FaxNumberCombined ,
  IUSANumber , LocationEmployeeSizeRange ,
  LocationSalesVolumeRange , PhoneNumberCombined ,
  PrimarySICCode , PrimarySICDescription , SICCode1 ,
 SICCode1Description , RecordType )
;
-- setup and import new records to Terr521_RURaw
.headers ON
.mode csv
.separator ,
.import '/media/ubuntu/Windows/Users/Bill/Territories/FL/SARA/86777/BRawData/RefUSA/RefUSA-Downloads/Terr521/Map521_RU.csv' Terr521_RURaw
DROP TABLE IF EXISTS Terr521_RUPoly;
CREATE TABLE Terr521_RUPoly 
( CompanyName , ExecutiveFirstName , ExecutiveLastName ,
  Address , City , State , ZIPCode , CreditScoreAlpha ,
  ExecutiveGender , ExecutiveTitle , FaxNumberCombined ,
  IUSANumber , LocationEmployeeSizeRange ,
  LocationSalesVolumeRange , PhoneNumberCombined ,
  PrimarySICCode , PrimarySICDescription , SICCode1 ,
 SICCode1Description , RecordType )
;
INSERT INTO Terr521_RUPoly 
SELECT * FROM Terr521_RURaw  
 ORDER BY Address ;
DROP TABLE IF EXISTS Terr521_RUBridge;
CREATE TABLE Terr521_RUBridge
( CompanyName TEXT, UnitAddress TEXT, Owner1 TEXT,
 ContactPhone TEXT, BizDesc TEXT, City TEXT, Zip TEXT, 
 OGender TEXT, OTitle TEXT, CongTerrID TEXT, 
 DoNotCall INTEGER DEFAULT 0, RecordDate REAL DEFAULT 0, 
 SunBizDoc TEXT, DelPending INTEGER DEFAULT 0 )
;
WITH a AS (SELECT CompanyName AS BizName,
  ExecutiveFirstName || ' ' || ExecutiveLastName AS Owner,
Address, City, ZipCode, ExecutiveGender AS Gender, ExecutiveTitle as Title,
  PhoneNumberCombined AS Phone, PrimarySICDescription AS BizDesc
  FROM Terr521_RUPoly)
INSERT INTO Terr521_RUBridge
SELECT BizName,
 SUBSTR(Address,1,Instr(Address,' ')-1) ||
 '  ' || SUBSTR(Address,Instr(Address,' ')), 
 Owner, Phone, BizDesc, City, ZipCode,
 Gender, Title, "521", '', Date('now'), '', ''
 FROM a
;
.quit
