/* Objective 2 : To identify the top 3 states with highest & lowest crime rate. */
/* 	a) What are the top 3 states with highest crime rate?		     	*/
/* 	b) What are the top 3 states with lowest crime rate?		     	*/

/* Aggregate the table into state level using SQL query */
proc sql;
	create table work.crimedata_v5_state as
	select state, 
		sum(population) as Population, 
		sum(total_crime) as Total_crime
	from work.crimedata_v5_sort
	group by state;
quit;

/* Add crime ratio column */
data work.crimedata_v5_state;
	set work.crimedata_v5_state;
	Total_crime_ratio_per_100k = total_crime / population * 100000;
run;

/* Sort Total Crime in DESCENDING order*/
proc sort data=work.crimedata_v5_state
	out=work.crimedata_v5_state_top3high;
	by descending total_crime_ratio_per_100k;
run;

title 'Top 3 States with Highest Crime Rate';
proc print data=crimedata_v5_state_top3high (obs=3);
run;
title;

/* Sort Total Crime in ASCENDING order */
proc sort data=work.crimedata_v5_state
	out=work.crimedata_v5_state_top3low;
	by total_crime_ratio_per_100k;
run;

title 'Top 3 States with Lowest Crime Rate';
proc print data=crimedata_v5_state_top3low (obs=3);
run;
title;


proc sgplot data=work.crimedata_v5_state;
	hbar state / response=total_crime_ratio_per_100k categoryorder=respdesc;
	title 'Crime rate by state in U.S.';
run;


