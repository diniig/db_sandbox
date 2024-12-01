CREATE TABLE foo (c1 integer, c2 text);
INSERT INTO foo
  SELECT i, md5(random()::text)
  FROM generate_series(1, 1000000) AS i;

EXPLAIN SELECT * FROM foo;


INSERT INTO foo
  SELECT i, md5(random()::text)
  FROM generate_series(1, 10) AS i;
 
 
EXPLAIN SELECT * FROM foo;

ANALYZE foo; -- update statstic for table

EXPLAIN ANALYZE SELECT * FROM foo;

SELECT * FROM foo;


BEGIN;
explain INSERT INTO foo
  SELECT i, md5(random()::text)
  FROM generate_series(1, 10000000) AS i;
ROLLBACK;

------------------------------------------

EXPLAIN (ANALYZE,BUFFERS) SELECT * FROM foo;


EXPLAIN SELECT * FROM foo WHERE c1 > 500; -- seq scan !
EXPLAIN SELECT * FROM foo WHERE c1 > 500000; -- index scan !
--If the SELECT returns more than approximately 5-10% of all rows in the table, a sequential scan is much faster than an index scan.
--source: https://stackoverflow.com/questions/5203755/why-does-postgresql-perform-sequential-scan-on-indexed-column

drop index foo_c1_idx;
CREATE index foo_c1_idx ON foo USING btree(c1 asc);

EXPLAIN ANALYZE /*+ IndexScan(foo foo_c1_idx) */ select c1 FROM foo WHERE c1 < 500;












