select k.kalendar_data as ����, i.DOG as �����_�����,  i.symma as �������
from kalendar k, intervals i
where k.kalendar_data between data_s and nvl(data_po,to_char(sysdate))
ORDER BY  i.DOG,  k.kalendar_data;