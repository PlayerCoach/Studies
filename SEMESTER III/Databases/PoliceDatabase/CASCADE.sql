use Policja;
---DELETE-----

-- Original Data
SELECT * FROM Ludzie WHERE PESEL = '99001112219';
SELECT * FROM Przestepcy
SELECT *  FROM Lista_przestepstw_przestepcy WHERE PESEL = '99001112219'
-- Original Data

DELETE FROM Ludzie WHERE PESEL = '99001112219'; -- Deleting the suspect


-- Check Cascade Deleted Data
SELECT * FROM Ludzie WHERE PESEL = '99001112219';
SELECT * FROM Lista_przestepstw_przestepcy WHERE PESEL = '99001112219';
SELECT * FROM Przestepcy

----UPDATE-----

-- Original Data
SELECT * FROM Ludzie WHERE PESEL = '11001122357';
SELECT * FROM Ofiary
SELECT *  FROM Lista_ofiar_przestepstwa WHERE PESEL = '11001122357'
-- Original Data

UPDATE LUDZIE
SET PESEL = '00000000000'
WHERE PESEL = '11001122357'; -- Alice Smith's PESEL

-- Check Updated Data
SELECT * FROM Ofiary WHERE PESEL = '00000000000';
SELECT * FROM Ludzie WHERE PESEL = '00000000000';
SELECT *  FROM Lista_ofiar_przestepstwa WHERE PESEL = '00000000000'
-- Check Updated Data