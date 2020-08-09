create or replace view assignments as
select atb.id, json_agg(poia) as items
from data.pharmacy_order_item_assignment as poia, data.assignment as atb
where poia.assignment_id = atb.id
group by atb.id;
alter view assignments owner to api;
