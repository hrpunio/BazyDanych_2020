-- Suma sprzedanych arytkułów wg sklepów

select kierownik, count(iid) from tran
inner join shop on tran.sid=shop.sid
group by shop.sid;
