select NUM_CL as клиент, SUMMA as сумма, DATA_S as Дата_с, DATA_PO as Дата_по,
com as Комиссия,Round (com/summa*100*365 /(to_date(data_po,'dd/mm/yyyy') - to_date(data_s,'dd/mm/yyyy')),2) as доход_в_процентах_за_год
from dep
order by  доход_в_процентах_за_год