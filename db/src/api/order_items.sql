create or replace view order_items as
select * from data.order_item;
alter view order_items owner to api;
