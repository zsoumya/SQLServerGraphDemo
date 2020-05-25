/*
-- Drop all tables (Will not work in Azure SQL)
EXEC sp_msforeachtable "ALTER TABLE ? NOCHECK CONSTRAINT ALL"
EXEC sp_MSforeachtable @command1 = "DROP TABLE ?"
*/

DROP TABLE IF EXISTS dbo.Entity
DROP TABLE IF EXISTS dbo.EntityType

CREATE TABLE dbo.EntityType
(
	EntityTypeId INT NOT NULL IDENTITY PRIMARY KEY,
	Name VARCHAR(100) NOT NULL
)

INSERT INTO dbo.EntityType (Name)
VALUES 
	('Company'),
	('LLC'),
	('Trustee')

CREATE TABLE dbo.Entity
(
	EntityId INT NOT NULL IDENTITY PRIMARY KEY,
	Name VARCHAR(100) NOT NULL,
	EntityTypeId INT NOT NULL REFERENCES dbo.EntityType (EntityTypeId)
) AS NODE

INSERT INTO dbo.Entity (Name, EntityTypeId)
VALUES 
	('A', (SELECT TOP (1) EntityTypeId FROM dbo.EntityType WHERE Name = 'Company' ORDER BY EntityTypeId)),
	('B', (SELECT TOP (1) EntityTypeId FROM dbo.EntityType WHERE Name = 'LLC' ORDER BY EntityTypeId)),
	('C', (SELECT TOP (1) EntityTypeId FROM dbo.EntityType WHERE Name = 'Company' ORDER BY EntityTypeId)),
	('Z', (SELECT TOP (1) EntityTypeId FROM dbo.EntityType WHERE Name = 'Trustee' ORDER BY EntityTypeId)),
	('D', (SELECT TOP (1) EntityTypeId FROM dbo.EntityType WHERE Name = 'Company' ORDER BY EntityTypeId)),
	('E', (SELECT TOP (1) EntityTypeId FROM dbo.EntityType WHERE Name = 'LLC' ORDER BY EntityTypeId)),
	('F', (SELECT TOP (1) EntityTypeId FROM dbo.EntityType WHERE Name = 'Trustee' ORDER BY EntityTypeId)),
	('L', (SELECT TOP (1) EntityTypeId FROM dbo.EntityType WHERE Name = 'Company' ORDER BY EntityTypeId)),
	('M', (SELECT TOP (1) EntityTypeId FROM dbo.EntityType WHERE Name = 'Company' ORDER BY EntityTypeId)),
	('E1', (SELECT TOP (1) EntityTypeId FROM dbo.EntityType WHERE Name = 'Company' ORDER BY EntityTypeId)),
	('E2', (SELECT TOP (1) EntityTypeId FROM dbo.EntityType WHERE Name = 'Company' ORDER BY EntityTypeId)),
	('T1', (SELECT TOP (1) EntityTypeId FROM dbo.EntityType WHERE Name = 'Trustee' ORDER BY EntityTypeId))

DROP TABLE IF EXISTS dbo.OwnerOperator

CREATE TABLE dbo.OwnerOperator
(
	OwnerOperatorId INT NOT NULL IDENTITY PRIMARY KEY,
	Name VARCHAR(100) NOT NULL
) AS NODE

INSERT INTO	dbo.OwnerOperator (Name)
VALUES 
	('O1'),
	('O2'),
	('O3'),
	('O4'),
	('O5')

DROP TABLE IF EXISTS dbo.Store

CREATE TABLE dbo.Store
(
	StoreId INT NOT NULL IDENTITY PRIMARY KEY,
	Name VARCHAR(100) NOT NULL
) AS NODE

INSERT INTO dbo.Store (Name)
VALUES
	('S1'),
	('S2')

SELECT * 
FROM dbo.Entity

SELECT *
FROM dbo.Store

SELECT *
FROM dbo.OwnerOperator 

DROP TABLE IF EXISTS dbo.Entity_ChildEntity

CREATE TABLE dbo.Entity_ChildEntity AS EDGE

DROP TABLE IF EXISTS dbo.Entity_Store

CREATE TABLE dbo.Entity_Store
(
	[Percentage] INT NOT NULL
) 
AS EDGE

DROP TABLE IF EXISTS dbo.Owner_Entity

CREATE TABLE dbo.Owner_Entity AS EDGE

DROP TABLE IF EXISTS dbo.OwnerOperator_Store

CREATE TABLE dbo.OwnerOperator_Store
(
	[Percentage] INT NOT NULL
) 
AS EDGE

INSERT INTO dbo.Entity_ChildEntity ($from_id, $to_id)
SELECT
	(SELECT $node_id FROM dbo.Entity WHERE Name = 'A'),
	(SELECT $node_id FROM dbo.Entity WHERE Name = 'C')
UNION
SELECT
	(SELECT $node_id FROM dbo.Entity WHERE Name = 'B'),
	(SELECT $node_id FROM dbo.Entity WHERE Name = 'C')
UNION
SELECT
	(SELECT $node_id FROM dbo.Entity WHERE Name = 'Z'),
	(SELECT $node_id FROM dbo.Entity WHERE Name = 'C')
UNION
SELECT
	(SELECT $node_id FROM dbo.Entity WHERE Name = 'C'),
	(SELECT $node_id FROM dbo.Entity WHERE Name = 'D')
UNION
SELECT
	(SELECT $node_id FROM dbo.Entity WHERE Name = 'C'),
	(SELECT $node_id FROM dbo.Entity WHERE Name = 'E')
UNION
SELECT
	(SELECT $node_id FROM dbo.Entity WHERE Name = 'C'),
	(SELECT $node_id FROM dbo.Entity WHERE Name = 'F')


INSERT INTO dbo.Entity_Store ($from_id, $to_id, [Percentage])
SELECT
	(SELECT $node_id FROM dbo.Entity WHERE Name = 'C'),
	(SELECT $node_id FROM dbo.Store WHERE Name = 'S1'),
	50
UNION
SELECT
	(SELECT $node_id FROM dbo.Entity WHERE Name = 'C'),
	(SELECT $node_id FROM dbo.Store WHERE Name = 'S2'),
	50
UNION
SELECT
	(SELECT $node_id FROM dbo.Entity WHERE Name = 'E1'),
	(SELECT $node_id FROM dbo.Store WHERE Name = 'S1'),
	20
UNION
SELECT
	(SELECT $node_id FROM dbo.Entity WHERE Name = 'E2'),
	(SELECT $node_id FROM dbo.Store WHERE Name = 'S1'),
	10
UNION
SELECT
	(SELECT $node_id FROM dbo.Entity WHERE Name = 'T1'),
	(SELECT $node_id FROM dbo.Store WHERE Name = 'S1'),
	10

INSERT INTO dbo.Owner_Entity ($from_id, $to_id)
SELECT
		(SELECT $node_id FROM dbo.OwnerOperator WHERE Name = 'O1'),
		(SELECT $node_id FROM dbo.Entity WHERE Name = 'C')
UNION
SELECT
		(SELECT $node_id FROM dbo.OwnerOperator WHERE Name = 'O2'),
		(SELECT $node_id FROM dbo.Entity WHERE Name = 'C')
UNION
SELECT
		(SELECT $node_id FROM dbo.OwnerOperator WHERE Name = 'O3'),
		(SELECT $node_id FROM dbo.Entity WHERE Name = 'C')
UNION
SELECT
		(SELECT $node_id FROM dbo.OwnerOperator WHERE Name = 'O1'),
		(SELECT $node_id FROM dbo.Entity WHERE Name = 'L')
UNION
SELECT
		(SELECT $node_id FROM dbo.OwnerOperator WHERE Name = 'O1'),
		(SELECT $node_id FROM dbo.Entity WHERE Name = 'M')

INSERT INTO dbo.OwnerOperator_Store ($from_id, $to_id, [Percentage])
SELECT		
	(SELECT $node_id FROM dbo.OwnerOperator WHERE Name = 'O4'),
	(SELECT $node_id FROM dbo.Store WHERE Name = 'S1'),
	5
UNION
SELECT		
	(SELECT $node_id FROM dbo.OwnerOperator WHERE Name = 'O5'),
	(SELECT $node_id FROM dbo.Store WHERE Name = 'S1'),
	5
