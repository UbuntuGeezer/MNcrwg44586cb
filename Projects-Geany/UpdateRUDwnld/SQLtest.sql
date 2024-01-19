-- SQL to test if table exists by accessing and generating error code.
.open '/media/ubuntu/Windows/Users/Bill/Territories/RawData/RefUSA/RefUSA-Downloads/Terr237/Terr237_RU.db'
SELECT * FROM Terr237_junk
WHERE City like "%Venice%" 
LIMIT 1;
.quit
