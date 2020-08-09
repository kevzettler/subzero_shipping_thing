create table inventory_item ( --df: size=16
       id    serial primary key,
       cost int not null,
       drug_id int references drug(id) not null,
       pharmacy_id int references pharmacy(id) not null
);
