BEGIN;
\set QUIET on
\set ON_ERROR_STOP on
set client_min_messages to warning;
truncate data.user restart identity cascade;
truncate data.drug restart identity cascade;
truncate data.pharmacy restart identity cascade;
truncate data.order_item restart identity cascade;
truncate data.inventory_item restart identity cascade;
truncate data.assignment restart identity cascade;
\ir data.sql
COMMIT;
