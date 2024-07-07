select k.kalendar_data as Дата, i.DOG as номер_счета,  i.symma as остаток
from kalendar k, intervals i
where k.kalendar_data between data_s and nvl(data_po,to_char(sysdate))
ORDER BY  i.DOG,  k.kalendar_data;