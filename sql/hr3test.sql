select NUM_CL as ������, SUMMA as �����, DATA_S as ����_�, DATA_PO as ����_��,
com as ��������,Round (com/summa*100*365 /(to_date(data_po,'dd/mm/yyyy') - to_date(data_s,'dd/mm/yyyy')),2) as �����_�_���������_��_���
from dep
order by  �����_�_���������_��_���