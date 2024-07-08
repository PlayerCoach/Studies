use Policja

/*Policja chce sporz¹dziæ listê przestêpców z najwiêksz¹ iloœci¹ przestêpstw,
tak aby mo¿na by³o zwiêkszyæ ich stopieñ poszukiwania, wystawiæ listy goñcze i zwiekszyæ nagrody za przekazane o nich informacje*/

/*Wyœwietl 5 przestêpców z najwiêksz¹ iloœci¹ przestêpstw wraz z ich peselem i imieniem i nazwiskiem*/
--------------------------------------------- ZAPYTANIE 1 --------------------------------------------------------------------------
SELECT TOP 5
    P.PESEL AS 'PESEL',
    LTRIM(RTRIM(L.Imie + ' ' + L.Nazwisko)) AS 'ImieNazwisko',
    COUNT(LP.IdPrzestepstwa) AS 'LiczbaPrzestepstw'

	FROM Przestepcy P
	JOIN Lista_przestepstw_przestepcy LP ON P.PESEL = LP.PESEL
	JOIN Ludzie L ON P.PESEL = L.PESEL
	GROUP BY P.PESEL, L.Imie, L.Nazwisko
	ORDER BY LiczbaPrzestepstw DESC;



--Zapytania pomocnicze ---
SELECT
    P.PESEL AS 'PESEL',
    L.Imie AS 'ImiePrzestepcy',
    L.Nazwisko AS 'NazwiskoPrzestepcy',
    LP.IdPrzestepstwa,
    Prz.Opis AS 'OpisPrzestepstwa'

	FROM Przestepcy P
	JOIN Lista_przestepstw_przestepcy LP ON P.PESEL = LP.PESEL
	JOIN Przestepstwa Prz ON LP.IdPrzestepstwa = Prz.IdPrzestepstwa
	JOIN Ludzie L ON P.PESEL = L.PESEL
	ORDER BY P.PESEL, LP.IdPrzestepstwa;
go
/* Policja chce sprawdziæ , w którym z ostantnich dwóch tygodni zosta³o zg³oszonych wiêcej przestêpstw aby sprawdziæ,
czy nowe metody patrolowania ulic poskutkowa³y zmniejszeniem przestêpczosci*/
/* Wyœwietl tydzieñ w którym wystapi³o wiêcej przestêpstw wraz z iloœci¹ tych przestêpstw*/
--------------------------------------------- ZAPYTANIE 2 ---------------------------------------------------------------------------

WITH ZgloszeniaCount AS (
    SELECT
        YEAR(DataZgloszenia) AS Rok,
        DATEPART(WEEK, DataZgloszenia) AS Tydzien,
        COUNT(NrZgloszenia) AS IloscZgloszen
    FROM
        Zgloszenia
    GROUP BY
        YEAR(DataZgloszenia),
        DATEPART(WEEK, DataZgloszenia)
)
SELECT TOP 1
    Rok,
    Tydzien,
    IloscZgloszen
FROM ZgloszeniaCount
ORDER BY IloscZgloszen DESC;

----zapytanie pomocnicze---------
SELECT
    NrZgloszenia,
    DataZgloszenia,
    SledztwoWToku,
    Opis,
    IdOddzialu,
    IdPrzestepstwa,
    CASE
        WHEN DATEPART(WEEK, DataZgloszenia) = 1 THEN 'Tydzien 1'
        WHEN DATEPART(WEEK, DataZgloszenia) = 2 THEN 'Tydzien 2'
        ELSE 'Inny tydzien'
    END AS TydzienOznaczony
FROM Zgloszenia
WHERE
    DATEPART(WEEK, DataZgloszenia) IN (1, 2);


--------------------------------------------- ZAPYTANIE 3 ---------------------------------------------------------------------------
/* Policja chce sprawdziæ , w której miejscowoœci znajduj¹ siê najbardziej poszukiwani kryminaliœci, aby zwiêkszyæ tam iloœc patroli i przeprowadziæ
dodatkowe œledztwa*/
/* Wyœwietl dane 5 przestepców z najwiêkszym priorytetem œcigania, oraz miejscowosæ w której siê znajduja*/
WITH TopCriminals AS (
    SELECT TOP 5
        LP.PESEL,
        Ludzie.Imie,
        Ludzie.Nazwisko,
        LP.PriorytetScigania
    FROM Lista_przestepstw_przestepcy LP
    JOIN Ludzie ON LP.PESEL = Ludzie.PESEL
    ORDER BY LP.PriorytetScigania DESC
)
SELECT
    TC.PESEL,
    TC.Imie,
    TC.Nazwisko,
    TC.PriorytetScigania,
    P.Miejscowosc

	FROM TopCriminals TC
	JOIN Lista_przestepstw_przestepcy LP ON TC.PESEL = LP.PESEL
	JOIN Przestepstwa P ON LP.IdPrzestepstwa = P.IdPrzestepstwa
	ORDER BY TC.PriorytetScigania DESC, TC.PESEL;

---zapytania pomocnicze---
WITH RankedPrzestepcy AS (
    SELECT
        LP.PESEL,
        Ludzie.Imie,
        Ludzie.Nazwisko,
        LP.PriorytetScigania,
        P.Miejscowosc,
        ROW_NUMBER() OVER (PARTITION BY LP.PESEL ORDER BY LP.PESEL) AS RowNum
    FROM Lista_przestepstw_przestepcy LP
    JOIN Ludzie ON LP.PESEL = Ludzie.PESEL
    JOIN Przestepstwa P ON LP.IdPrzestepstwa = P.IdPrzestepstwa
)
SELECT
    PESEL,
    Imie,
    Nazwisko,
    PriorytetScigania,
    Miejscowosc
FROM
    RankedPrzestepcy
WHERE
    RowNum = 1
ORDER BY
    PESEL;

--------------------------------------------- ZAPYTANIE 4 ---------------------------------------------------------------------------
/* Policja chce wezwaæ œwiadków w sprawie danego przestêpstwa na sprawê s¹dow¹ aby przestêpcy zostali ukarani.*/
/* Wyœwietl dane konaktowe œwiadków danego przestêpstwa*/
SELECT
    SP.IdPrzestepstwa AS 'CrimeID',
    SP.PESEL AS 'WitnessPESEL',
    S.NrTelefonu AS 'NumerTelefonu',
    S.Miejscowosc AS 'Adres'

	FROM Swiadkowie S
	JOIN Swiadkowie_przestepstwa SP ON S.PESEL = SP.PESEL
	WHERE SP.IdPrzestepstwa = 1;

	---zapytanie wspomagajace -----
SELECT
    SP.PESEL AS 'WitnessPESEL',
    SP.IdPrzestepstwa AS 'CrimeID'
FROM
    Swiadkowie_przestepstwa SP;


--------------------------------------------- ZAPYTANIE 5 ---------------------------------------------------------------------------
/* Sprawdza który artyku³ ma najwiecej przestêpstw podpadaj¹cych pod niego, aby mo¿na by³o zwiêkszyæ karê za to przestêpstwo.*/
/* Wyœwietl artyku³, z którym zwi¹zana jest najwieksza iloœæ przestêpstw*/
SELECT TOP 1
    RP.Artykul,
    ArticleCounts.Occurrences AS 'IloscWystapien'
FROM Przestepstwa P
JOIN Rodzaj_przestepstwa RP ON P.Artykul = RP.Artykul
JOIN (
    SELECT
        RP.Artykul,
        COUNT(*) AS Occurrences
    FROM
        Przestepstwa P
    JOIN
        Rodzaj_przestepstwa RP ON P.Artykul = RP.Artykul
    GROUP BY
        RP.Artykul
) 
ArticleCounts ON RP.Artykul = ArticleCounts.Artykul
ORDER BY ArticleCounts.Occurrences DESC;

--zapytanie pomocnicze ---

SELECT
    P.IdPrzestepstwa AS 'CrimeID',
    P.Opis AS 'OpisPrzestepstwa',
    RP.Artykul
FROM Przestepstwa P
JOIN Rodzaj_przestepstwa RP ON P.Artykul = RP.Artykul;

--------------------------------------------- ZAPYTANIE 6 ---------------------------------------------------------------------------
/* Policja chce sporz¹dziæ statystykê jakimi przestêpstwami zajmuje siê dany oddzia³, aby sprawdziæ czy nie odbiega to od ich kompetencji.
W takim wypadku nale¿a³oby przeprowadziæ dodatkowe szkolenie*/
/* Wyœwietl rodzaje przestêpstw i ich iloœæ jakimi zajmuje siê oddzia³ X*/
go
CREATE VIEW CrimeCountByType AS
SELECT
    O.NazwaOddzialu AS 'Oddzial',
    RP.Artykul AS 'RodzajPrzestepstwa',
    COUNT(*) AS 'IloscPrzestepstw'

	FROM Zgloszenia Z
	JOIN Oddzialy O ON Z.IdOddzialu = O.IdOddzialu
	JOIN Przestepstwa P ON Z.IdPrzestepstwa = P.IdPrzestepstwa
	JOIN Rodzaj_przestepstwa RP ON P.Artykul = RP.Artykul
	GROUP BY O.NazwaOddzialu, RP.Artykul;
go

SELECT * FROM CrimeCountByType WHERE Oddzial = 'Oddzial A';

--zapytania pomocnicze---

	SELECT
		Z.NrZgloszenia,
		P.Opis AS 'OpisPrzestepstwa',
		RP.Artykul AS 'RodzajPrzestepstwa'
	FROM Zgloszenia Z
	JOIN Oddzialy O ON Z.IdOddzialu = O.IdOddzialu
	JOIN Przestepstwa P ON Z.IdPrzestepstwa = P.IdPrzestepstwa
	JOIN Rodzaj_przestepstwa RP ON P.Artykul = RP.Artykul
	WHERE O.NazwaOddzialu = 'Oddzial A';



--------------------------------------------- ZAPYTANIE 7 ---------------------------------------------------------------------------
/* Policja chce zobaczyæ jacy najbardziej poszukiwani przestêpcy sa jeszcze na wolnoœci, aby zwiêkszyæ dzialania w sprawie ich z³apania*/
/* Wyœwietl nieukaranych przestêpców z maksymalnym priorytetem œcigania*/
SELECT
		LP.PESEL,
		LP.PriorytetScigania,
		L.Imie,
		L.Nazwisko
	FROM
		Lista_przestepstw_przestepcy LP
	JOIN
		Ludzie L ON LP.PESEL = L.PESEL
	WHERE
		LP.PriorytetScigania = (SELECT MAX(PriorytetScigania) FROM Lista_przestepstw_przestepcy)
		AND LP.PESEL NOT IN (SELECT PESEL FROM Przestepcy WHERE PrzestepcaUkarany = 'Tak');

	---zapytanie pomocnicze---
SELECT
    LP.PESEL,
    LP.PriorytetScigania,
    L.Imie,
    L.Nazwisko

	FROM Lista_przestepstw_przestepcy LP
	JOIN Ludzie L ON LP.PESEL = L.PESEL
	ORDER BY LP.PriorytetScigania DESC;
