create database Fakultet1
create table Studenti(
ime nvarchar(30),
prezime nvarchar(30),
datRod date,
brIndeksa int primary key;

insert into Studenti
	values('Ivana', 'Mariæ', '1998-05-12', 202301);
insert into Studenti
	values('Ana', 'Dropul', '1994-03-25', 202308);
insert into Studenti
	values('Marko', 'Markov', '1991-10-11', 202309);
alter table Studenti
add smjerStudija nvarchar(50);
select * from Studenti
update Studenti
set smjerStudija = 'Raèunarstvo'
where brIndeksa = 202301;

update Studenti
set smjerStudija = 'Elektrotehnika'
where brIndeksa = 202308;

update Studenti
set smjerStudija = 'Mehatronika'
where brIndeksa = 202309;

SELECT AVG(YEAR(datRod))
FROM Studenti
WHERE smjerStudija = 'Raèunarstvo';


---tražim ime i prezime i prezime svih studenata koji nisu na smjeru Raèunarstvo i roðeni su nakon 1990.g, sortirano po datumu roðenja silazno
select ime, prezime
from Studenti
where smjerStudija <> 'Raèunarstvo' and datRod > '1990-01-01'
order by datRod desc;

---raèunam koliko ima studenata po svakom smjeru studija
select smjerStudija, count(*)
from Studenti
group by smjerStudija;

---korištenje WHERE I HAVING. agregacije i filtriranje, izlistavam smjerove gdje ima više od dva studenta 
select smjerStudija, count(*) as brojStudenta
from Studenti
group by smjerStudija
having count (*) > 2;

----Prikaži smjerove studija i broj studenata roðenih nakon 1995. godine,
----ali prikaži samo one smjerove gdje ima više od 1 takav student.

select smjerStudija, count(*) as brojStudenata
from Studenti
where datRod > '1995-01-01'
group by smjerStudija
having count(*) > 1;

----Za svaki smjer studija prikaži:smjer; prosjeènu godinu roðenja studenata
----Prikaži samo one smjerove gdje je prosjeèna godina roðenja nakon 1995.
select smjerStudija
from Studenti
group by smjerStudija
having avg(year(datRod)) > 1995;

use Fakultet1
go

----Prikaži smjerStudija i ukupni broj studenata po smjeru, ali samo one smjerove gdje je prosjeèna godina roðenja izmeðu 1990. i 2000.
select smjerStudija, count (*) as brojStudenata
from Studenti
group by smjerStudija
having avg(year(datRod)) > 1990 and avg(year(datRod)) < 2000;

----koristim between da ukljuèim i 1990. i 2000. godinu
select smjerStudija, count(*) as brojStudenata
from Studenti
group by smjerStudija
having avg(year(datRod)) between 1990 and 2000;

--Za sve smjerove u kojima: su studenti roðeni nakon 1985. godine , a prosjeèna godina roðenja tih studenata je veæa od 1990 , prikaži: naziv smjera, broj studenata po tom smjeru, i prosjeènu godinu roðenja.
select smjerStudija, 
	count(*) as brStudenata, 
	avg(year(datRod)) as prosGodRod
from Studenti
where datRod > '1985-01-01'
group by smjerStudija 
having avg(year(datRod)) > 1990;

--Za svaki smjer studija, prikaži:naziv smjera, broj studenata na tom smjeru (kao brStudenata), prosjeènu godinu roðenja (kao prosGodRod), ali samo za one smjerove:gdje je prosjeèna godina roðenja izmeðu 1990 i 2000 (ekstremi ukljuèeni),i gdje ima više od 1 studenta.
select smjerStudija, 
	count(*) as brStudenata,
	avg(year(datRod)) as prosGod
from Studenti
group by smjerStudija
having avg(year(datRod)) between 1990 and 2000 and count (*) > 1;

--Prikaži smjerove studija koji imaju više od 2 studenta roðena nakon 1990. godine, i prikaži i prosjeènu godinu roðenja tih studenata po smjeru.
select smjerStudija, 
	avg(year(datRod)) as prosGodRod
from Studenti
where datRod > '1990-01-01'
group by smjerStudija
having count(*) > 2 and avg(year(datRod)) > 1990;

----unos studenata za više rezultata na upitima
INSERT INTO Studenti (brIndeksa, ime, prezime, datRod, smjerStudija)
VALUES 
(2023001, 'Ana', 'Mariæ', '1992-04-15', 'Raèunarstvo'),
(2023002, 'Ivan', 'Horvat', '1988-11-22', 'Ekonomija'),
(2023003, 'Lana', 'Kovaè', '1997-07-08', 'Informatika'),
(2023004, 'Marko', 'Barišiæ', '2000-03-30', 'Informatika'),
(2023005, 'Ema', 'Juriæ', '1995-12-01', 'Raèunarstvo');

----Za svaki smjer studija, prikaži najmlaðu godinu roðenja studenata (dakle, najveæi broj godine), ali samo za one smjerove gdje ima više od 2 studenta.
select smjerStudija, max(year(datRod)) as godRod
from Studenti
group by smjerStudija
having count(*) > 2;

----radim drugu tablicu kako bih mogla koristiti INNER JOIN
-CREATE TABLE Ocjene (
	idOcjene int IDENTITY(1,1) PRIMARY KEY,
	bIndeksa int,
	predmet nvarchar(50),
	ocjena int,
	godina_polaganja int,
FOREIGN KEY (bIndeksa) REFERENCES Studenti(brIndeksa);

INSERT INTO Ocjene (bIndeksa, predmet, ocjena, godina_polaganja) VALUES
	(2023001, 'Matematika', 5, 2023),
	(2023002, 'Informatika', 4, 2023),
	(2023003, 'SQL', 5, 2023),
	(2023004, 'Matematika', 3, 2023),
	(2023005, 'SQL', 2, 2023);


---krivo sam upisala ime kolone pa sad radim novu tablicu
ALTER TABLE Ocjene ADD brIndeksa int;
----kopiram podatke iz jedne kolone u drugu
UPDATE Ocjene SET brIndeksa = bIndeksa;
---brišem staru kolonu
ALTER TABLE Ocjene DROP COLUMN bIndeksa;
---ne mogu jer je to strani kljuè pa prvo moram maknit njega a prvo saznajem njegovo ime
SELECT name 
FROM sys.foreign_keys
WHERE parent_object_id = OBJECT_ID('Ocjene');
---brišem strani kljuè
ALTER TABLE Ocjene
DROP CONSTRAINT FK__Ocjene__bIndeksa__5CD6CB2B;
----brišem kolonu
ALTER TABLE Ocjene
DROP COLUMN bIndeksa;

select * from Ocjene
select * from Studenti

----Prikaži imena studenata i njihove ocjene za predmet 'SQL'.
select Studenti.ime, Ocjene.predmet, Ocjene.ocjena
from Studenti
inner join Ocjene on Studenti.brIndeksa = Ocjene.brIndeksa
where Ocjene.predmet = 'SQL';

use Fakultet1

--Prikaži imena studenata i njihove ocjene iz predmeta “SQL” koji su položili nakon 2020. godine.
select Studenti.ime, Ocjene.ocjena
from Studenti
inner join Ocjene on Studenti.brIndeksa = Ocjene.brIndeksa
where predmet = 'SQL' and godina_polaganja > 2020;

--prikaži ime studenta, predmet i ocjenu, ali samo ako je ocjena veæa od 3 i polagana u 2023.?
select Studenti.ime, Ocjene.predmet, Ocjene.ocjena
from Studenti
inner join Ocjene on Studenti.brIndeksa = Ocjene.brIndeksa
where ocjena > 3 and godina_polaganja = 2023;

--radim treæu tablicu kako bi ih sve tri mogla spajati 
CREATE TABLE Predmeti (
    idPredmeta INT PRIMARY KEY IDENTITY(1,1),
    naziv NVARCHAR(50) NOT NULL
);
----brišem kolonu predmet kako bi napravila idPredmeta u istoj, jer u novoj tablici imam naziv predmeta
ALTER TABLE Ocjene
DROP COLUMN predmet;

--dodajem novu kolonu u ocjene
ALTER TABLE Ocjene
ADD idPredmeta INT;
--uvodim ogranièenje tj stavljam strani kljuè na idPredmeta iz tablice ocjene koji se referencira na idPredmeta iz tablice Predmeti
--ALTER TABLE Ocjene
--ADD CONSTRAINT FK_Ocjene_Predmeti FOREIGN KEY (idPredmeta) REFERENCES Predmeti(idPredmeta);

---ubacujem podatke u predmete
INSERT INTO Predmeti (naziv) VALUES ('SQL'), ('Matematika'), ('Programiranje');
--ubacujem podatke u ocjene 
INSERT INTO Ocjene (brIndeksa, ocjena, godina_polaganja, idPredmeta) 
VALUES (2023001, 5, 2023, 1);

	
	

select * from Ocjene
select * from Predmeti
---dodajem idPredmeta u veæ postojeæe stupce
update Ocjene set idPredmeta = 3
where brIndeksa = 2023001;

update Ocjene set idPredmeta = 2
where brIndeksa = 2023002;

update Ocjene set idPredmeta = 1
where brIndeksa = 2023003;

update Ocjene set idPredmeta = 1
where brIndeksa = 2023004;

update Ocjene set idPredmeta = 3
where brIndeksa = 2023005;

---dodajem još jednu kolonu u predmete
alter table Predmeti
add imeProf nvarchar(30);

---update tablicu predmeti
select * from Predmeti

update Predmeti set imeProf = 'Ana Horvat'
where idPredmeta = 1;
update Predmeti set imeProf = 'Marko Mariæ'
where idPredmeta = 2;
update Predmeti set imeProf = 'Ivana Kovaèeviæ'
where idPredmeta = 3;

select * from Predmeti

--Prikaži imena studenata, naziv predmeta i ocjenu samo onih studenata koji su polagali ispite iz predmeta èiji je nositelj "prof. Ana Horvat".
select Studenti.ime, Predmeti.naziv, Ocjene.ocjena
from Studenti
inner join Ocjene on Studenti.brIndeksa = Ocjene.brIndeksa
inner join Predmeti on Predmeti.idPredmeta = Ocjene.idPredmeta
where imeProf = 'Ana Horvat';
select * from Studenti
select * from Ocjene
select * from Predmeti

--Prikaži ime studenta, naziv predmeta i ocjenu za one studente koji su:polagali predmet 'SQL', kod profesora Ana Horvat, i dobili ocjenu veæu od 3.
select Studenti.ime, Predmeti.naziv, Ocjene.ocjena
from Studenti
inner join Ocjene on Studenti.brIndeksa = Ocjene.brIndeksa
inner join Predmeti on Predmeti.idPredmeta = Ocjene.idPredmeta
where imeProf = 'Ana Horvat' and ocjena > 3;
