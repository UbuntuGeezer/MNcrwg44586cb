-- this is a demonstration of looping on a table in sql
-- 6/28/22.	wmk.
.open '/home/ubuntu/temp/test.db'
drop table if exists t;
create table t (startrange int not null, endrange int not null);
insert into t values(1, 3);
drop table if exists target;
create table target (i int not null);
-- following is a recursive test;
PRAGMA recursive_triggers = on;
create temp trigger ttrig
   before insert on target
   when new.i < (select t.endrange from t) begin
   insert into target values (new.i + 1);
   end;
insert into target values ((select t.startrange from t));
select * from target;
