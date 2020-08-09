create function hex_to_decimal(hex_string text) returns numeric as $$
declare
    bits bit varying;
    result numeric := 0;
    exponent numeric := 0;
    chunk_size integer := 31;
    start integer;
begin
    execute 'SELECT x' || quote_literal(hex_string) INTO bits;
    -- iterate over bits in the hex string in 32 bit chunks
    -- convert to decimal and add to result
    while length(bits) > 0 loop
        start := greatest(1, length(bits) - chunk_size);
        result := result + (substring(bits from start for chunk_size)::bigint)::numeric * pow(2::numeric, exponent);
        exponent := exponent + chunk_size;
        bits := substring(bits from 1 for greatest(0, length(bits) - chunk_size));
    end loop;
    return trunc(result, 0)::numeric;
end
$$ security definer language plpgsql immutable;

create or replace function assign(_order_id int) returns jsonb as $$
declare
    order_destination text;
    json_result jsonb;
    possible_locations int;
begin
   select into order_destination
     data.order.destination
     from data.order where data.order.id = _order_id;

   raise notice 'order destination ? %', order_destination;

   create temp table possible_drugs_for_order ON COMMIT DROP as
      select oi.order_id, oi.drug_id, quantity, cost, location
      from data.order_item as oi
      left join data.inventory_item as ii on oi.drug_id = ii.drug_id
      left join data.pharmacy as p on p.id = ii.pharmacy_id
      where oi.order_id = _order_id;

   perform * from possible_drugs_for_order where location is null;
   if found then
      raise exception 'Missing inventory for requested drug';
   end if;

   create temp table drugs_with_costs as
    select distinct on (drug_id,location)
      drug_id, min(cost) as min_cost, location,
      (api.hex_to_decimal(MD5(order_destination || location )) % 1000) as shipping_cost,
      ((api.hex_to_decimal(MD5(order_destination || location )) % 1000) + sum(cost)) as total_cost
       from drugs_for_order
    group by drug_id, location;


create temp table drugs_by_location as
select *
from ( -- sub
  select
    array_agg(location) as locations,
    array_agg(drug_id) as drug_ids,
    sum(min_cost) as combined_cost,
    (api.hex_to_decimal(MD5('WI' || location )) % 1000) as shipping_cost,
    ((api.hex_to_decimal(MD5('WI' || location )) % 1000) + sum(min_cost)) as total_cost
  from drugs_with_costs
  group by location
) as drug_location_agg
where array_length(drug_ids, 1) > 1;
   --select into possible_locations count(distinct location) from cheapest_drugs;

   select into json_result jsonb_agg(to_jsonb(cheapest_drugs)) from cheapest_drugs;


   return json_result;
   -- select

   -- new_assignment as (
   --     insert into data.assignment (order_id) values ($1) returning id
   --  )

end;
$$ security definer language plpgsql;


create or replace function assign(destination text, items text) returns jsonb as $$
declare
  new_order_id int;
  item_jsonb jsonb;
begin
   select into item_jsonb items::jsonb;
   raise INFO 'items json %', item_jsonb;

   if(jsonb_array_length(item_jsonb) < 1) then
      raise exception 'order requires items';
   end if;

   insert into data.order (destination)
      values (destination) returning id into new_order_id;

   insert into data.order_item (order_id, quantity, drug_id)
   (select
      new_order_id as order_id,
      item_row.* from jsonb_to_recordset(item_jsonb)
      as item_row(quantity int, drug_id int)
   );

   raise INFO 'assigning order id';
   return api.assign(new_order_id);
end
$$ security definer language plpgsql;
revoke all privileges on function assign(text, text) from public;
