-- Cleanup from previous query runs
DROP TABLE IF EXISTS S1;
DROP TABLE IF EXISTS M1;
DROP TABLE IF EXISTS S2;
DROP TABLE IF EXISTS M2;
DROP TABLE IF EXISTS S3;
DROP TABLE IF EXISTS M3;

-- Create tables
CREATE TABLE M1 (
    K INT PRIMARY KEY,
    V VARCHAR(20)
);

CREATE TABLE S1 (
    K INT PRIMARY KEY,
    MFK INT,
    V VARCHAR(20),
    CONSTRAINT FK_S1_MFK FOREIGN KEY (MFK) REFERENCES M1(K)
);

CREATE TABLE M2 (
    K1 INT,
    K2 INT,
    V VARCHAR(20),
    PRIMARY KEY (K1, K2)
);

CREATE TABLE S2 (
    K INT PRIMARY KEY,
    MFK1 INT,
    MFK2 INT,
    V VARCHAR(20),
    CONSTRAINT FK_S2_MFK FOREIGN KEY (MFK1, MFK2) REFERENCES M2(K1, K2)
);

-- Insert test data
INSERT INTO M1 (K, V) VALUES (1, 'Value1'), (2, 'Value2');
INSERT INTO S1 (K, MFK, V) VALUES (1, 1, 'SubValue1'), (2, 2, 'SubValue2');
INSERT INTO M2 (K1, K2, V) VALUES (1, 1, 'ValueA'), (2, 2, 'ValueB');
INSERT INTO S2 (K, MFK1, MFK2, V) VALUES (1, 1, 1, 'SubValueA'), (2, 2, 2, 'SubValueB');

-- Check test data
SELECT * FROM M1;
SELECT * FROM S1;
SELECT * FROM M2;
SELECT * FROM S2;

-- Try inserting illegal data
INSERT INTO S1 (K, MFK, V) VALUES (3, 3, 'InvalidSubValue');
INSERT INTO S2 (K, MFK1, MFK2, V) VALUES (3, 3, 3, 'InvalidSubValueB');


-- Now let's deal with ON DELETE CASCADE/SET NULL/NO ACTION clauses

-- S1 will have cascade
ALTER TABLE S1
DROP CONSTRAINT FK_S1_MFK;
ALTER TABLE S1
ADD CONSTRAINT FK_S1_MFK FOREIGN KEY (MFK) REFERENCES M1(K) ON DELETE CASCADE;

-- S2 will have set null
ALTER TABLE S2
DROP CONSTRAINT FK_S2_MFK;
ALTER TABLE S2
ADD CONSTRAINT FK_S2_MFK FOREIGN KEY (MFK1, MFK2) REFERENCES M2(K1, K2) ON DELETE SET NULL;

-- Delete from M1 and M2
DELETE FROM M1 WHERE K = 1;
DELETE FROM M2 WHERE K1 = 1 AND K2 = 1;

-- Check test data again
SELECT * FROM M1;
SELECT * FROM S1;
SELECT * FROM M2;
SELECT * FROM S2;

-- We can see that CASCADE deletes rows that would be in conflict, where SET NULL sets them to null

-- Let's add another table to check ON DELETE NO ACTION clause
CREATE TABLE M3 (
    K INT PRIMARY KEY,
    V VARCHAR(20)
);

CREATE TABLE S3 (
    K INT PRIMARY KEY,
    MFK INT,
    V VARCHAR(20),
    CONSTRAINT FK_S3_MFK FOREIGN KEY (MFK) REFERENCES M3(K) ON DELETE NO ACTION
);

INSERT INTO M3 (K, V) VALUES (1, 'Value1'), (2, 'Value2');
INSERT INTO S3 (K, MFK, V) VALUES (1, 1, 'SubValue1'), (2, 2, 'SubValue2');

DELETE FROM M3 WHERE K = 1;
-- And we can see that NO ACTION means default error

-- ON UPDATE would work the same way