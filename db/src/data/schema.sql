drop schema if exists data cascade;
create schema data;
set search_path = data, public;

-- import our application models
\ir user.sql
\ir drug.sql
\ir pharmacy.sql
\ir order_item.sql
\ir inventory_item.sql
\ir assignment.sql
\ir pharmacy_order_item_assignment.sql
\ir order.sql
