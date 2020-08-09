create table pharmacy_order_item_assignment(
       id    serial primary key,
       assignment_id int references assignment(id),
       order_item_id int references order_item(id),
       pharmacy_id int references pharmacy(id),
       unique (order_item_id, pharmacy_id)
);
