create table pharmacy( --df: size=4
       id    serial primary key,
       --id uuid primary key default uuid_generate_v4(), --df: nogen
       name varchar(32) unique not null, --df: prefix=pharmacy
       location varchar(2),
       constraint state_string check (location ~* '[A-Z]{2}')
);
