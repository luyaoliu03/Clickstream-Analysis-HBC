/*-------------------------------------------Customer & Product level----------------------------------------------*/

libname SDDB oracle user=dorisliu pass='hbc#1234' path=neworacle  schema=SDMRK;

/*1.Order info under various conditions*/

%LET FY17start = '29Jan2018:00:00:00'DT; /*To QA code*/
%LET FY17end = '3Feb2018:23:59:59'DT;
/*1.(1) by SaksFirst / Tier*/

/****GROUP BY****/

/* 12 THINGS TO CHECK */

PROC SQL;
CREATE TABLE Order_SaksFirst AS
	SELECT COUNT( DISTINCT(INDIVIDUAL_ID) ) AS CUSTOMERS,
		   COUNT( DISTINCT(ORDER_NUMBER) ) AS ORDERS,
		   SUM(CASE WHEN ORDER_LINE_STATUS IN ('D','R','X') THEN DEMAND_DOLLARS /*DEMAND in $ & unit*/
		   		 END) AS DEMAND_DOLLARS,
		   SUM(CASE WHEN ORDER_LINE_STATUS IN ('D','R','X') THEN DEMAND_UNITS
		   		 END) AS DEMAND_UNITS,
		   SUM(CASE WHEN ORDER_LINE_STATUS = 'R' THEN DEMAND_DOLLARS /*RETURN in $ & unit*/
			     END) AS RETURN_DOLLARS,
		   SUM(CASE WHEN ORDER_LINE_STATUS = 'R' THEN DEMAND_UNITS
			     END) AS RETURN_UNITS, 
		   SUM(CASE WHEN ORDER_LINE_STATUS = 'X' THEN DEMAND_DOLLARS /*CANCEL in $ & unit*/
			     END) AS CANCEL_DOLLARS,
		   SUM(CASE WHEN ORDER_LINE_STATUS = 'X' THEN DEMAND_UNITS
			     END) AS CANCEL_UNITS,
		   SUM(CASE WHEN ORDER_LINE_STATUS = 'D' THEN DEMAND_DOLLARS /*NET in $ & unit*/
			     END) AS NET_DOLLARS,
		   SUM(CASE WHEN ORDER_LINE_STATUS = 'D' THEN DEMAND_UNITS
			     END) AS NET_UNITS,
		   SUM(CASE WHEN ORDER_LINE_STATUS IN ('D', 'R') THEN DEMAND_DOLLARS /*GROSS in $ & unit*/
		   		 END) AS GROSS_DOLLARS,
		   SUM(CASE WHEN ORDER_LINE_STATUS IN ('D', 'R') THEN DEMAND_UNITS
		   		 END) AS GROSS_UNITS,
		   SAKS_FIRST_INDICATOR
	FROM Sddb.Orders
	WHERE ORDERDATE GE &FY17start AND ORDERDATE LE &FY17end
	GROUP BY SAKS_FIRST_INDICATOR;
QUIT;

/* Order_Line_Status: X - Cancel, R - Return, D - Deal */

/***Data Step***/
DATA ORDER_SAKSFIRST; 


/*By Saks First Tier*/

PROC SQL;
CREATE TABLE Order_SaksFirst_Tier AS
	SELECT COUNT( DISTINCT(A.INDIVIDUAL_ID) ) AS CUSTOMERS,
		   COUNT( DISTINCT(ORDER_NUMBER) ) AS ORDERS,
		   SUM(CASE WHEN ORDER_LINE_STATUS IN ('D','R','X') THEN DEMAND_DOLLARS /*DEMAND in $ & unit*/
		   		 END) AS DEMAND_DOLLARS,
		   SUM(CASE WHEN ORDER_LINE_STATUS IN ('D','R','X') THEN DEMAND_UNITS
		   		 END) AS DEMAND_UNITS,
		   SUM(CASE WHEN ORDER_LINE_STATUS = 'R' THEN DEMAND_DOLLARS /*RETURN in $ & unit*/
			     END) AS RETURN_DOLLARS,
		   SUM(CASE WHEN ORDER_LINE_STATUS = 'R' THEN DEMAND_UNITS
			     END) AS RETURN_UNITS, 
		   SUM(CASE WHEN ORDER_LINE_STATUS = 'X' THEN DEMAND_DOLLARS /*CANCEL in $ & unit*/
			     END) AS CANCEL_DOLLARS,
		   SUM(CASE WHEN ORDER_LINE_STATUS = 'X' THEN DEMAND_UNITS
			     END) AS CANCEL_UNITS,
		   SUM(CASE WHEN ORDER_LINE_STATUS = 'D' THEN DEMAND_DOLLARS /*NET in $ & unit*/
			     END) AS NET_DOLLARS,
		   SUM(CASE WHEN ORDER_LINE_STATUS = 'D' THEN DEMAND_UNITS
			     END) AS NET_UNITS,
		   SUM(CASE WHEN ORDER_LINE_STATUS IN ('D', 'R') THEN DEMAND_DOLLARS /*GROSS in $ & unit*/
		   		 END) AS GROSS_DOLLARS,
		   SUM(CASE WHEN ORDER_LINE_STATUS IN ('D', 'R') THEN DEMAND_UNITS
		   		 END) AS GROSS_UNITS,
		   SAKS_FIRST_TIER
	FROM Sddb.Orders A
	JOIN Sddb.Individual B
	ON A.INDIVIDUAL_ID = B.INDIVIDUAL_ID
	WHERE ORDERDATE GE &FY17start AND ORDERDATE LE &FY17end
	GROUP BY SAKS_FIRST_TIER;
QUIT;


/*1.(2) by Employees*/

PROC SQL;
CREATE TABLE Order_Employees AS
	SELECT COUNT( DISTINCT(INDIVIDUAL_ID) ) AS CUSTOMERS,
		   COUNT( DISTINCT(ORDER_NUMBER) ) AS ORDERS,
		   SUM(CASE WHEN ORDER_LINE_STATUS IN ('D','R','X') THEN DEMAND_DOLLARS /*DEMAND in $ & unit*/
		   		 END) AS DEMAND_DOLLARS,
		   SUM(CASE WHEN ORDER_LINE_STATUS IN ('D','R','X') THEN DEMAND_UNITS
		   		 END) AS DEMAND_UNITS,
		   SUM(CASE WHEN ORDER_LINE_STATUS = 'R' THEN DEMAND_DOLLARS /*RETURN in $ & unit*/
			     END) AS RETURN_DOLLARS,
		   SUM(CASE WHEN ORDER_LINE_STATUS = 'R' THEN DEMAND_UNITS
			     END) AS RETURN_UNITS, 
		   SUM(CASE WHEN ORDER_LINE_STATUS = 'X' THEN DEMAND_DOLLARS /*CANCEL in $ & unit*/
			     END) AS CANCEL_DOLLARS,
		   SUM(CASE WHEN ORDER_LINE_STATUS = 'X' THEN DEMAND_UNITS
			     END) AS CANCEL_UNITS,
		   SUM(CASE WHEN ORDER_LINE_STATUS = 'D' THEN DEMAND_DOLLARS /*NET in $ & unit*/
			     END) AS NET_DOLLARS,
		   SUM(CASE WHEN ORDER_LINE_STATUS = 'D' THEN DEMAND_UNITS
			     END) AS NET_UNITS,
		   SUM(CASE WHEN ORDER_LINE_STATUS IN ('D', 'R') THEN DEMAND_DOLLARS /*GROSS in $ & unit*/
		   		 END) AS GROSS_DOLLARS,
		   SUM(CASE WHEN ORDER_LINE_STATUS IN ('D', 'R') THEN DEMAND_UNITS
		   		 END) AS GROSS_UNITS,
		   EMPLOYEE_INDICATOR
	FROM Sddb.Orders
	WHERE ORDERDATE GE &FY17start AND ORDERDATE LE &FY17end
	GROUP BY EMPLOYEE_INDICATOR;
QUIT;

/*1.(3) For Women's Apparel*/
/*Group ID = ?
Look up in https://docs.google.com/document/d/1ZmA3n-4mZh80PsTgrye33pnGVWoQf_68zfKHGXlZZSA
*/

PROC SQL;
CREATE TABLE Order_WMapparel AS
	SELECT COUNT( DISTINCT(INDIVIDUAL_ID) ) AS CUSTOMERS,
		   COUNT( DISTINCT(ORDER_NUMBER) ) AS ORDERS,
		   SUM(CASE WHEN ORDER_LINE_STATUS IN ('D','R','X') THEN DEMAND_DOLLARS /*DEMAND in $ & unit*/
		   		 END) AS DEMAND_DOLLARS,
		   SUM(CASE WHEN ORDER_LINE_STATUS IN ('D','R','X') THEN DEMAND_UNITS
		   		 END) AS DEMAND_UNITS,
		   SUM(CASE WHEN ORDER_LINE_STATUS = 'R' THEN DEMAND_DOLLARS /*RETURN in $ & unit*/
			     END) AS RETURN_DOLLARS,
		   SUM(CASE WHEN ORDER_LINE_STATUS = 'R' THEN DEMAND_UNITS
			     END) AS RETURN_UNITS, 
		   SUM(CASE WHEN ORDER_LINE_STATUS = 'X' THEN DEMAND_DOLLARS /*CANCEL in $ & unit*/
			     END) AS CANCEL_DOLLARS,
		   SUM(CASE WHEN ORDER_LINE_STATUS = 'X' THEN DEMAND_UNITS
			     END) AS CANCEL_UNITS,
		   SUM(CASE WHEN ORDER_LINE_STATUS = 'D' THEN DEMAND_DOLLARS /*NET in $ & unit*/
			     END) AS NET_DOLLARS,
		   SUM(CASE WHEN ORDER_LINE_STATUS = 'D' THEN DEMAND_UNITS
			     END) AS NET_UNITS,
		   SUM(CASE WHEN ORDER_LINE_STATUS IN ('D', 'R') THEN DEMAND_DOLLARS /*GROSS in $ & unit*/
		   		 END) AS GROSS_DOLLARS,
		   SUM(CASE WHEN ORDER_LINE_STATUS IN ('D', 'R') THEN DEMAND_UNITS
		   		 END) AS GROSS_UNITS,
	FROM Sddb.Orders
	WHERE ORDERDATE GE &FY17start AND ORDERDATE LE &FY17end 
	AND GROUP_ID IN ('14','25');
QUIT;


/*2.Top 10 products by units for FY17 NOV*/
/*Product ID = PRODUCT_CODE*/ /*Product Name: BRAND_NAME + BM_DESC*/
/*But there're other order_line_status if we don't limit it to D,X,R*/

%LET FY17NOVstart = '20Nov2017:00:00:00'DT; /*To QA code*/
%LET FY17NOVend = '25Nov2017:23:59:59'DT;

PROC SQL OUTOBS = 10;
CREATE TABLE TopProduct_Nov AS
	SELECT PRODUCT_CODE, 
		   SUM(Demand_UNITS) AS Sum_Demand_Units
	FROM Sddb.Orders
	LEFT JOIN Sddb.Product 
	ON Orders.SKU = Product.SKU
	WHERE ORDERDATE GE &FY17NOVstart AND ORDERDATE LE &FY17NOVend
	GROUP BY 1
	ORDER BY 2 DESC;
QUIT;

/*To discover the Brand & Description
PROC SQL;
CREATE TABLE TopProductName_Nov AS
	SELECT B.PRODUCT_CODE,
		   B.BRAND_NAME,
		   B.BM_DESC,
		   SUM(DEMAND_UNITS) AS Sum_Demand_Units
	FROM Sddb.Orders A
	LEFT JOIN Sddb.Product B
	ON Order.SKU = Product.SKU
	WHERE ORDERDATE GE &FY17NOVstart AND ORDERDATE LE &FY17NOVend
	AND B.PRODUCT_CODE IN
		(SELECT PRODUCT_CODE
		FROM Work.TopProduct_Nov
); */

/*what about on the app*/
PROC SQL OUTOBS = 10;
CREATE TABLE TopProduct_Nov_app AS
	SELECT PRODUCT_CODE, 
		   SUM(Demand_UNITS) AS Sum_Demand_Units
	FROM Sddb.Orders
	LEFT JOIN Sddb.Product 
	ON Orders.SKU = Product.SKU
	WHERE ORDERDATE GE &FY17NOVstart AND ORDERDATE LE &FY17NOVend
	AND ORDER_TYPE IN ('and', 'iph')
	GROUP BY 1
	ORDER BY 2 DESC;
QUIT;

/**To check the ORDER_TYPE **/
/**and:android; iph:iphone iOS; TEL:Call Center; WEB, MOB: full + m site; ipd: tablet; STR: store**/
%LET FY19s = '03FEB2019:00:00:00'DT;
%LET FY19e = '20DEC2019:23:59:59'DT;

PROC SQL;
CREATE TABLE ORDER_TYPE AS
	SELECT DISTINCT(ORDER_TYPE)
	FROM Sddb.Orders
	WHERE ORDERDATE GE &FY19s AND ORDERDATE LE &FY19e;
QUIT;

/*3.Top 10 brands by revenue for FY17 NOV*/

PROC SQL OUTOBS = 10;
CREATE TABLE TopBrand_Nov AS
	SELECT BRAND_NAME, 
	SUM(Demand_DOLLARS) AS Sum_Demand_Dollars
	FROM Sddb.Orders
	LEFT JOIN Sddb.Product 
	ON Orders.SKU = Product.SKU
	WHERE ORDERDATE GE &FY17NOVstart AND ORDERDATE LE &FY17NOVend
	GROUP BY BRAND_NAME
	ORDER BY 2 DESC;
QUIT;

/*4.Top 10 intl countries shipped/ billed by orders for FY17 DEC*/

%LET FY17DECstart = '26Dec2017:00:00:00'DT; /*To QA code*/
%LET FY17DECend = '30Dec2017:23:59:59'DT;

PROC SQL OUTOBS = 10;
	CREATE TABLE TopIntlcountr_Dec AS
	SELECT COUNTRY, 
	COUNT(DISTINCT ORDER_NUMBER) AS SUM_ORDER_NUMBER
	FROM Sddb.Orders
	LEFT JOIN Sddb.Address 
	ON Orders.SHIP_TO_ADDRESS_ID = Address.ADDRESS_ID  /**transfer datatype since it's scientific number**/
	WHERE ORDERDATE GE &FY17DECstart AND ORDERDATE LE &FY17DECend
	GROUP BY COUNTRY
	ORDER BY 2;
QUIT;


/*pass-through*/ /*****why error*****/

PROC SQL OUTOBS = 10;
	CONNECT TO oracle AS myconn (user=dorisliu pass='hbc#1234' path=neworacle);
	CREATE TABLE TopIntlcountr_Dec
	SELECT * FROM connection to myconn
		(SELECT COUNTRY, 
		COUNT(DISTINCT ORDER_NUMBER) AS SUM_ORDER_NUMBER
		FROM SDMRK.Orders AS A
		LEFT JOIN SDMRK.Address AS B
		ON A.SHIP_TO_ADDRESS_ID = B.ADDRESS_ID  /**transfer datatype since it's scientific number**/
		WHERE ORDERDATE GE &FY17DECstart AND ORDERDATE LE &FY17DECend
		GROUP BY COUNTRY
		ORDER BY 2);
	DISCONNECT FROM myconn;
QUIT;


/*DataType*/

/*Should be in Data Step
PROC SQL OUTOBS = 10;
	CREATE TABLE TopIntlcountr_Dec AS
	SELECT COUNTRY, 
	COUNT(DISTINCT ORDER_NUMBER) AS SUM_ORDER_NUMBER
	FROM Sddb.Orders
	LEFT JOIN Sddb.Address 
	ON DASASTYPE=(Orders.SHIP_TO_ADDRESS_ID = NUMERIC(30) ) = 
	DASASTYPE=(Address.ADDRESS_ID = NUMERIC(30) )  
	WHERE ORDERDATE GE &FY17DECstart AND ORDERDATE LE &FY17DECend
	GROUP BY COUNTRY
	ORDER BY 2;
QUIT;

*/

/*5.Findings for those who shop both shoes and kids*/


PROC SQL;
CREATE TABLE Insights_0 AS
	SELECT COUNT(DISTINCT(ORDER_NUMBER)) AS sum_orders
	FROM Sddb.Orders  
	WHERE ORDERDATE GE &FY17DECstart AND ORDERDATE LE &FY17DECend 
	AND Orders.GROUP_ID IN ('35','36')
;
QUIT;

/*Shopping channel*/
PROC SQL;
CREATE TABLE Insights_1 AS
	SELECT 
	ORDER_TYPE,
	100 * (COUNT(DISTINCT(ORDER_NUMBER))/ (SELECT sum_orders FROM Insights_0) ) AS PERCENTAGE,
	SUM(DEMAND_DOLLARS)/ COUNT(DISTINCT(ORDER_NUMBER)) AS AOV
	FROM Sddb.Orders
	WHERE ORDERDATE GE &FY17DECstart AND ORDERDATE LE &FY17DECend 
	AND Orders.GROUP_ID IN ('35','36')
	GROUP BY 1
	ORDER BY 2 DESC;
QUIT;

/*Saksfirst*/
PROC SQL;
CREATE TABLE Insights_2 AS
	SELECT 
	SAKS_FIRST_INDICATOR,
	100 * (COUNT(DISTINCT(ORDER_NUMBER))/ (SELECT sum_orders FROM Insights_0) ) AS PERCENTAGE,
	SUM(DEMAND_DOLLARS)/ COUNT(DISTINCT(ORDER_NUMBER)) AS AOV
	FROM Sddb.Orders
	WHERE ORDERDATE GE &FY17DECstart AND ORDERDATE LE &FY17DECend 
	AND Orders.GROUP_ID IN ('35','36')
	GROUP BY 1
	ORDER BY 2 DESC;
QUIT;

/*Registered*/ /*ERROR*/
PROC SQL;
CREATE TABLE Insights_3 AS
	SELECT 
	REGISTERED_CUSTOMER,
	COUNT(DISTINCT(A.ORDER_NUMBER)) AS SUM_ORDERS,
	SUM(DEMAND_DOLLARS)/ COUNT(DISTINCT(A.ORDER_NUMBER)) AS AOV
	FROM Sddb.Orders AS A
	LEFT JOIN Sddb.Customer AS B
	ON A.CUSTOMER_NUMBER = B.CUSTOMER_ID /*Are they the same?*/
	WHERE ORDERDATE GE &FY17DECstart AND ORDERDATE LE &FY17DECend 
	AND Orders.GROUP_ID IN ('35','36')
	GROUP BY 1
	ORDER BY 2 DESC;
QUIT;

/*SaksFirst, Registered*/ /*ERROR*/
/*PROC SQL;
CREATE TABLE Insights_3 AS
	SELECT 
	REGISTERED_CUSTOMER,
	COUNT(DISTINCT(A.ORDER_NUMBER)) AS SUM_ORDERS,
	SUM(DEMAND_DOLLARS)/ COUNT(DISTINCT(A.ORDER_NUMBER)) AS AOV
	FROM Sddb.Orders AS A
	LEFT JOIN Sddb.Customer AS B
	ON A.CUSTOMER_NUMBER = B.CUSTOMER_ID
	WHERE ORDERDATE GE &FY17DECstart AND ORDERDATE LE &FY17DECend 
	AND Orders.GROUP_ID IN ('35','36')
	GROUP BY 1
	ORDER BY 2 DESC;
QUIT;
*/

/*Employee*/
PROC SQL;
CREATE TABLE Insights_5 AS
	SELECT 
	EMPLOYEE_INDICATOR,
	100 * (COUNT(DISTINCT(ORDER_NUMBER))/ (SELECT sum_orders FROM Insights_0) ) AS PERCENTAGE
	FROM Sddb.Orders
	WHERE ORDERDATE GE &FY17DECstart AND ORDERDATE LE &FY17DECend 
	AND Orders.GROUP_ID IN ('35','36')
	GROUP BY 1
	ORDER BY 2 DESC;
QUIT;

/*State*/
PROC SQL OUTOBS = 10;
	CREATE TABLE Insights_6 AS
	SELECT STATE, 
	COUNT(DISTINCT ORDER_NUMBER) AS SUM_ORDER_NUMBER
	FROM Sddb.Orders AS A
	LEFT JOIN Sddb.Customer AS B 
	ON A.INDIVIDUAL_ID = B.INDIVIDUAL_ID  /**transfer datatype since it's scientific number**/
	WHERE ORDERDATE GE &FY17DECstart AND ORDERDATE LE &FY17DECend
	GROUP BY 1
	ORDER BY 2 DESC;
QUIT;

/*
PROC SQL OUTOBS = 10;
CREATE TABLE Insights_Shoes_Kids AS
	SELECT COUNT( DISTINCT(ORDER_NUMBER) ),
	AVG(RECENCY),
	COUNTRY
	FROM Sddb.Orders
	LEFT JOIN Sddb.Individual 
	ON Orders.INDIVIDUAL_ID = Individual.INDIVIDUAL_ID
	LEFT JOIN Sddb.Address
	ON Orders.SHIP_TO_ADDRESS_ID = Address.ADDRESS_ID
	WHERE ORDERDATE GE &FY17DECstart AND ORDERDATE LE &FY17DECend 
	AND Orders.GROUP_ID IN ('35','36')
	GROUP BY SAKS_FIRST_INDICATOR, EMPLOYEE_INDICATOR, COUNTRY;
QUIT;
*/


/*-------------------------------------------Clickstream----------------------------------------------*/

/*6.Visits landed on homepage and then convert for O5*/

PROC SQL;
connect to ASTER as ast (DSN=Aster);
CREATE TABLE o5_visits_Sep AS
SELECT * FROM connection to ast
	(SELECT COUNT( DISTINCT(A.session_uuid) ) AS visits
	FROM DW.fact_omni_off5th_page_views AS A
	LEFT JOIN DW.fact_omni_off5th_events AS B
	ON A.session_uuid = B.session_uuid
	WHERE page_type = 'home page' 
	AND session_page_view_seq = 1 /* landing_page_url LIKE '%saksoff5th.com/Entry%' OR landing_page_url LIKE '%saksoff5th.com/mindex%' */
	AND event_type_id = 9 
	AND date(A.date_filter)>= '2019-09-06' 
	AND date(A.date_filter)<= '2019-09-07' /*To QA code*/
);
DISCONNECT FROM ast;
Quit;

/*landing page url / session page view seq*/


/*7.%Orders attributed to Paid Search: Trademark & % to Email*/
/*event9 value 2 & value3*/

PROC SQL;
connect to ASTER as ast (DSN=Aster);
CREATE TABLE o5_paid_search AS
SELECT * FROM connection to ast
	(SELECT 
	  ( 100 * COUNT( DISTINCT(A.session_uuid) )/ (SELECT visits FROM o5_visits_Sep)
	   AS PERCENTAGE
	FROM DW.fact_omni_off5th_page_views AS A
	LEFT JOIN DW.fact_omni_off5th_events AS B
	ON A.session_uuid = B.session_uuid
	WHERE event_type_id = 9 AND value2 = '%_TR_%' AND value3 = 'paid search' /*Plz look up at Adobe Marketing Channels file*/
    AND page_type = 'home page'
	AND date(A.date_filter)>= '2019-09-06' 
	AND date(A.date_filter)<= '2019-09-07' /*To QA code*/
);
DISCONNECT FROM ast;
Quit;

/**It's better to write in sub-queries**/

/*Email*/
PROC SQL;
connect to ASTER as ast (DSN=Aster);
CREATE TABLE o5_email AS
SELECT * FROM connection to ast
	(SELECT 
	  ( 100 * COUNT( DISTINCT(A.session_uuid) )/ (SELECT visits FROM o5_Visits_Sep)
	  AS PERCENTAGE
	FROM DW.fact_omni_off5th_page_views AS A
	LEFT JOIN DW.fact_omni_off5th_events AS B
	ON A.session_uuid = B.session_uuid
	WHERE event_type_id = 9 AND value3 = 'email'
    AND page_type = 'home page' /*when there's event 9, shall we still use order_flag*/
	AND date(A.date_filter)>= '2019-09-06' 
	AND date(A.date_filter)<= '2019-09-07' /*To QA code*/
);
DISCONNECT FROM ast;
Quit;

/*8.Visits adding to waitlist & % to top product waitlisted for Total Saks*/
/*For Saks Direct Live*/

/*To know product name, to join with SDMRK tables on PRODUCT_CODE*/

PROC SQL;
connect to ASTER as ast (DSN=Aster);
CREATE TABLE S5_visits_wl AS
SELECT * FROM connection to ast
	(SELECT COUNT( DISTINCT(session_uuid) ) AS visits,
	        product_code AS product
	FROM DW.fact_omni_saks_events AS A
	LEFT JOIN DW.fact_omni_saks_page_views AS B
	ON A.page_view_uuid = B.page_view_uuid
	WHERE event_type_id = 13
	AND date(date_filter)>= '2019-09-06' 
	AND date(date_filter)<= '2019-09-07' /*To QA code*/
	GROUP BY 2
);
DISCONNECT FROM ast;
Quit;

/*For Saks APP*/
PROC SQL;
connect to ASTER as ast (DSN=Aster);
CREATE TABLE S5_APP_visits_wl AS
SELECT * FROM connection to ast
	(SELECT COUNT( DISTINCT(session_uuid) ) AS visits,
	        product_code AS product
	FROM DW.fact_omni_saks_app_events AS A
	LEFT JOIN DW.fact_omni_saks_app_page_views AS B
	ON A.page_view_uuid = B.page_view_uuid
	WHERE event_type_id = 13
	AND date(date_filter)>= '2019-09-06' 
	AND date(date_filter)<= '2019-09-07' /*To QA code*/
	GROUP BY 2
);
DISCONNECT FROM ast;
Quit;

/*For Saks Android*/
PROC SQL;
connect to ASTER as ast (DSN=Aster);
CREATE TABLE S5_Android_visits_wl AS
SELECT * FROM connection to ast
	(SELECT COUNT( DISTINCT(session_uuid) ) AS visits,
	        product_code AS product
	FROM DW.fact_omni_saks_android_events AS A
	LEFT JOIN DW.fact_omni_saks_android_page_views AS B
	ON A.page_view_uuid = B.page_view_uuid	
	WHERE event_type_id = 13
	AND date(date_filter)>= '2019-09-06' 
	AND date(date_filter)<= '2019-09-07' /*To QA code*/
	GROUP BY 2
);
DISCONNECT FROM ast;
Quit;

/*Total numbers*/
data S5_wl; set S5_visits_wl S5_APP_visits_wl S5_Android_visits_wl;
run;

PROC SQL OUTOBS = 10;
SELECT Product, SUM(visits) 
from S5_wl
GROUP BY 1
ORDER BY 2;
QUIT;


/*9.users visited both Saks iOS & Site*/

PROC SQL;
connect to ASTER as ast (DSN=Aster);
CREATE TABLE Saks_ios_site AS
SELECT * FROM connection to ast
	(SELECT COUNT( DISTINCT(visitor_uuid) )
	FROM DW.fact_omni_saks_sessions AS A
	LEFT JOIN DW.dim_visitor_devices AS B
	ON A.session_uuid = B.session_uuid
	WHERE date(A.date_filter)>= '2019-09-06' 
	AND date(A.date_filter)<= '2019-09-07' /*To QA code*/
	AND visitor_uuid IN
		(SELECT visitor_uuid
		FROM DW.fact_omni_saks_app_sessions AS C
		LEFT JOIN DW.dim_visitor_devices AS D
		ON C.session_uuid = D.session_uuid
		WHERE date(A.date_filter)>= '2019-09-06' 
		AND date(A.date_filter)<= '2019-09-07'
);
DISCONNECT FROM ast;
Quit;
/* dim tables visitor uuid*/


/*10.% in brower Mozilla Firefox*/
PROC SQL;
connect to ASTER as ast (DSN=Aster);
CREATE TABLE hb_browser AS
SELECT * FROM connection to ast
(SELECT 
	  ( 100 * COUNT( DISTINCT(session_uuid) )/ (SELECT COUNT( DISTINCT(session_uuid) ) 
						FROM DW.fact_omni_bay_sessions
						WHERE date(date_filter)>= '2019-09-01' 
	  					AND date(date_filter)<= '2019-09-07') )
	  AS PERCENTAGE
FROM DW.fact_omni_bay_sessions
WHERE brower_name = 'Mozilla Firefox'
	  AND date(date_filter)>= '2019-09-06' 
	  AND date(date_filter)<= '2019-09-07' /*To QA code*/
);
DISCONNECT FROM ast;
Quit;
