# Perscription Routing
This project is built on a [PostgREST](https://github.com/PostgREST) framework called [SubZero](https://github.com/subzerocloud/subzero-starter-kit)

## Install and dependencies
This project requires `docker` and `node`.


To start the project execute

```
docker-compose up -d
```
This will start a server at `localhost:8080` once it is running. you should beable to make a GET request to `http://localhost:8080/rest/` and get back an OpenAPI swagger JSON response.

## Objective and points of interest

The majority of business logic is in the [db](./db) directory. The requested `assign(Order)` function is defined in [db/src/api/assign.sql](db/src/api/assign.sql)

The database is prepopulated with some `pharmacy`, `drugs`, `inventory_item` and `order_item` records. You can find the seed data in `db/src/sample_data/data.sql`

The `assign` function utilizes a database view [min_cost_inventory_items.sql](db/src/api/min_cost_inventory_items.sql) to derive the lowest cost drugs at each pharmacy.q


The `assign` function can be utilized with the following curl command:

``` bash
curl -s -X POST \
     -H "Content-Type: application/json" \
     -H "Accept: application/vnd.pgrst.object+json" \
-d '{"order_id":"5"}' \
http://localhost:8080/rest/rpc/assign
```

```bash
# this is missing inventory entry for drug_id 2
curl -s -X POST \
     -H "Content-Type: application/json" \
     -H "Accept: application/vnd.pgrst.object+json" \
-d '{"destination": "WI", "items": [{"quantity": 9, "drug_id": 5},{"quantity": 9, "drug_id": 3},{"quantity": 9, "drug_id":1}]}' \
http://localhost:8080/rest/rpc/assign

curl -s -X POST \
     -H "Content-Type: application/json" \
     -H "Accept: application/vnd.pgrst.object+json" \
-d '{"destination": "WI", "items": [{"quantity": 2, "drug_id": 5}, {"quantity": 4, "drug_id": 3}]}' \
http://localhost:8080/rest/rpc/assign
```

I am using `order_id: "5"` as an example because it is is a record that has multiple order_items.

You can then retrive the assignment records withf
`curl http://localhost:8080/rest/assignments`

There is a test file in `tests/rest/assign.js` that assert this and can be run with `npm run test_rest`.

## Postscript discussion
After building this I realized my implementation of `assign` may differ from the expected spec by accepting an `order_id` instead of a JSON object of order definition. I assumed orders might be captured elsewhere and not at the `assign` execution. It would be straight forward to update the `assign.sql` function to take a json blob of `order_items` and insert them before doing the assignment.

* Notes on primary keys
I usually prefer to use UUIDs as primary keys because they hide serial data and help prevent url increment attaks. However I encountered some issues with the seed data generator that failed to populate them for the sake of time I switched back to int sequences.

You can see the UUID primaries commented out in some of the models
``` sql
--id UUID not null primary key default uuid_generate_v4(), -- df: nogen
```
