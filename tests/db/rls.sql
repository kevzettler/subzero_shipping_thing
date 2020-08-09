begin;
select * from no_plan();

SELECT schema_privs_are(
    'api', 'webuser', ARRAY['USAGE'],
    'authenticated users should have usage privilege of the api schema'
);


-- switch to a anonymous application user
set local role anonymous;
set request.jwt.claim.role = 'anonymous';

select set_eq(
    'select id from api.drugs',
    array[ 1, 2, 3, 4, 5, 6 ],
    'only public drugs are visible to anonymous users'
);


select * from finish();
rollback;
