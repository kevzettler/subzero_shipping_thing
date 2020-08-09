create table drug( -- df: size=6
       --id UUID not null primary key default uuid_generate_v4(), -- df: nogen
       id    serial primary key,
       name varchar(32) unique not null -- df: prefix=drug
);
