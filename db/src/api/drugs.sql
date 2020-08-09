create or replace view drugs as
select * from data.drug;
alter view drugs owner to api;
