create or replace view pharmacies as
select * from data.pharmacy;
alter view pharmacies owner to api;
