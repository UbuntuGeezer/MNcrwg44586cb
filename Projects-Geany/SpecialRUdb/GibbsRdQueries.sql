-- GibbsRd queries from SCPA_12-02.db;
-- query for 901-915 Gibbs Rd apartment building;
-- these suckers are totally inconsistent!;
select * from Data1202
where "situsaddress(propertyaddress)"
like '9__   gibbs%'
 and cast(substr("situsaddress(propertyaddress)",1,3) as int)
  >= 901
 and cast(substr("situsaddress(propertyaddress)",1,3) as int)
  <= 915
 and cast(substr("situsaddress(propertyaddress)",1,3) as int)%2
  =1;
