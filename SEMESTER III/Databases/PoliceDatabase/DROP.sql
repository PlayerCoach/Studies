USE Policja;


-- Drop tables
DROP TABLE IF EXISTS dbo.Lista_przestepstw_przestepcy;
DROP TABLE IF EXISTS dbo.Lista_ofiar_przestepstwa;
DROP TABLE IF EXISTS dbo.Przestepcy;
DROP TABLE IF EXISTS dbo.Swiadkowie_przestepstwa;
DROP TABLE IF EXISTS dbo.Zgloszenia;
DROP TABLE IF EXISTS dbo.Przestepstwa;
DROP TABLE IF EXISTS dbo.Rodzaj_przestepstwa;
DROP TABLE IF EXISTS dbo.Ofiary;
DROP TABLE IF EXISTS dbo.Swiadkowie;
DROP TABLE IF EXISTS dbo.Policjanci;
DROP TABLE IF EXISTS dbo.Oddzialy;
DROP TABLE IF EXISTS dbo.Ludzie;

-- Drop functions
DROP FUNCTION IF EXISTS dbo.IsStringStartingWithCapital;
DROP FUNCTION IF EXISTS dbo.ISGENDER;
DROP FUNCTION IF EXISTS dbo.ISYESNO;
DROP FUNCTION IF EXISTS dbo.IsStringMadeOf11Numbers;
go

USE master;
-- Find and close existing connections to the database
DECLARE @kill varchar(8000) = '';  
SELECT @kill = @kill + 'kill ' + CONVERT(varchar(5), session_id) + ';'  
FROM sys.dm_exec_sessions
WHERE database_id  = db_id('Policja');
EXEC(@kill);
DROP DATABASE IF EXISTS Policja;
