create table order_item ( --df: size=9
       id    serial primary key,
       order_id int not null,
       quantity int not null,
       drug_id int references drug(id)
);
