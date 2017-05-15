/* Data Import : Crime Data */
proc import datafile="/home/ng.wge0731/DAP Assignment/crime data_processed.xlsx"
	out=work.crimedata
	dbms=xlsx
	replace;
run;

title 'Imported Crime Data';
proc contents data=crimedata;
run;

proc print data=crimedata (obs=30);
run;
title;


/* Data Import : 2015 Population Data */
/* According to World Bank publication, U.S. population growth from 2014 to 2015 is 0.784% */
/* 2015 population data was calculated by taking (2014 data)*1.00784 */
proc import datafile="/home/ng.wge0731/DAP Assignment/population_2015.xlsx"
	out=work.population15
	dbms=xlsx
	replace;
run;

title 'Imported Population Data (2015)';
proc contents data=population15;
run;

proc print data=population15 (obs=30);
run;
title;


/* Data Import : Poverty Rate Data */
proc import datafile="/home/ng.wge0731/DAP Assignment/poverty data.xlsx"
	out=work.poverty
	dbms=xlsx
	replace;
run;

title 'Imported Poverty Rate Data';
proc contents data=poverty;
run;

proc print data=poverty (obs=30);
run;
title;


/* Data Import : Unemployment Rate Data */
proc import datafile="/home/ng.wge0731/DAP Assignment/unemploy data.xlsx"
	out=work.unemploy
	dbms=xlsx
	replace;
run;

title 'Imported Unemployment Rate Data';
proc contents data=unemploy;
run;

proc print data=unemploy (obs=30);
run;
title;



