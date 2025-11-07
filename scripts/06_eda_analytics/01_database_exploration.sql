/*
========================================================================================
Explore Database
========================================================================================
Script Purpose: 
	This script accesses metadata information about every object, and its respective
	columns in the gold layer of the data warehouse. Use to get yourself familiar with
  the content or data in the database.
========================================================================================
*/
-- Explore all objects in Database
SELECT * FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'gold';

-- Explore all columns of each object in the gold layer
SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'gold';
