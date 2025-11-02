/*
========================================================================================================
Create Database and Schemas
========================================================================================================
Script Purpose:
	This script creates a new database named "Datawarehouse". It checks the existence of this database,
	deletes it if it exists, and then recreates a new one. Additionally, it also creates three schemas:
	bronze, gold, and layer. 
	To drop existing schemas in the database and recreate new ones with the same name,
	this script also checks for the existence of existing & non-existing schemas, deletes them if
	they exist, and recreates them.

Warning:
	Running this script deletes the existing database, "Datawarehouse", if it exists.
 	It will permanently delete all data in the database. Proceed with caution and
	ensure to have proper backups before running.
========================================================================================================
*/
-- -----------------------------------------------------------------------------------------------------
-- Drop and Recreate the Database 'Datawarehouse'
-- -----------------------------------------------------------------------------------------------------
USE master;
GO
-- Drop Database 'Datawarehouse' if it exixts
IF EXISTS (SELECT * FROM sys.databases WHERE name = 'Datawarehouse')
BEGIN
	ALTER DATABASE Datawarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE
	DROP DATABASE Datawarehouse
END;
GO

-- Create Database 'Datawarehouse'
CREATE DATABASE Datawarehouse;

-- -----------------------------------------------------------------------------------------------------
-- Drop and Recreate Schemas
-- -----------------------------------------------------------------------------------------------------
USE Datawarehouse;
GO

-- Drop Schema 'bronze' if it exist
IF EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
BEGIN
	DROP SCHEMA bronze
END;
GO
-- Create Schema 'bronze'
CREATE SCHEMA bronze;
GO
-- Drop Schema 'silver' if it exist
IF EXISTS (SELECT * FROM sys.schemas WHERE name = 'silver')
BEGIN
	DROP SCHEMA silver
END;
GO
-- Create Schema 'silver'
CREATE SCHEMA silver;
GO
-- Drop Schema 'gold' if it exist
IF EXISTS (SELECT * FROM sys.schemas WHERE name = 'gold')
BEGIN
	DROP SCHEMA gold
END;
GO
-- Create Schema 'gold'
CREATE SCHEMA gold;
GO
