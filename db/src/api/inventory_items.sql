create or replace view inventory_items as
select * from data.inventory_item;
alter view inventory_items owner to api;
