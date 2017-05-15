/* To analyze how unemployment rate relates to the property crime rate.	*/

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
	where type_of_crime in ('Property_crime', 'Violent_crime', 'Arson');
	drop _label_;
run;

/* Crime Data - Data massaging & processing */
proc sort data=work.crimedata_v5_trans_v2;
	by state type_of_crime;
run;

proc transpose data=work.crimedata_v5_trans_v2
	out=work.crimedata_v5_trans_v3 
	prefix=Crime_;
	by state type_of_crime;
	id year;
	var number_of_crime;
run;

/* Crime Data - Calculate Property Crime Growth Rate from 2014 to 2015 */
data work.crimedata_v5_trans_v4_property;
	set work.crimedata_v5_trans_v3;
	Crime_growth = (crime_2015-crime_2014)/crime_2014*100;
	where type_of_crime = 'Property_crime';
	drop _name_;
run;

/* Crime Data - Calculate Violent Crime Growth Rate from 2014 to 2015 */
data work.crimedata_v5_trans_v4_violent;
	set work.crimedata_v5_trans_v3;
	Crime_growth = (crime_2015-crime_2014)/crime_2014*100;
	where type_of_crime = 'Violent_crime';
	drop _name_;
run;

/* Crime Data - Calculate Arson Crime Growth Rate from 2014 to 2015 */
data work.crimedata_v5_trans_v4_arson;
	set work.crimedata_v5_trans_v3;
	Crime_growth = (crime_2015-crime_2014)/crime_2014*100;
	where type_of_crime = 'Arson';
	drop _name_;
run;


/* Unemployment Data - Data massaging & processing */
proc sort data=work.unemploy;
	by state year;
run;

proc transpose data=work.unemploy
	out=work.unemploy_v2
	prefix=Unemployment_;
	by state;
	id year;
	var Unemployment_rate;
run;

/* Unemployment Data - Calculate Unemployment Growth Rate from 2014 to 2015 */
data work.unemploy_v3;
	set work.unemploy_v2;
	Unemployment_growth = (unemployment_2015-unemployment_2014)/unemployment_2014*100;
	drop _name_ _label_;
run;

/* Merge unemployment data into Property Crime data */
data work.crimedata_v5_trans_v4_property;
	set work.crimedata_v5_trans_v4_property;
	merge unemploy_v3;
	by state;
run;

/* Merge unemployment data into Violent Crime data */
data work.crimedata_v5_trans_v4_violent;
	set work.crimedata_v5_trans_v4_violent;
	merge unemploy_v3;
	by state;
run;

/* Merge unemployment data into Property Crime data */
data work.crimedata_v5_trans_v4_arson;
	set work.crimedata_v5_trans_v4_arson;
	merge unemploy_v3;
	by state;
run;

/* Append all 3 tables : Property, Violent and Arson tables */
data work.crimedata_v5_trans_obj7;
	set crimedata_v5_trans_v4_property crimedata_v5_trans_v4_violent crimedata_v5_trans_v4_arson;
run;

proc print data=work.crimedata_v5_trans_obj7 (obs=30);
	var state type_of_crime crime_growth unemployment_growth;
run;

proc sgscatter data=work.crimedata_v5_trans_obj7;
	plot crime_growth*unemployment_growth / group=type_of_crime;
	title 'Unemployment Growth vs Overall Crime Growth';
run;
