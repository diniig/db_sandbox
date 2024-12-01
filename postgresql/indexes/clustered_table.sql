DROP TABLE IF EXISTS cluster_table_1;

CREATE TABLE cluster_table_1(id INTEGER, name VARCHAR)  WITH (FILLFACTOR = 90);;
INSERT INTO cluster_table_1(id,name) VALUES(1, 'Peter');
INSERT INTO cluster_table_1(id,name) VALUES(2, 'Ivan');
INSERT INTO cluster_table_1(id,name) VALUES(3, 'Sergey');
select * from cluster_table_1 tt;

UPDATE cluster_table_1 SET name = 'Ruslan' WHERE id = 2;
select * from cluster_table_1 tt; -- 2 goes to the end after update

drop index IF exists id_idx;
CREATE INDEX id_idx ON cluster_table_1(id);  -- blocked operation: access to table
CLUSTER verbose cluster_table_1 USING id_idx;
select * from cluster_table_1 tt; -- sequence is repeired

UPDATE cluster_table_1 SET name = 'Anna' WHERE id = 2;
select * from cluster_table_1 tt; 

------------------------------------------------------

DROP TABLE IF EXISTS cluster_table_2;
CREATE TABLE cluster_table_2(id INTEGER, name VARCHAR) WITH (FILLFACTOR = 90);
select * from cluster_table_2;

CREATE INDEX id_idx_2 ON cluster_table_2 (id);
INSERT INTO cluster_table_2 SELECT (random()*100)::INTEGER, 'test' FROM generate_series(1,100) AS g(i);
select * from cluster_table_2;
select * from cluster_table_2 order by id;

CLUSTER VERBOSE cluster_table_2 USING id_idx_2;
select * FROM cluster_table_2;

UPDATE cluster_table_2 SET id = id * (random()::INTEGER);
SELECT id FROM cluster_table_2;

CLUSTER VERBOSE cluster_table_2;
SELECT id FROM cluster_table_2;

------------------------------------------------------
