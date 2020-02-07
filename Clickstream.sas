/*-------------------------------------------Clickstream Analysis----------------------------------------------*/

/*1.How many visits landed on the homepage and ended up with conversions on Nov week 4*/

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
	AND date(A.date_filter)<= '2019-09-07'
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
