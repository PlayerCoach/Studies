use Policja
------------ UZUPELNIJ ODDZIA£Y ------------
INSERT INTO Oddzialy (NazwaOddzialu, Specjalizacja, KodPocztowy, Miejscowosc)
VALUES 
  ('Oddzial A', 'Patrol', '12-345', 'Warszawa'),
  ('Oddzial B', 'Detective', '45-678', 'Krakow'),
  ('Oddzial C', 'Cybercrime', '98-765', 'Gdansk'),
  ('Oddzial D', 'SWAT', '23-456', 'Poznan'),
  ('Oddzial E', 'Narcotics', '56-789', 'Wroclaw'),
  ('Oddzial F', 'Intelligence', '34-567', 'Lodz'),
  ('Oddzial G', 'Traffic', '67-890', 'Szczecin'),
  ('Oddzial H', 'Special Investigations', '45-678', 'Katowice'),
  ('Oddzial I', 'Criminal Profiling', '89-012', 'Bydgoszcz'),
  ('Oddzial J', 'Forensics', '56-789', 'Gdynia'),
  ('Oddzial K', 'Counter-Terrorism', '12-345', 'Olsztyn'),
  ('Oddzial L', 'Missing Persons', '78-901', 'Rzeszow'),
  ('Oddzial M', 'White Collar Crime', '23-456', 'Torun'),
  ('Oddzial N', 'Homicide', '45-678', 'Kielce'),
  ('Oddzial O', 'Drug Enforcement', '67-890', 'Opole'),
  ('Oddzial P', 'Gang Unit', '34-567', 'Zielona Gora'),
  ('Oddzial Q', 'Emergency Response', '56-789', 'Czestochowa'),
  ('Oddzial R', 'Cybersecurity', '12-345', 'Sopot'),
  ('Oddzial S', 'K9 Unit', '78-901', 'Elblag'),
  ('Oddzial T', 'Undercover Operations', '23-456', 'Bialystok');

----------------------- KONIEC UZUPELNIJ ODDZIA£Y ----------------------

----------------------- UZUPE£NIJ POLICJANTÓW -----------------------
INSERT INTO Ludzie (PESEL, Imie, Nazwisko, DataUrodzenia, MiejsceUrodzenia, Plec, Narodowosc)
VALUES
    ('12345678901', 'John', 'Doe', '1990-01-01', 'Warszawa', 'M', 'Polish'),
    ('23456789012', 'Jane', 'Smith', '1995-05-15', 'Krakow', 'K', 'Polish'),
    ('34567890123', 'Michael', 'Johnson', '1988-07-20', 'Wroclaw', 'M', 'American'),
    ('45678901234', 'Emily', 'Williams', '1992-03-12', 'Gdansk', 'K', 'British'),
    ('56789012345', 'Christopher', 'Brown', '1985-11-05', 'Poznan', 'M', 'Canadian'),
    ('67890123456', 'Sophia', 'Taylor', '1998-09-28', 'Katowice', 'K', 'German'),
    ('78901234567', 'Daniel', 'Lee', '1987-04-18', 'Lodz', 'M', 'Australian'),
    ('89012345678', 'Olivia', 'Martinez', '1993-12-09', 'Szczecin', 'K', 'Mexican'),
    ('90123456789', 'Ethan', 'Anderson', '1991-06-23', 'Bydgoszcz', 'M', 'Japanese'),
    ('01234567890', 'Ava', 'Garcia', '1996-02-14', 'Lublin', 'K', 'Brazilian'),
    ('11223344556', 'William', 'Johnson', '1986-08-14', 'Bialystok', 'M', 'Canadian'),
    ('22334455667', 'Emma', 'Smith', '1994-04-25', 'Gdynia', 'K', 'French'),
    ('33445566778', 'Alexander', 'Wilson', '1989-12-30', 'Czestochowa', 'M', 'Russian'),
    ('44556677889', 'Sophie', 'Brown', '1997-06-05', 'Sosnowiec', 'K', 'Italian'),
    ('55667788990', 'Matthew', 'Jones', '1984-02-19', 'Radom', 'M', 'Spanish'),
    ('66778899001', 'Isabella', 'Taylor', '1999-10-02', 'Kielce', 'K', 'Chinese'),
    ('77889900112', 'Andrew', 'Martinez', '1985-05-24', 'Kielce', 'M', 'Indian'),
    ('88990011223', 'Mia', 'Anderson', '1992-01-07', 'Lodz', 'K', 'Japanese'),
    ('99001112234', 'Christopher', 'Garcia', '1988-09-18', 'Lublin', 'M', 'Mexican'),
    ('00112233446', 'Ava', 'Hernandez', '1993-03-31', 'Lublin', 'K', 'Brazilian'),
    ('11223344557', 'Liam', 'Wilson', '1986-08-14', 'Bialystok', 'M', 'Australian'),
    ('22334455668', 'Olivia', 'Johnson', '1994-04-25', 'Gdynia', 'K', 'British'),
    ('33445566779', 'Noah', 'Brown', '1989-12-30', 'Czestochowa', 'M', 'Canadian'),
    ('44556677890', 'Ava', 'Smith', '1997-06-05', 'Sosnowiec', 'K', 'French'),
    ('55667788991', 'Lucas', 'Martin', '1984-02-19', 'Radom', 'M', 'German'),
    ('66778899002', 'Emma', 'Taylor', '1999-10-02', 'Kielce', 'K', 'Italian'),
    ('77889900113', 'Mason', 'Hernandez', '1985-05-24', 'Kielce', 'M', 'Japanese'),
    ('88990011224', 'Isabella', 'Garcia', '1992-01-07', 'Radom', 'K', 'Mexican'),
    ('99001112235', 'Sophia', 'Jones', '1988-09-18', 'Radom', 'K', 'Polish'),
    ('00112233434', 'Jackson', 'Anderson', '1993-03-31', 'Radom', 'M', 'Russian'),
    ('11223344558', 'Ethan', 'Miller', '1986-08-14', 'Gdansk', 'M', 'American'),
    ('22334455669', 'Amelia', 'Wilson', '1994-04-25', 'Gdansk', 'K', 'Australian'),
    ('33445566780', 'Aiden', 'Smith', '1989-12-30', 'Warszawa', 'M', 'Canadian'),
    ('44556677891', 'Olivia', 'Jones', '1997-06-05', 'Warszawa', 'K', 'French'),
    ('55667788992', 'Carter', 'Martin', '1984-02-19', 'Warszawa', 'M', 'German'),
    ('66778899003', 'Sophia', 'Taylor', '1999-10-02', 'Gdansk', 'K', 'Italian'),
    ('77889900114', 'Jackson', 'Hernandez', '1985-05-24', 'Gdansk', 'M', 'Japanese'),
    ('88990011225', 'Isabella', 'Garcia', '1992-01-07', 'Kielce', 'K', 'Mexican'),
    ('99001112236', 'Lucas', 'Brown', '1988-09-18', 'Kielce', 'M', 'Polish'),
    ('00112233447', 'Mia', 'Anderson', '1993-03-31', 'Kielce', 'K', 'Russian');


INSERT INTO Policjanci (PESEL, Aktywny, Stopien, Specjalizacja, Przelozony, IdOddzialu)
VALUES 
  ('12345678901', 'Tak', 'Inspektor', 'Patrol', NULL, 1),
  ('23456789012', 'Tak', 'Komisarz', 'Detective', '12345678901', 2),
  ('34567890123', 'Tak', 'Aspirant', 'Cybercrime', '23456789012', 3),
  ('45678901234', 'Tak', 'Komendant', 'SWAT', '34567890123', 4),
  ('56789012345', 'Tak', 'Inspektor', 'Narcotics', '45678901234', 5),
  ('67890123456', 'Tak', 'Komisarz', 'Intelligence', '56789012345', 6),
  ('78901234567', 'Tak', 'Aspirant', 'Traffic', '67890123456', 7),
  ('89012345678', 'Tak', 'Komendant', 'Special Investigations', '78901234567', 8),
  ('90123456789', 'Tak', 'Inspektor', 'Criminal Profiling', '89012345678', 9),
  ('01234567890', 'Tak', 'Komisarz', 'Forensics', '90123456789', 10),
  ('11223344556', 'Tak', 'Aspirant', 'Counter-Terrorism', '01234567890', 11),
  ('22334455667', 'Tak', 'Komendant', 'Missing Persons', NULL, 12),
  ('33445566778', 'Tak', 'Inspektor', 'White Collar Crime', '99001112234', 13),
  ('44556677889', 'Tak', 'Szeregowy', 'Homicide', '99001112234' , 14),
  ('55667788990', 'Tak', 'Aspirant', 'Drug Enforcement', '99001112234', 15),
  ('66778899001', 'Tak', 'Komendant', 'Gang Unit', '99001112234', 16),
  ('77889900112', 'Tak', 'Inspektor', 'Emergency Response','99001112234', 17),
  ('88990011223', 'Tak', 'Komisarz', 'Cybersecurity', '99001112234', 18),
  ('99001112234', 'Tak', 'Aspirant', 'K9 Unit', NULL , 19),
  ('00112233446', 'Tak', 'Komendant', 'Undercover Operations', '66778899002', 20),
  ('11223344557', 'Tak', 'Inspektor', 'Patrol', NULL, 1),
  ('22334455668', 'Tak', 'Komisarz', 'Detective', '66778899002', 2),
  ('33445566779', 'Tak', 'Aspirant', 'Cybercrime', '66778899002', 3),
  ('44556677890', 'Tak', 'Komendant', 'SWAT', '66778899002', 4),
  ('55667788991', 'Tak', 'Inspektor', 'Narcotics', '66778899002', 5),
  ('66778899002', 'Tak', 'Komisarz', 'Intelligence', NULL , 6),
  ('77889900113', 'Tak', 'Aspirant', 'Traffic', '22334455669', 7),
  ('88990011224', 'Tak', 'Komendant', 'Special Investigations', '22334455669', 8),
  ('99001112235', 'Tak', 'Inspektor', 'Criminal Profiling', '22334455669', 9),
  ('00112233434', 'Tak', 'Komisarz', 'Forensics', '22334455669', 10),
  ('11223344558', 'Tak', 'Aspirant', 'Counter-Terrorism', '22334455669', 11),
  ('22334455669', 'Tak', 'Komendant', 'Missing Persons',NULL, 12),
  ('33445566780', 'Tak', 'Inspektor', 'White Collar Crime', '99001112236', 13),
  ('44556677891', 'Tak', 'Komisarz', 'Homicide', '99001112236', 14),
  ('55667788992', 'Tak', 'Aspirant', 'Drug Enforcement', '99001112236', 15),
  ('66778899003', 'Tak', 'Komendant', 'Gang Unit', '99001112236', 16),
  ('77889900114', 'Tak', 'Inspektor', 'Emergency Response', '99001112236', 17),
  ('88990011225', 'Tak', 'Aspirant', 'Cybersecurity', '99001112236', 18),
  ('99001112236', 'Tak', 'Komisarz', 'K9 Unit', NULL, 19),
  ('00112233447', 'Tak', 'Komendant', 'Undercover Operations', '99001112236', 20);

  ----------------------- KONIEC UZUPE£NIJ POLICJANTÓW -----------------------

-----------------------------  UZUPE£NIJ ŒWIADKÓW -------------------------------

INSERT INTO Ludzie (PESEL, Imie, Nazwisko, DataUrodzenia, MiejsceUrodzenia, Plec, Narodowosc)
VALUES
    ('11001122345', 'Sophie', 'Miller', '1998-04-15', 'Warszawa', 'K', 'German'),
    ('22112233456', 'Mason', 'Brown', '1987-10-28', 'Krakow', 'M', 'Canadian'),
    ('33223344567', 'Aria', 'Wilson', '1995-06-03', 'Wroclaw', 'K', 'Australian'),
    ('44334455678', 'Oliver', 'Smith', '1982-12-17', 'Gdansk', 'M', 'British'),
    ('55445566789', 'Lily', 'Taylor', '1991-08-05', 'Poznan', 'K', 'Chinese'),
    ('66556677890', 'Ethan', 'Martinez', '1983-02-27', 'Katowice', 'M', 'Mexican'),
    ('77667788901', 'Grace', 'Johnson', '1997-11-10', 'Bydgoszcz', 'K', 'American'),
    ('88778899012', 'Carter', 'Garcia', '1984-07-23', 'Lodz', 'M', 'Japanese'),
    ('99889900123', 'Zoe', 'Jones', '1992-03-06', 'Szczecin', 'K', 'Italian'),
    ('00990011234', 'Jack', 'Anderson', '1989-09-20', 'Lublin', 'M', 'Polish'),
    ('11001122356', 'Scarlett', 'Williams', '1996-05-02', 'Warszawa', 'K', 'Russian'),
    ('22112233467', 'Henry', 'Smith', '1981-11-15', 'Warszawa', 'M', 'Spanish'),
    ('33223344578', 'Ella', 'Taylor', '1990-07-29', 'Gdansk', 'K', 'Chinese'),
    ('44334455689', 'Lucas', 'Martinez', '1983-01-13', 'Warszawa', 'M', 'Mexican'),
    ('55445566790', 'Chloe', 'Johnson', '1998-09-26', 'Czestochowa', 'K', 'American'),
    ('66556677801', 'Owen', 'Garcia', '1986-04-09', 'Sosnowiec', 'M', 'Japanese'),
    ('77667788912', 'Avery', 'Jones', '1993-10-23', 'Radom', 'K', 'Italian'),
    ('88778899023', 'Leo', 'Anderson', '1980-06-05', 'Warszawa', 'M', 'Polish'),
    ('99889900134', 'Mila', 'Williams', '1997-01-18', 'Gdynia', 'K', 'Russian'),
    ('00990011245', 'Sebastian', 'Smith', '1982-07-02', 'Krakow', 'M', 'Spanish');


	INSERT INTO Swiadkowie (PESEL, KodPocztowy, Miejscowosc, NrTelefonu)
VALUES
    ('11001122345', '12-345', 'Warszawa', '123-456-789'),
    ('22112233456', '45-678', 'Krakow', '234-567-890'),
    ('33223344567', '98-765', 'Gdansk', '345-678-901'),
    ('44334455678', '23-456', 'Poznan', '456-789-012'),
    ('55445566789', '56-789', 'Wroclaw', '567-890-123'),
    ('66556677890', '34-567', 'Lodz', '678-901-234'),
    ('77667788901', '67-890', 'Szczecin', '789-012-345'),
    ('88778899012', '45-678', 'Katowice', '890-123-456'),
    ('99889900123', '89-012', 'Bydgoszcz', '901-234-567'),
    ('00990011234', '56-789', 'Gdynia', '012-345-678'),
    ('11001122356', '12-345', 'Olsztyn', '112-233-445'),
    ('22112233467', '78-901', 'Rzeszow', '223-344-556'),
    ('33223344578', '23-456', 'Torun', '334-455-667'),
    ('44334455689', '45-678', 'Kielce', '445-566-778'),
    ('55445566790', '67-890', 'Opole', '556-677-889'),
    ('66556677801', '34-567', 'Zielona Gora', '667-788-990'),
    ('77667788912', '56-789', 'Czestochowa', '778-899-001'),
    ('88778899023', '12-345', 'Sopot', '889-900-112'),
    ('99889900134', '78-901', 'Elblag', '990-011-122'),
    ('00990011245', '23-456', 'Bialystok', '001-122-334'),
	('00112233447', '75-345', 'Gdansk', '555-555-555');

	------------------------- KONIEC  UZUPE£NIJ ŒWIADKÓW -------------------------------

		-------------------------UZUPE£NIJ OFIARY  -------------------------------
INSERT INTO Ludzie (PESEL, Imie, Nazwisko, DataUrodzenia, MiejsceUrodzenia, Plec, Narodowosc)
VALUES
    ('11001122357', 'David', 'Smith', '1980-09-14', 'Warszawa', 'M', 'Canadian'),
    ('22112233468', 'Sophie', 'Brown', '1999-03-27', 'Krakow', 'K', 'Spanish'),
    ('33223344579', 'Daniel', 'Taylor', '1987-11-10', 'Wroclaw', 'M', 'Italian'),
    ('44334455690', 'Ella', 'Martinez', '1994-06-23', 'Gdansk', 'K', 'Russian'),
    ('55445566701', 'Ethan', 'Johnson', '1982-02-05', 'Poznan', 'M', 'Mexican'),
    ('66556677812', 'Grace', 'Garcia', '1991-08-18', 'Katowice', 'K', 'Polish'),
    ('77667788923', 'Liam', 'Jones', '1989-04-01', 'Lodz', 'M', 'Australian'),
    ('88778899034', 'Ava', 'Williams', '1996-12-14', 'Szczecin', 'K', 'German'),
    ('99889900145', 'Oliver', 'Smith', '1984-06-27', 'Sosnowiec', 'M', 'French'),
    ('00990011256', 'Zoe', 'Taylor', '1993-01-10', 'Bydgoszcz', 'K', 'British'),
    ('11001122367', 'Mila', 'Martinez', '1981-07-24', 'Warszawa', 'K', 'Chinese'),
    ('22112233478', 'Henry', 'Garcia', '1990-03-08', 'Krakow', 'M', 'Japanese'),
    ('33223344589', 'Lily', 'Johnson', '1988-09-21', 'Gdansk', 'K', 'Mexican'),
    ('44334455600', 'Owen', 'Brown', '1995-04-03', 'Sosnowiec', 'M', 'Polish'),
    ('55445566711', 'Chloe', 'Williams', '1983-10-16', 'Bydgoszcz', 'K', 'Brazilian'),
    ('66556677822', 'Sebastian', 'Taylor', '1992-06-29', 'Katowice', 'M', 'Russian'),
    ('77667788933', 'Scarlett', 'Jones', '1980-01-12', 'Szczecin', 'K', 'Italian'),
    ('88778899044', 'Leo', 'Martinez', '1997-09-25', 'Poznan', 'M', 'Canadian'),
    ('99889900155', 'Aria', 'Smith', '1985-05-08', 'Warszawa', 'K', 'Australian'),
    ('00990011266', 'Noah', 'Brown', '1994-11-21', 'Krakow', 'M', 'German');


	INSERT INTO Ofiary (Zywa, PESEL)
VALUES
    ('Tak', '11001122357'),
    ('Nie', '22112233468'),
    ('Tak', '33223344579'),
    ('Nie', '44334455690'),
    ('Tak', '55445566701'),
    ('Nie', '66556677812'),
    ('Tak', '77667788923'),
    ('Nie', '88778899034'),
    ('Tak', '99889900145'),
    ('Nie', '00990011256'),
    ('Tak', '11001122367'),
    ('Nie', '22112233478'),
    ('Tak', '33223344589'),
    ('Nie', '44334455600'),
    ('Tak', '55445566711'),
    ('Nie', '66556677822'),
    ('Tak', '77667788933'),
    ('Nie', '88778899044'),
    ('Tak', '99889900155'),
    ('Nie', '00990011266'),
	('Tak', '12345678901'),
	('Nie', '23456789012');
-----------------------KONEIC UZUPE£NIJ OFIARY------------------------------

-----------------------UZUPE£NIJ RODZAJ PRZESTÊPSTWA----------------------------

INSERT INTO Rodzaj_przestepstwa (Artykul)
VALUES
    ('§123'),
    ('§456'),
    ('§789'),
    ('§101'),
    ('§202'),
    ('§303'),
    ('§404'),
    ('§505'),
    ('§606'),
    ('§707'),
    ('§808'),
    ('§909'),
    ('§111'),
    ('§222'),
    ('§333'),
    ('§444'),
    ('§555'),
    ('§666'),
    ('§777'),
    ('§888');

--------------------- KONIEC UZUPE£NIJ RODZAJ PRZESTÊPSTWA--------------------------------

------------------------- UZUPE£NIJ PRZESTÊPSTWA --------------------------------------------
INSERT INTO Przestepstwa (Opis, DataPopelnienia, Miejscowosc, Artykul)
VALUES
    ('Theft of valuable items', '2023-01-05', 'Warsaw', '§123'),
    ('Assault on a public servant', '2023-02-10', 'Krakow', '§456'),
    ('Breaking and entering', '2023-03-15', 'Wroclaw', '§789'),
    ('Fraudulent activities', '2023-04-20', 'Gdansk', '§101'),
    ('Vandalism of public property', '2023-05-25', 'Poznan', '§202'),
    ('Kidnapping', '2023-06-30', 'Katowice', '§303'),
    ('Robbery at a local store', '2023-07-05', 'Lodz', '§404'),
    ('Drug trafficking', '2023-08-10', 'Szczecin', '§505'),
    ('Public disturbance', '2023-09-15', 'Bydgoszcz', '§606'),
    ('Illegal firearm possession', '2023-10-20', 'Lublin', '§707'),
    ('Cybercrime', '2023-11-25', 'Bialystok', '§808'),
    ('Homicide', '2023-12-30', 'Gdynia', '§909'),
    ('Assault and battery', '2024-01-05', 'Czestochowa', '§111'),
    ('Arson', '2024-02-10', 'Sosnowiec', '§222'),
    ('Car theft', '2024-03-15', 'Radom', '§333'),
    ('Bribery of public officials', '2024-04-20', 'Kielce', '§444'),
    ('Human trafficking', '2024-05-25', 'Kielce', '§555'),
    ('Embezzlement', '2024-06-30', 'Lodz', '§666'),
    ('Environmental pollution', '2024-07-05', 'Lodz', '§777'),
    ('Extortion', '2024-08-10', 'Kielce', '§888');


---------------- KONIEC UZUPE£NIJ PRZESTÊPSTWA ------------------------------------------

----------------- UZUPE£NIJ ZG£OSZENIA ------------------------------------------------

INSERT INTO Zgloszenia (DataZgloszenia, SledztwoWToku, Opis, IdOddzialu, IdPrzestepstwa)
VALUES
    ('2023-01-01', 'Tak', 'Report of theft', 1, 1),
    ('2023-02-02','Tak', 'Assault reported', 1, 2),
    ('2023-03-03','Tak', 'Breaking and entering', 3, 3),
    ('2023-04-04','Tak', 'Fraudulent activities ', 4, 4),
    ('2023-05-05','Tak', 'Vandalism reported in ', 5, 5),
    ('2023-06-06','Tak', 'Kidnapping', 6, 6),
    ('2023-07-07','Tak', 'Robbery at a store', 7, 7),
    ('2023-08-08','Tak', 'Drug trafficking', 8, 8),
    ('2023-09-09','Tak', 'Public disturbance', 9, 9),
    ('2023-10-10','Tak', 'Illegal firearm possession ', 10, 10),
    ('2023-11-11','Tak', 'Cybercrime reported ', 11, 11),
    ('2023-12-12','Tak', 'Homicide in', 5, 12),
    ('2024-01-13','Tak', 'Assault and battery', 13, 13),
    ('2024-02-14','Tak', 'Arson reported', 14, 14),
    ('2024-03-15','Tak', 'Car theft', 18, 15),
    ('2024-04-16','Tak', 'Bribery of public officials', 16, 16),
    ('2024-05-17','Tak', 'Human trafficking', 17, 17),
    ('2024-06-18','Tak', 'Embezzlement reported', 19, 18),
    ('2024-07-19','Tak', 'Environmental pollution', 19, 19),
    ('2024-08-20','Tak', 'Extortion reported in', 20, 20);

----------- KONIEC UZUPE£NIJ ZG£OSZENIA -------------------------------

------------ UZUPE£NIJ ŒWIADKOWIE PRZESTÊPSTWA ----------------------------

INSERT INTO Swiadkowie_przestepstwa (PESEL, IdPrzestepstwa, Przesluchany)
VALUES
    ('11001122345', 1, 'Tak'),
    ('22112233456', 1, 'Nie'),
    ('33223344567', 1, 'Tak'),
    ('44334455678', 1, 'Tak'),
    ('55445566789', 5, 'Tak'),
    ('66556677890', 6, 'Tak'),
    ('77667788901', 7, 'Tak'),
    ('88778899012', 8, 'Nie'),
    ('99889900123', 9,  'Tak'),
    ('00990011234', 10, 'Tak'),
    ('11001122356', 11, 'Tak'),
    ('22112233467', 12, 'Tak'),
    ('33223344578', 13, 'Tak'),
    ('44334455689', 14, 'Tak'),
    ('55445566790', 15, 'Tak'),
    ('66556677801', 16, 'Nie'),
    ('77667788912', 17, 'Tak'),
    ('88778899023', 18, 'Nie'),
    ('99889900134', 20, 'Tak');

------------  KONIEC UZUPE£NIJ ŒWIADKOWIE PRZESTÊPSTWA ----------------------------

------------ UZUPE£NIJ PRZESTÊPCY ----------------------------
INSERT INTO Ludzie (PESEL, Imie, Nazwisko, DataUrodzenia, MiejsceUrodzenia, Plec, Narodowosc)
VALUES
    ('11223344501', 'Sophie', 'Williams', '1990-02-10', 'Warszawa', 'K', 'Australian'),
    ('22334455602', 'Mason', 'Brown', '1985-11-24', 'Krakow', 'M', 'American'),
    ('33445566703', 'Aria', 'Taylor', '1993-07-08', 'Wroclaw', 'K', 'Italian'),
    ('44556677804', 'Oliver', 'Smith', '1980-01-22', 'Gdansk', 'M', 'Polish'),
    ('55667788905', 'Lily', 'Martinez', '1997-08-05', 'Poznan', 'K', 'Japanese'),
    ('66778899006', 'Ethan', 'Johnson', '1986-03-19', 'Katowice', 'M', 'Mexican'),
    ('77889900107', 'Grace', 'Garcia', '1994-09-01', 'Lodz', 'K', 'French'),
    ('88990011208', 'Carter', 'Jones', '1981-04-15', 'Szczecin', 'M', 'German'),
    ('99001112209', 'Zoe', 'Anderson', '1990-10-29', 'Bydgoszcz', 'K', 'Russian'),
    ('00112233410', 'Jack', 'Williams', '1987-06-12', 'Lublin', 'M', 'Spanish'),
    ('11223344511', 'Scarlett', 'Brown', '1995-01-25', 'Gdansk', 'K', 'Chinese'),
    ('22334455612', 'Henry', 'Taylor', '1982-07-10', 'Gdansk', 'M', 'Brazilian'),
    ('33445566713', 'Ella', 'Martinez', '1991-02-23', 'Gdansk', 'K', 'Canadian'),
    ('44556677814', 'Lucas', 'Johnson', '1988-08-06', 'Warszawa', 'M', 'Indian'),
    ('55667788915', 'Chloe', 'Garcia', '1996-03-21', 'Czestochowa', 'K', 'Japanese'),
    ('66778899016', 'Owen', 'Jones', '1984-09-04', 'Sosnowiec', 'M', 'Mexican'),
    ('77889900117', 'Avery', 'Anderson', '1993-02-17', 'Radom', 'K', 'Italian'),
    ('88990011218', 'Leo', 'Williams', '1980-08-01', 'Warszawa', 'M', 'Polish'),
    ('99001112219', 'Mila', 'Brown', '1997-01-14', 'Gdynia', 'K', 'Russian'),
    ('00112233420', 'Sebastian', 'Smith', '1982-06-29', 'Krakow', 'M', 'Spanish');


INSERT INTO Przestepcy (CechyCharakterystyczne, PESEL)
VALUES
    ('Tattoo on the left arm', '11223344501'),
    ('Scar on the right cheek', '22334455602'),
    ('Missing finger on the left hand', '33445566703'),
    ('Piercing on the nose', '44556677804'),
    ('Burn mark on the back', '55667788905'),
    ('Distinctive birthmark on the neck', '66778899006'),
    ('Cross tattoo on the chest', '77889900107'),
    ('Large mole on the forehead', '88990011208'),
    ('Multiple ear piercings', '99001112209'),
    ('Scars on both wrists', '00112233410'),
    ('Dragon tattoo on the back', '11223344511'),
    ('Facial scars', '22334455612'),
    ('Fingerprints on both hands', '33445566713'),
    ('Tattooed sleeves on both arms', '44556677814'),
    ('Missing front tooth', '55667788915'),
    ('Green eyes with a unique pattern', '66778899016'),
    ('Large birthmark on the chest', '77889900117'),
    ('Distinctive walk due to a limp', '88990011218'),
    ('Unique voice pattern', '99001112219'),
    ('Tattoo of a snake on the leg', '00112233420');

	------------ KONIEC UZUPE£NIJ PRZESTÊPCY  ----------------------------

	
	------------ UZUPE£NIJ LISTA OFIAR PRZESTÊPSTWA  ----------------------------

	INSERT INTO Lista_ofiar_przestepstwa (PESEL, IdPrzestepstwa, WnioslaOskarzenia)
VALUES
    ('11001122357', 1, 'Tak'),
    ('22112233468', 2, 'Nie'),
    ('33223344579', 3, 'Tak'),
    ('44334455690', 4, 'Nie'),
    ('55445566701', 5, 'Tak'),
    ('66556677812', 6, 'Nie'),
    ('77667788923', 7, 'Tak'),
    ('88778899034', 8, 'Nie'),
    ('99889900145', 9, 'Tak'),
    ('00990011256', 10,'Nie' ),
    ('11001122367', 11, 'Tak'),
    ('22112233478', 12, 'Nie'),
    ('33223344589', 13, 'Tak'),
    ('44334455600', 14, 'Nie'),
    ('55445566711', 15, 'Tak'),
    ('66556677822', 16, 'Nie'),
    ('77667788933', 17, 'Tak'),
    ('88778899044', 18, 'Nie'),
    ('99889900155', 19, 'Tak'),
    ('00990011266', 20, 'Nie'),
	('12345678901', 13, 'Tak'),
	('23456789012', 13, 'Tak');

------------ KONIEC UZUPE£NIJ LISTA OFIAR PRZESTÊPSTWA  ----------------------------

------------ UZUPE£NIJ LISTA PRZESTÊPSTW PRZESTÊPCY  ----------------------------

	INSERT INTO Lista_przestepstw_przestepcy (PESEL, IdPrzestepstwa, PriorytetScigania, PrzestepcaUkarany)
VALUES
    ('11223344501', 1, 5, 'Tak'),
	('11223344501', 2, 3, 'Nie'),
    ('22334455602', 2, 3, 'Nie'),
    ('33445566703', 3, 8, 'Tak'),
    ('44556677804', 4, 2, 'Nie'),
    ('55667788905', 5, 7, 'Tak'),
    ('66778899006', 6, 4, 'Nie'),
    ('77889900107', 7, 9, 'Tak'),
    ('88990011208', 8, 1, 'Nie'),
    ('99001112209', 9, 6, 'Tak'),
    ('00112233410', 10, 10, 'Nie'),
    ('11223344511', 11, 5, 'Tak'),
    ('22334455612', 12, 3, 'Nie'),
    ('33445566713', 13, 8, 'Tak'),
    ('44556677814', 14, 2, 'Nie'),
    ('55667788915', 15, 7, 'Tak'),
    ('66778899016', 16, 4, 'Nie'),
    ('77889900117', 17, 9, 'Tak'),
    ('88990011218', 18, 1, 'Nie'),
    ('99001112219', 19, 6, 'Tak'),
    ('00112233420', 20, 10, 'Nie');
	
------------ KONIEC UZUPE£NIJ LISTA PRZESTÊPSTW PRZESTÊPCY  ----------------------------
