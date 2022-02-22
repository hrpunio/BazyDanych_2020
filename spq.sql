-- Proste polecenia SELECT
-- wypisze wiersze dla price > 99
select * from PART where  price > 99;

-- wypisze wiersze dla pname = 'łańcuch'
select * from PART where  pname = 'łańcuch';

-- wypisze wiersze dla pname równych tryb i sztyca
select * from PART where  pname in ('tryb', 'sztyca');

-- wypisze wiersze z pname zaczynające się od felga
select * from PART where  pname like 'felga%';

-- wypisz wszystkie części których nazwy nie zaczynają się od felga
select * from PART where  pname NOT LIKE 'felga%';

-- jak wyżej ale tylko te których cena jest mniejsza od 99
select * from PART where  pname NOT LIKE 'felga%' and PRICE < 99;

-- wypisz wszystkie części, których cena <= 50 LUB >= od 100
select * from PART where  PRICE <= 50 OR PRICE >= 99;

-- JOIN
-- wypisz id dostawcy dla 'sztyca'
select sells.sno from part 
 INNER JOIN sells ON part.pno=sells.pno 
 where part.pname = 'sztyca';

--
-- wypisz id oraz nazwę dostawcy dla 'sztyca' 
select sells.sno, supplier.sname  from part 
  INNER JOIN sells ON part.pno=sells.pno 
  INNER JOIN supplier ON sells.sno=supplier.sno  
  where part.pname = 'sztyca';

-- ALIASY
-- wypisz id oraz nazwę dostawcy dla 'sztyca' 
select s.sno supplier_id, sp.sname supplier_name  from part AS p
  INNER JOIN sells s ON p.pno=s.pno 
  INNER JOIN supplier sp ON s.sno=sp.sno  
  where p.pname = 'sztyca';

--
-- wypisz wszystkich dostawców z Gdańska: --  
select sp.sname Nazwa_dostawcy  from part AS p
  INNER JOIN sells s ON p.pno=s.pno 
  INNER JOIN supplier sp ON s.sno=sp.sno  
  where sp.city = 'Gdańsk'; 

-- GROUP BY/HAVING
-- Wypisz wszystkich dostawców i liczbę części:
SELECT S.SNO, S.SNAME, COUNT(SE.PNO) 
   FROM SUPPLIER S
   INNER JOIN SELLS SE ON S.SNO = SE.SNO                
   GROUP BY S.SNO; 
 
--
-- Wypisz dostawców, którzy dostarczają 0 lub 1 część: --
-- Having pozwala na testowanie wartości zagregowanych --
SELECT S.SNO, S.SNAME, COUNT(SE.PNO)
   FROM SUPPLIER S
   INNER JOIN SELLS SE ON S.SNO = SE.SNO    
   GROUP BY S.SNO
   HAVING COUNT(SE.PNO) < 2 -- wyrażenie typu prawda/fałasz 
   -- musi być argumentem GROUP lub być argumentem funkcji agregującej 

