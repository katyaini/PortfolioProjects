# PortfolioProjects
SQL QUERIES FOR DATA ANALYSIS (PERFORMED ON MySQL Workbench)

1.Show all customer records
SELECT * FROM customers;

2.Show total number of customers
SELECT count(*) FROM customers;

3.Show transactions for Delhi NCR (market code for Delhi NCR is Mark004( as specified in the Data Table)
SELECT * FROM transactions where market_code='Mark004';

4.Show DISTINCT product codes that were sold in Delhi NCR
SELECT distinct product_code FROM transactions where market_code='Mark004';

5.Show transactions where currency is US dollars
SELECT * from transactions where currency="USD"

6.Show transactions in 2020 - transaction and date tables are joined on date
SELECT transactions., date. FROM transactions JOIN date ON transactions.order_date=date.date where date.year=2020;

7.To Show total revenue in year 2020
SELECT SUM(transactions.sales_amount) FROM transactions INNER JOIN date ON transactions.order_date=date.date where date.year=2020 and transactions.currency="INR\r" or transactions.currency="USD\r";

8.To Show total revenue in January 2020
SELECT SUM(transactions.sales_amount) FROM transactions INNER JOIN date ON transactions.order_date=date.date where date.year=2020 and and date.month_name="January" and (transactions.currency="INR\r" or transactions.currency="USD\r");

9.To Show total revenue in year 2020 in Delhi NCR
SELECT SUM(transactions.sales_amount) FROM transactions INNER JOIN date ON transactions.order_date=date.date where date.year=2020 and transactions.market_code="Mark004";

DATA ANALYSIS USING POWER BI

FORMULAS USED TO TRANSFORM DATA

1.Formula to add sales amount value in INR into a new column created called Normalized_Sales
= Table.AddColumn(#"REMOVE 0 /-1 FROM Sales_amount", "Normalized_Sales", each if [currency] = "USD" or [currency]="USD#(cr)"then [sales_amount]*75 else [sales_amount])
