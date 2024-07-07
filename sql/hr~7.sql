select k.kalendar_data, i.DOG, i.data_s, i.symma * (to_char(k.kalendar_data,'yy') - to_char(data_s,'yy'))
from kalendar k, intervals i
where k.kalendar_data between nvl(data_po, to_char(sysdate))        --and k.kalendar_data  <> i.data_po
--(select k.kalendar_data from kalendar k, intervals i where k.kalendar_data <> i.data_s)

ORDER BY  i.DOG,  k.kalendar_data 