/*---------------------------------------------------Clickstream Analysis---------------------------------------------------------*/

/*1.How many visits landed on the homepage and ended up with conversions in FY19 Nov. Week 4 for Saks Off Fifth*/

/**To explore during the week of Black Friday, the conversion rate of those who land on homepage,**/
/**So we could compared to the conversion rate of those who land on other promotion landing pages**/
/**To see whether special promotion landing pages contribute higher conversion rate, if so, how much of the difference**/

PROC SQL;
connect to ASTER as ast (DSN=Aster);
CREATE TABLE o5_visits_NOV AS
SELECT * FROM connection to ast
	(SELECT COUNT( DISTINCT(A.session_uuid) ) AS visits
	FROM DW.fact_omni_off5th_page_views AS A
	LEFT JOIN DW.fact_omni_off5th_events AS B
	ON A.session_uuid = B.session_uuid
	WHERE page_type = 'home page' 
	AND session_page_view_seq = 1 /*OR landing_page_url LIKE '%saksoff5th.com/Entry%' OR landing_page_url LIKE '%saksoff5th.com/mindex%'*/
	AND event_type_id = 9 /*EVENT 9 is conversion*/
	AND date(A.date_filter)>= '2019-11-24' 
	AND date(A.date_filter)<= '2019-11-30'
);
DISCONNECT FROM ast;
Quit;

/*We could use attribute 'session page view seq' or 'landing page url'*/


/*============================================================================================================================*/

/*2.For the above orders, what % of orders were attributed to Paid Search: Trademark and what % to Email marketing channel*/

/**Break down: To see the percentage of important channels that contribute to conversions with homepage as the landing page**/

/*%Paid Search: Trademark*/
PROC SQL;
connect to ASTER as ast (DSN=Aster);
CREATE TABLE o5_paid_search AS
SELECT * FROM connection to ast
	(SELECT 
	  ( 100 * COUNT( DISTINCT(A.session_uuid) )/ (SELECT visits FROM o5_visits_NOV)
	   AS PERCENTAGE
	FROM DW.fact_omni_off5th_page_views AS A
	LEFT JOIN DW.fact_omni_off5th_events AS B
	ON A.session_uuid = B.session_uuid
	WHERE event_type_id = 9 
	AND value2 = '%_TR_%' AND value3 = 'paid search' /*Specify rules to filter out marketing channels*/
        AND page_type = 'home page'
	AND session_page_view_seq = 1
	AND date(A.date_filter)>= '2019-11-24' 
	AND date(A.date_filter)<= '2019-11-30'
);
DISCONNECT FROM ast;
Quit;

/*%Paid Search: Trademark - Sub-queries - faster*/
PROC SQL;
connect to ASTER as ast (DSN=Aster);
CREATE TABLE o5_paid_search AS
SELECT * FROM connection to ast
	(SELECT 
	  ( 100 * COUNT( DISTINCT(A.session_uuid) )/ (SELECT visits FROM o5_visits_NOV)
	   AS PERCENTAGE
	FROM DW.fact_omni_off5th_page_views AS A
	LEFT JOIN DW.fact_omni_off5th_events AS B
	ON A.session_uuid = B.session_uuid
	AND value2 = '%_TR_%' AND value3 = 'paid search' /*Specify rules to filter out marketing channels*/
	AND session_uuid IN
		( SELECT session_uuid
		FROM DW.fact_omni_off5th_page_views AS C
		LEFT JOIN DW.fact_omni_off5th_events AS D
		ON C.session_uuid = D.session_uuid
		WHERE page_type = 'home page' 
		AND session_page_view_seq = 1
		AND event_type_id = 9
		AND date(A.date_filter)>= '2019-11-24' 
		AND date(A.date_filter)<= '2019-11-30')
);
DISCONNECT FROM ast;
Quit;

/*%Email*/
PROC SQL;
connect to ASTER as ast (DSN=Aster);
CREATE TABLE o5_email AS
SELECT * FROM connection to ast
	(SELECT 
	  ( 100 * COUNT( DISTINCT(A.session_uuid) )/ (SELECT visits FROM o5_Visits_NOV)
	  AS PERCENTAGE
	FROM DW.fact_omni_off5th_page_views AS A
	LEFT JOIN DW.fact_omni_off5th_events AS B
	ON A.session_uuid = B.session_uuid
	WHERE event_type_id = 9 AND value3 = 'email'
    	AND page_type = 'home page'
	AND session_page_view_seq = 1
	AND date(A.date_filter)>= '2019-11-24' 
	AND date(A.date_filter)<= '2019-11-30'
);
DISCONNECT FROM ast;
Quit;


/*============================================================================================================================*/

/*3.What were the top 10 products waitlisted for total Saks Fifth Avenue in FY19 Nov. Week 4*/

/**Deep dive into top waitlisted products and give assumptions of being waitlisted (price, lack of size or color)**/
/**To provide insights for promotion team or site merchandising team**/

/*Total Saks: Saks Direct Live, Saks iOS APP, Saks Android APP*/

/*Saks Direct Live*/

PROC SQL;
connect to ASTER as ast (DSN=Aster);
CREATE TABLE S5_visits_wl AS
SELECT * FROM connection to ast
	(SELECT COUNT( DISTINCT(session_uuid) ) AS visits,
	        product_code AS product
	FROM DW.fact_omni_saks_events AS A
	LEFT JOIN DW.fact_omni_saks_page_views AS B
	ON A.page_view_uuid = B.page_view_uuid
	WHERE event_type_id = 13 /*EVENT 13 is waitlist*/
	AND date(date_filter)>= '2019-11-24' 
	AND date(date_filter)<= '2019-11-30'
	GROUP BY 2
);
DISCONNECT FROM ast;
Quit;

/*For Saks iOS APP*/
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
	AND date(date_filter)>= '2019-11-24' 
	AND date(date_filter)<= '2019-11-30'
	GROUP BY 2
);
DISCONNECT FROM ast;
Quit;

/*For Saks Android APP*/
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
	AND date(date_filter)>= '2019-11-24' 
	AND date(date_filter)<= '2019-11-30'
	GROUP BY 2
);
DISCONNECT FROM ast;
Quit;

/*Total Saks*/
data S5_wl; set S5_visits_wl S5_APP_visits_wl S5_Android_visits_wl;
run;

PROC SQL OUTOBS = 10;
SELECT Product, SUM(visits) 
from S5_wl
GROUP BY 1
ORDER BY 2;
QUIT;


/*============================================================================================================================*/

/*4.How many users visited both Saks iOS APP and Site in FY19 Nov. Week 4*/

/**To mesure the cannibalization in some way and exlpore which one has higher conversion rate, in what aspects**/

PROC SQL;
connect to ASTER as ast (DSN=Aster);
CREATE TABLE Saks_ios_site AS
SELECT * FROM connection to ast
	(SELECT COUNT( DISTINCT(visitor_uuid) )
	FROM DW.fact_omni_saks_sessions AS A
	LEFT JOIN DW.dim_visitor_devices AS B /*dim table: more details about visitors*/
	ON A.session_uuid = B.session_uuid
	WHERE date(A.date_filter)>= '2019-11-24' 
	AND date(A.date_filter)<= '2019-11-30'
	AND visitor_uuid IN
		(SELECT visitor_uuid
		FROM DW.fact_omni_saks_app_sessions AS C
		LEFT JOIN DW.dim_visitor_devices AS D
		ON C.session_uuid = D.session_uuid
		WHERE date(A.date_filter)>= '2019-11-24' 
		AND date(A.date_filter)<= '2019-11-30'
);
DISCONNECT FROM ast;
Quit;


/*============================================================================================================================*/

/*5.What % of Hudson's Bay sessions in FY19 Nov was from Mozilla Firefox*/

/**Monitior the brower usage of visitors to support Paid Search team**/

PROC SQL;
connect to ASTER as ast (DSN=Aster);
CREATE TABLE hb_browser AS
SELECT * FROM connection to ast
	(SELECT 
	  ( 100 * COUNT( DISTINCT(session_uuid) )/ (SELECT COUNT( DISTINCT(session_uuid) ) 
						FROM DW.fact_omni_bay_sessions
						WHERE date(date_filter)>= '2019-11-24' 
	  					AND date(date_filter)<= '2019-11-30') )
	 AS PERCENTAGE
	 FROM DW.fact_omni_bay_sessions
	 WHERE brower_name = 'Mozilla Firefox'
	 AND date(date_filter)>= '2019-11-24' 
	 AND date(date_filter)<= '2019-11-30'
);
DISCONNECT FROM ast;
Quit;
