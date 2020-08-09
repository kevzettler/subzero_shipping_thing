begin;
select * from no_plan();

select * from check_test(
    views_are('api', array['drugs', 'inventory_items', 'min_cost_inventory_items', 'order_items', 'pharmacies', 'assignments', 'orders'], 'tables present' ),
    true,
    'all views are present in api schema',
    'tables present',
    ''
);

select * from check_test(
    functions_are('api', array['login', 'logout', 'signup', 'refresh_token', 'me', 'assign'], 'functions present' ),
    true,
    'all functions are present in api schema',
    'functions present',
    ''
);

select * from finish();
rollback;
