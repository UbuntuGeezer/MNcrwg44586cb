CREATE TEMP TABLE QGetTerr( OwningParcel TEXT NOT NULL,
 UnitAddress TEXT, QNum TEXT, QSitus TEXT, 
 QDir TEXT, Unit TEXT,
 Resident1 TEXT, Phone1 TEXT, Phone2 TEXT,
   "RefUSA-Phone" TEXT,SubTerritory TEXT,
    CongTerrID TEXT, DoNotCall INTEGER DEFAULT 0,
     RSO INTEGER DEFAULT 0, "Foreign" INTEGER DEFAULT 0,
      RecordDate REAL DEFAULT 0, SitusAddress TEXT DEFAULT "",
       PropUse INTEGER
 );
-- populate temp table with extra sorting fields from PolyTerri and MultiMail; TerrProps and;
--  SplitProps records for territory;
.shell echo "Populating TEMP table QGetTerr from .Props tables" | awk '{print \$1}' >> SQLTrace.txt
-- use homestead information already in records;
