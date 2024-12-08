Select intervals.DOG, kalendar.kalendar_data, intervals.symma

from kalendar
LEFT OUTER JOIN intervals
ON intervals.data_s=kalendar.kalendar_data
--where  kalendar.kalendar_data between intervals.data_s and intervals.data_po
ORDER BY  intervals.DOG asc
