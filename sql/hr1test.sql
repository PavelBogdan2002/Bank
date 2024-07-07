select k.kalendar_data as Дата, i.DOG as номер_счета, i.data_s as da, i.symma, decode(data_po, null ,to_char(sysdate), data_po,data_po) as data_po
from kalendar k, intervals i
--where  k.kalendar_data between decode(data_s, null, '0') and nvl(data_po, to_char(sysdate))
where k.kalendar_data between data_s and decode(data_po, null ,to_char(sysdate), data_po,data_po)
ORDER BY  i.DOG,  k.kalendar_data;