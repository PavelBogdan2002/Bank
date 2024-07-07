select k.kalendar_data, i.DOG, i.data_s, i.symma,i.data_po
from kalendar k, intervals i
--where  k.kalendar_data > data_s and  symma > (to_char(kalendar_data,'dd.mm.yyyy') - to_char(kalendar_data,'dd.mm.yyyy'))
--ORDER BY  i.DOG,  k.kalendar_data 

select k.KALENDAR_DATA-i.data_s
from kalendar k, intervals i
--where KALENDAR_DATA> i.data_s