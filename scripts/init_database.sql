/* 
=======================================================================================================================================
Create Database and Schemas
=======================================================================================================================================
SCRIPT PURPOSE: 
	This script drops existing database named 'Datewarehouse', and recreates a new database with the same name.
	If it exists, it is dropped and a new one is recreated, otherwise, the scipt between 'BEGIN' and 'END' in the 'IF' Statement
	is skipped, and the 'data warehouse 'database is created. Addititionally, the script sets up three schemas within the database: 
	'Bronze', 'Silver', and 'Gold'

WARNING:
  Running this script will drop the entire 'datawarehouse' database if it exists.
  All data in the database will be permanently deleted. Proceed with caution, and
  ensure to have proper backups before running this script
=======================================================================================================================================
*/

USE Master;
GO

-- Drop and Recreate the Database named 'Datawarehouse'
IF EXISTS(SELECT 1 FROM sys.databases WHERE name = 'Datawarehouse')
BEGIN
	ALTER DATABASE Datawarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE Datawarehouse;
END;
GO

-- Create the 'Datawarehouse' Database
CREATE DATABASE Datawarehouse;
GO

USE Datawarehouse;
GO

-- Create Schemas
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO
