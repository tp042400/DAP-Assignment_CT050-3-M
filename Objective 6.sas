/* To analyze how poverty relates to property crime rate.		*/
/* 	Poverty Rate vs Property Crime Rate 				*/

%let tophighstate = ('UTAH', 'NEW MEXICO', 'MISSOURI');
%let toplowstate = ('HAWAII', 'NEW YORK', 'IDAHO');

/* Aggregate crime table by year & state level */
proc sql;
	create table work.crimedata_v5_trans_v1 as
	select state, 
		year,
		type_of_crime,
		sum(Number_of_crime) as Number_of_crime
	from work.crimedata_v5_trans
	group by state, year, type_of_crime;
quit;

/* Crime Data - Data filtering */
data work.crimedata_v5_trans_v2;
	set work.crimedata_v5_trans_v1;
	where (state in &tophighstate or
		state in &toplowstate) and 
		(type_of_crime = 'Property_crime');
	if state in &tophighstate then Risk_status = 'Top High Risk';
	else if state in &toplowstate then Risk_status = 'Top Low Risk';
		
	drop _label_;
run;

/* Crime Data - Data massaging & processing */
proc sort data=work.crimedata_v5_trans_v2;
	by state year type_of_crime;
run;

proc transpose data=work.crimedata_v5_trans_v2
	out=work.crimedata_v5_trans_v3 
	prefix=Property_crime_;
	by state risk_status type_of_crime;
	id year;
	var number_of_crime;
run;

/* Crime Data - Calculate Property Crime Growth Rate from 2014 to 2015 */
data work.crimedata_v5_trans_v4;
	set work.crimedata_v5_trans_v3;
	Property_crime_growth = (property_crime_2015-property_crime_2014)/property_crime_2014*100;
	drop _name_;
run;

/* Poverty Data - Data massaging & processing */
proc sort data=work.poverty;
	by state year;
run;

proc transpose data=work.poverty
	out=work.poverty_v2
	prefix=Poverty_;
	by state;
	id year;
	var poverty_rate;
run;

/* Poverty Data - Calculate Poverty Growth Rate from 2014 to 2015 */
data work.poverty_v3;
	set work.poverty_v2;
	Poverty_growth = (poverty_2015-poverty_2014)/poverty_2014*100;
	drop _name_ _label_;
run;

/* Merge poverty data into crime data */
data work.crimedata_v5_trans_obj6;
	set work.crimedata_v5_trans_v4;
	merge poverty_v3;
	
	by state;
run;

proc print data=work.crimedata_v5_trans_obj6;
	var state risk_status property_crime_growth poverty_growth;
run;

proc sgscatter data=work.crimedata_v5_trans_obj6;
	plot property_crime_growth*poverty_growth / datalabel=state group=risk_status;
	title 'Poverty Growth vs Property Crime Growth';
run;