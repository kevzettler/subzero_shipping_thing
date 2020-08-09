\echo # Loading roles privilege

-- this file contains the privileges of all aplications roles to each database entity
-- if it gets too long, you can split it one file per entity ore move the permissions
-- to the file where you defined the entity

-- specify which application roles can access this api (you'll probably list them all)
grant usage on schema api to anonymous, webuser;

-- set privileges to all the auth flow functions
grant execute on function api.login(text,text) to anonymous;
grant execute on function api.logout() to anonymous;
grant execute on function api.signup(text,text,text) to anonymous;
grant execute on function api.me() to webuser;
grant execute on function api.login(text,text) to webuser;
grant execute on function api.logout() to webuser;
grant execute on function api.refresh_token() to webuser;


grant select, insert, update, delete on data.drug to api;
grant select, insert, update, delete on api.drugs to webuser;
grant usage on data.drug_id_seq to webuser;
grant select (id, name) on api.drugs to anonymous;

grant select, insert, update, delete on data.assignment to api;
grant select on api.assignments to anonymous;

grant select, insert, update, delete on data.pharmacy_order_item_assignment to api;

grant select on data.pharmacy to api;
grant select on api.pharmacies to webuser;
grant select on api.pharmacies to anonymous;


grant select on api.orders to anonymous;
grant select, insert, update, delete on data.order to api;

grant select on data.order_item to api;
grant select on api.order_items to webuser;
grant select on api.order_items to anonymous;


grant select on data.inventory_item to api;
grant select on api.inventory_items to webuser;
grant select on api.inventory_items to anonymous;
grant select on api.min_cost_inventory_items to anonymous;

grant execute on function api.assign(int) to anonymous;
grant execute on function api.assign(text, text) to anonymous;
grant execute on function api.hex_to_decimal(text) to anonymous;
