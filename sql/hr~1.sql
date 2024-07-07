SELECT orders.order_id, 
       orders.order_date, 
       suppliers.supplier_name
  FROM suppliers
 RIGHT OUTER JOIN orders
    ON suppliers.supplier_id = orders.supplier_id; 