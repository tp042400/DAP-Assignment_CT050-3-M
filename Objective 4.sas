/* To identify the high-risk city in the top 3 states with highest crime rate.	*/
/* To identify the low-risk city in the top 3 states with lowest crime rate.	*/

%let tophigh = ('UTAH', 'NEW MEXICO', 'MISSOURI');
%let toplow = ('HAWAII', 'NEW YORK', 'IDAHO');

/* Aggregate the table into city level using SQL query */
proc sql;
	create table work.crimedata_v5_trans_city as
	select state,
		city,
		type_of_crime,
		sum(number_of_crime) as Number_of_crime,
		mean(crime_ratio_per_100k) as Avg_crime_ratio_per_100k
	from work.crimedata_v5_trans
	group by state, city, type_of_crime;
quit;

/* Explore top 3 high risk cities among the top risk states */
proc tabulate data=work.crimedata_v5_trans_city;
   class state city type_of_crime;
   var avg_crime_ratio_per_100k;
   table state*city, type_of_crime=' '*avg_crime_ratio_per_100k=' '*mean='Average Crime Ratio per 100,000';
   where state in &tophigh and type_of_crime='Total_crime';
   title 'Average Crime Ratio in Top High Risk Cities';
run;

proc sgplot data=work.crimedata_v5_trans_city;
	where state in &tophigh and type_of_crime ='Total_crime';
	hbar city / response=avg_crime_ratio_per_100k stat=mean;
	title 'Average Crime Ratio in Top High Risk Cities';
run;


/* Explore top 3 low risk cities among the top risk states */
proc tabulate data=work.crimedata_v5_trans_city;
   class state city type_of_crime;
   var avg_crime_ratio_per_100k;
   table state*city, type_of_crime=' '*avg_crime_ratio_per_100k=' '*mean='Average Crime Ratio per 100,000';
   where state in &toplow and type_of_crime='Total_crime';
   title 'Average Crime Ratio in Top Low Risk Cities';
run;

proc sgplot data=work.crimedata_v5_trans_city;
	where state in &toplow and type_of_crime ='Total_crime';
	hbar city / response=avg_crime_ratio_per_100k stat=mean;
	title 'Average Crime Ratio in Top Low Risk Cities';
run;



