/* Macro function : Replace missing value */
%macro replace_value(variable_, find_, replacement_, arrname_);
	array &arrname_ _numeric_;
		do over &arrname_;
			if &variable_ = &find_ then &variable_ = &replacement_;
		end;
%mend;


/* Check missing value count */
title 'Overview of Missing Values';
proc means data=work.crimedata nmiss;
run;
title;


/* Calculate variable 'Total_rape' */
data work.crimedata_v2;
	set work.crimedata;
	
	*replace missing with 0 for variable 'rape_revised' & 'rape_legacy';
	%replace_value(rape_revised, ., 0, rape_revise_new);
	%replace_value(rape_legacy, ., 0, rape_legacy_new);
	
	*create variable 'Total_rape';
	Total_rape = rape_revised + rape_legacy;

	drop rape_revised rape_legacy;
run;

/* Merge data to fill up 2015 population data */
proc sql;
	create table temp_joined as
	select crimedata_v2.State,
		crimedata_v2.City,
		crimedata_v2.Year,
		crimedata_v2.Population,
		crimedata_v2.Violent_crime,
		crimedata_v2.Murder,
		crimedata_v2.Robbery,
		crimedata_v2.Aggravated_assault,
		crimedata_v2.Property_crime,
		crimedata_v2.Burglary,
		crimedata_v2.Larceny_theft,
		crimedata_v2.Motor_vehicle_theft,
		crimedata_v2.Arson,
		crimedata_v2.Total_rape,
	       population15.population15
	from crimedata_v2
	left join population15
	on crimedata_v2.state = population15.state and
	   crimedata_v2.city = population15.city and
	   crimedata_v2.year = population15.year;
quit;

data work.crimedata_v3;
	set work.temp_joined(rename=(Population=Population14));
	
	*replace missing with 0 for variable 'Population14' & 'Population15' ;
	%replace_value(population14, ., 0, pop14_new);
	%replace_value(population15, ., 0, pop15_new);
	
	*Sum up to become complete variable 'Population';
	Population = population14 + population15;
	
	*replace 0 as missing value as they should be imputed with average in coming step;
	*(p/s: population with 0 does not make any sense!);
	%replace_value(population, 0, ., pop_new);
	
	drop population14 population15;
run;

/* Impute missing values with average values */
proc standard data=work.crimedata_v3 
	out=work.crimedata_v4 
	replace 
	print;
run;

/* Calculate total crime & crime ratio */
data work.crimedata_v5;
	set work.crimedata_v4;
	Total_crime = violent_crime + property_crime + arson;
	Total_crime_ratio_per_100k = total_crime / population * 100000;
run;

title 'New Data Set: Pre-processed Data';
proc contents data=crimedata_v5;
run;

proc print data=crimedata_v5;
run;
title;

/* Re-explore the missing value count */
title 'Overview of Missing Values';
proc means data=work.crimedata_v5 nmiss;
run;
title;