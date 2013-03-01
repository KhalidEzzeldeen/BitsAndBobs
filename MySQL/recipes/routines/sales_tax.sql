# sales_tax.sql

# Given sale amount and state abbreviation, compute sales tax by
# looking up appropriate tax rate in sales_tax_rate table.

DROP FUNCTION IF EXISTS sales_tax;
delimiter $$
#@ _SALES_TAX_
CREATE FUNCTION sales_tax(state_param CHAR(2), amount_param DECIMAL(10,2))
RETURNS DECIMAL(10,2) READS SQL DATA
BEGIN
  DECLARE rate_var DECIMAL(3,2);
  DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET rate_var = 0;
  SELECT tax_rate INTO rate_var
    FROM sales_tax_rate WHERE state = state_param;
  RETURN amount_param * rate_var;
END;
#@ _SALES_TAX_
$$
delimiter ;
SELECT sales_tax('NY',100.00), sales_tax('VT',100.00);
# Tax for nonexistent state
SELECT sales_tax('ZZ',100.00);
