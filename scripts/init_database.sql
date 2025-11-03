/*
========================================================================================================
Create Database and Schemas
========================================================================================================
Script Purpose:
	This script creates a new database named "Datawarehouse". It checks the existence of this database,
	deletes it if it exists, and then recreates a new one. Additionally, it also creates five schemas, 
	three (bronze, silver, and gold) of which form the layers of the data warehouse system. The other
	two, 'audit' and 'etl' will be used to hold the etl log table and master pipeline, respectively.

Warning:
	Running this script deletes the existing database, "Datawarehouse", if it exists.
 	It will permanently delete all data in the database. Proceed with caution and
	ensure to have proper backups before running.
========================================================================================================
*/
-- -----------------------------------------------------------------------------------------------------
-- Drop and Recreate 'Datawarehouse' Database
-- -----------------------------------------------------------------------------------------------------
USE master;
GO
-- Drop Database 'Datawarehouse' if it exixts
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'Datawarehouse')
BEGIN
	ALTER DATABASE Datawarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE
	DROP DATABASE Datawarehouse
END;
GO

-- Create Database 'Datawarehouse'
CREATE DATABASE Datawarehouse;

-- -----------------------------------------------------------------------------------------------------
-- create Schemas
-- -----------------------------------------------------------------------------------------------------
USE Datawarehouse;
GO

-- Create Schema 'bronze'
CREATE SCHEMA bronze;
GO

-- Create Schema 'silver'
CREATE SCHEMA silver;
GO
	
-- Create Schema 'gold'
CREATE SCHEMA gold;
GO

-- Create Schema 'audit'
CREATE SCHEMA audit;
GO

-- Create Schema 'etl'
CREATE SCHEMA etl;
GO
