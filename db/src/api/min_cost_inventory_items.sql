create or replace view min_cost_inventory_items as
select distinct on (drug_id) drug_id, pharmacy_id, min(cost) as cost from data.inventory_item
group by pharmacy_id, drug_id;
alter view min_cost_inventory_items owner to api;
