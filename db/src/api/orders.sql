create or replace view orders as
select oi.order_id as id, json_agg(oi) as items
from data.order_item as oi
group by oi.order_id;
alter view orders owner to api;
