Select intervals.DOG,intervals.symma, kalendar.kalendar_data
from kalendar
FULL OUTER JOIN intervals
ON intervals.data_s=kalendar.kalendar_data
where intervals.symma in(select symma from intervals where intervals.data_po is not null)
ORDER BY  intervals.DOG asc