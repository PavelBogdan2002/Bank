SELECT numdog, TO_CHAR(DATE_PLAT,'yyyy')���,TO_CHAR(DATE_PLAT,'mm')�����, summ,summ/numm
from credits,
(select sum(summa) summ, count(summa) numm
from credits
where numdog='1') 
where numdog='1' 
;

select summ/numm  from
(select sum(summa) summ, count(summa) numm
from credits
where numdog='1') 


select sum(summa) summ
from credits
where numdog='1'