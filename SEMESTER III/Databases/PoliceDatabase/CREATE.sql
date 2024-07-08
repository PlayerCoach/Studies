CREATE DATABASE Policja
go
use Policja 
go

CREATE FUNCTION dbo.IsStringStartingWithCapital (@InputString NVARCHAR(MAX))
RETURNS BIT
AS
BEGIN
    DECLARE @FirstChar NVARCHAR(1)

    -- Get the first character of the string
    SET @FirstChar = LEFT(@InputString, 1)

    -- Check if the first character is an uppercase letter (Unicode value between 65 and 90)
    IF UNICODE(@FirstChar) BETWEEN 65 AND 90
        RETURN 1; -- True
    
	RETURN 0;
END;
go
CREATE FUNCTION ISGENDER(@d char(1)) 
RETURNS BIT
BEGIN
	DECLARE @result BIT = 0
	IF @d = 'K' or @d = 'M' 
		set @result = 1
	return @result
END;
go

create function ISYESNO(@d char(3))
returns BIT
begin
	DECLARE @result BIT = 0
	if @d = 'Tak' or @d = 'Nie'
		set @result = 1
	return @result
end
go

CREATE FUNCTION dbo.IsStringMadeOf11Numbers (@InputString VARCHAR(MAX))
RETURNS BIT
AS
BEGIN
    DECLARE @IsNumeric BIT

    -- Check if the string is numeric and has a length of 11 characters
    SET @IsNumeric = CASE 
                        WHEN ISNUMERIC(@InputString) = 1 AND LEN(@InputString) = 11 THEN 1
                        ELSE 0
                    END

    RETURN @IsNumeric
END;
go

CREATE TABLE Ludzie (
    PESEL VARCHAR(11) NOT NULL PRIMARY KEY CHECK (dbo.IsStringMadeOf11Numbers(PESEL) = 1),
    Imie NVARCHAR(50) NOT NULL CHECK (dbo.IsStringStartingWithCapital(Imie) = 1),
    Nazwisko NVARCHAR(50) NOT NULL CHECK (dbo.IsStringStartingWithCapital(Nazwisko) = 1),
    DataUrodzenia DATE NOT NULL,
    MiejsceUrodzenia NVARCHAR(255) NOT NULL CHECK (dbo.IsStringStartingWithCapital(MiejsceUrodzenia) = 1),
    Plec CHAR(1) NOT NULL CHECK (dbo.ISGENDER(Plec) = 1) ,
    Narodowosc NVARCHAR(70) NOT NULL,
    
    CONSTRAINT UQ_PESEL UNIQUE (PESEL)
);

CREATE TABLE Oddzialy (
    IdOddzialu INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    NazwaOddzialu NVARCHAR(50) NOT NULL,
    Specjalizacja NVARCHAR(50) NOT NULL,
    KodPocztowy VARCHAR(6) CHECK (KodPocztowy LIKE '[0-9][0-9]-[0-9][0-9][0-9]') NOT NULL,
    Miejscowosc NVARCHAR(255) check (dbo.IsStringStartingWithCapital(Miejscowosc) =1) NOT NULL
);



CREATE TABLE Policjanci (
    PESEL VARCHAR(11) NOT NULL,
    Aktywny char(3) check (dbo.ISYESNO(Aktywny) = 1) NOT NULL,
    Stopien NVARCHAR(50) NOT NULL,
    Specjalizacja NVARCHAR(255) NOT NULL,
    Przelozony VARCHAR(11),
    IdOddzialu INT NOT NULL,
    PRIMARY KEY (PESEL),
    FOREIGN KEY (PESEL) REFERENCES Ludzie(PESEL) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Przelozony) REFERENCES Policjanci(PESEL) ON DELETE NO ACTION ON UPDATE NO ACTION, 
    FOREIGN KEY (IdOddzialu) REFERENCES Oddzialy(IdOddzialu) ON DELETE CASCADE ON UPDATE NO ACTION
);


CREATE TABLE Swiadkowie (
    PESEL VARCHAR(11) NOT NULL,
    KodPocztowy VARCHAR(6) CHECK (KodPocztowy LIKE '[0-9][0-9]-[0-9][0-9][0-9]') NOT NULL,
    Miejscowosc NVARCHAR(255) CHECK (dbo.IsStringStartingWithCapital(Miejscowosc) = 1) NOT NULL,
    NrTelefonu VARCHAR(11) CHECK (NrTelefonu LIKE '[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9]') NOT NULL,
    PRIMARY KEY (PESEL),
    FOREIGN KEY (PESEL) REFERENCES Ludzie(PESEL) ON DELETE CASCADE ON UPDATE CASCADE,

	CONSTRAINT UQ_TELEFON UNIQUE (NrTelefonu)
);

CREATE TABLE Ofiary (
    Zywa char(3) check (dbo.ISYESNO(Zywa) = 1) NOT NULL,
    PESEL VARCHAR(11) NOT NULL,
    PRIMARY KEY (PESEL),
    FOREIGN KEY (PESEL) REFERENCES Ludzie(PESEL) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Rodzaj_przestepstwa (
    Artykul NVARCHAR(50) NOT NULL CHECK (Artykul LIKE '§[0-9]%') PRIMARY KEY ,
	CONSTRAINT UQ_Artykul UNIQUE (Artykul)
);

CREATE TABLE Przestepstwa (
    IdPrzestepstwa INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Opis NVARCHAR(1000) NOT NULL, 
    DataPopelnienia DATE NOT NULL,
    Miejscowosc NVARCHAR(255) NOT NULL CHECK (dbo.IsStringStartingWithCapital(Miejscowosc) = 1),
    Artykul NVARCHAR(50) REFERENCES Rodzaj_przestepstwa(Artykul)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
    CHECK (Artykul LIKE '§[0-9]%')
);


CREATE TABLE Zgloszenia (
    NrZgloszenia INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    DataZgloszenia DATE NOT NULL,
    SledztwoWToku char(3) check (dbo.ISYESNO(SledztwoWToku) = 1) NOT NULL, 
    Opis NVARCHAR(1000) NOT NULL, 
    IdOddzialu INT NOT NULL REFERENCES Oddzialy(IdOddzialu)
        ON DELETE CASCADE ON UPDATE CASCADE,
    IdPrzestepstwa INT NOT NULL REFERENCES Przestepstwa(IdPrzestepstwa)
        ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE Swiadkowie_przestepstwa (
    PESEL VARCHAR(11) NOT NULL REFERENCES Swiadkowie(PESEL)
        ON DELETE CASCADE ON UPDATE CASCADE,
    IdPrzestepstwa INT NOT NULL REFERENCES Przestepstwa(IdPrzestepstwa)
        ON DELETE CASCADE ON UPDATE CASCADE,
    Przesluchany char(3) check (dbo.ISYESNO(Przesluchany) = 1) NOT NULL,
    PRIMARY KEY (PESEL, IdPrzestepstwa)
);

CREATE TABLE Przestepcy (
    CechyCharakterystyczne NVARCHAR(1000) NOT NULL, 
    PESEL VARCHAR(11) NOT NULL REFERENCES Ludzie(PESEL)
        ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (PESEL)
);
CREATE TABLE Lista_ofiar_przestepstwa (
    PESEL VARCHAR(11) NOT NULL REFERENCES Ofiary(PESEL)
        ON DELETE CASCADE ON UPDATE CASCADE,
    IdPrzestepstwa INT NOT NULL REFERENCES Przestepstwa(IdPrzestepstwa)
        ON DELETE CASCADE ON UPDATE CASCADE,
    WnioslaOskarzenia char(3) check (dbo.ISYESNO(WnioslaOskarzenia) = 1) NOT NULL, 
    PRIMARY KEY (PESEL, IdPrzestepstwa)
);


CREATE TABLE Lista_przestepstw_przestepcy (
    PESEL VARCHAR(11) NOT NULL REFERENCES Przestepcy(PESEL)
        ON DELETE CASCADE ON UPDATE CASCADE,
    IdPrzestepstwa INT NOT NULL REFERENCES Przestepstwa(IdPrzestepstwa)
        ON DELETE CASCADE ON UPDATE CASCADE,
    PriorytetScigania INT NOT NULL CHECK (1 <= PriorytetScigania AND PriorytetScigania <= 10), -- Adjust the data type based on your needs
    PrzestepcaUkarany char(3) check (dbo.ISYESNO(PrzestepcaUkarany) = 1) NOT NULL, -- Adjust the size based on your needs
    PRIMARY KEY (PESEL, IdPrzestepstwa)
);




