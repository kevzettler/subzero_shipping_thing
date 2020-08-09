create table "order"(
       id serial primary key,
       destination varchar(2),
       constraint state_string check (destination ~* '[A-Z]')
);
