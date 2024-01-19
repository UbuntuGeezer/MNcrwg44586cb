-- SQLTemp.sql - RUNewTerr raw .csv to .db.
.cd '/media/ubuntu/Windows/Users/Bill/Territories'
.cd './BRawData/BRefUSA/BRefUSA-Downloads'
.cd './Terr503'
.open Terr503_RU.db 
DROP TABLE IF EXISTS Terr503_RURaw;
CREATE TABLE Terr503_RURaw
( CompanyName , ExecutiveFirstName , ExecutiveLastName ,
  Address , City , State , ZIPCode , CreditScoreAlpha ,
  ExecutiveGender , ExecutiveTitle , FaxNumberCombined ,
  IUSANumber , LocationEmployeeSizeRange ,
  LocationSalesVolumeRange , PhoneNumberCombined ,
  PrimarySICCode , PrimarySICDescription , SICCode1 ,
 SICCode1Description , RecordType )
;
-- setup and import new records to Terr503_RURaw
.headers ON
.mode csv
.separator ,
.import '/media/ubuntu/Windows/Users/Bill/Territories/BRawData/BRefUSA/BRefUSA-Downloads/Terr503/Map503_RU.csv' Terr503_RURaw
DROP TABLE IF EXISTS Terr503_RUPoly;
CREATE TABLE Terr503_RUPoly 
( CompanyName , ExecutiveFirstName , ExecutiveLastName ,
  Address , City , State , ZIPCode , CreditScoreAlpha ,
  ExecutiveGender , ExecutiveTitle , FaxNumberCombined ,
  IUSANumber , LocationEmployeeSizeRange ,
  LocationSalesVolumeRange , PhoneNumberCombined ,
  PrimarySICCode , PrimarySICDescription , SICCode1 ,
 SICCode1Description , RecordType )
;
INSERT INTO Terr503_RUPoly 
SELECT * FROM Terr503_RURaw  
 ORDER BY Address ;
DROP TABLE IF EXISTS Terr503_RUBridge;
CREATE TABLE Terr503_RUBridge
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
  FROM Terr503_RUPoly)
INSERT INTO Terr503_RUBridge
SELECT BizName, Address, Owner, Phone, BizDesc, City, ZipCode,
 Gender, Title, "503", '', Date('now'), '', ''
 FROM a
;
.quit
