/* Objective 1 : To explore the overall crime trend in United States 	     */
/* 	a) How was the total crime in U.S. from 2014 to 2015?		     */
/* 	b) What type of crimes increased in U.S. from 2014 to 2015?	     */

/* Sort data by year */
proc sort data=work.crimedata_v5
	out=work.crimedata_v5_sort;
	by year;
run;

/* Summary of total crime by year */
title 'Number of crimes by year';
proc means data=work.crimedata_v5_sort sum;
	by year;
	var violent_crime property_crime arson total_crime;
run;
title;

/* Visualize total crime trend from 2014 to 2015 */
proc sgplot data=work.crimedata_v5_sort;
	vbar year / response=total_crime datalabel stat=sum name='Bar';
	yaxis min=1500000;
	title 'Total Crime By Year';
run;

/* Visualize total crime trend by types from 2014 to 2015 */
proc transpose data=work.crimedata_v5
	out=work.crimedata_v5_trans (rename=(col1=Number_of_crime
					     _name_=Type_of_Crime));
	by state city year population;
run;

data work.crimedata_v5_trans;
	set work.crimedata_v5_trans;
	Crime_ratio_per_100k = number_of_crime/population*100000;
	drop _label_ population;
run;

data work.crimedata_v5_trans_obj1;
	set work.crimedata_v5_trans;
	where type_of_crime in ('Violent_crime', 'Property_crime', 'Arson');
run;

proc sgplot data=work.crimedata_v5_trans_obj1;
	vbar type_of_crime / response=number_of_crime group=year groupdisplay=cluster;
	title 'Total Crime By Year and Type of Crime';
run;







