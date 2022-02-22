-- dla opóźnień na lotnisku `odlotowym' (depdel)
-- wypisz sumę opóźnień, średnie opóźnienie, liczbę lotów oraz kod stanu
--

select state, avg(depdel), sum(depdel), count(depdel) from flight
inner join ori on oriid=aid
group by STATE;

-- jak wyżej ale tylko dla stanów gdzie liczba lotów 10000 i więcej
--

select state, avg(depdel), sum(depdel), count(depdel) from flight
inner join ori on oriid=aid
group by STATE
having count(depdel) > 9999

select dayofweek, avg(arrdel), sum(arrdel), count(arrdel) from flight
inner join date on dateid=did
group by dayofweek;

-- Użycie aliasów
.head on
select dayofweek Day, avg(arrdel) Srednia, sum(arrdel) Razem, count(arrdel) Loty from flight
inner join date on dateid=did
group by dayofweek;

