/* To analyze the crime details in the selected top cities			*/
/* 	Top 3 cities with highest crime rate: New York, Houston, Los Angeles	*/
/* 	Top 3 cities with lowest crime rate: Fargo, Manchester, Boise		*/
/* 	*/

%let tophighstate = ('UTAH', 'NEW MEXICO', 'MISSOURI');
%let toplowstate = ('HAWAII', 'NEW YORK', 'IDAHO');
%let tophighcity = ('SALT LAKE CITY', 'SPRINGFIELD', 'ST. LOUIS');
%let toplowcity = ('YONKERS', 'AMHERST TOWN', 'NEW YORK');
%let property = ('Burglary' 'Larceny_theft' 'Motor_vehicle_theft');
%let violent = ('Murder', 'Total_rape', 'Robbery', 'Aggravated_assault');
%let arson = ('Arson');

/* Add column 'Risk_status' to identify low or high risk city */
data work.crimedata_v5_trans_city_v2;
	set work.crimedata_v5_trans_city;
	where (city in &tophighcity or city in &toplowcity) and
		(state in &tophighstate or state in &toplowstate);
	if city in &tophighcity then Risk_status = 'Top High Risk';
	else if city in &toplowcity then Risk_status = 'Top Low Risk';
run;

/* Explore Property Crime in City Level */
proc tabulate data=work.crimedata_v5_trans_city_v2;
   class risk_status state city type_of_crime;
   var avg_crime_ratio_per_100k;
   table risk_status*state*city, type_of_crime=' '*avg_crime_ratio_per_100k=' '*mean='Avg Crime Ratio';
   where type_of_crime in &property;
   title 'Average Property Crime in Top Risk Cities';
run;

/* Explore Violent Crime in City Level */
proc tabulate data=work.crimedata_v5_trans_city_v2;
   class risk_status state city type_of_crime;
   var avg_crime_ratio_per_100k;
   table risk_status*state*city, type_of_crime=' '*avg_crime_ratio_per_100k=' '*sum='Avg Crime Ratio';
   where type_of_crime in &violent;
   title 'Average Violent Crime in Top Risk Cities';
run;

/* Explore Arson Crime in City Level */
proc tabulate data=work.crimedata_v5_trans_city_v2;
   class risk_status state city type_of_crime;
   var avg_crime_ratio_per_100k;
   table risk_status*state*city, type_of_crime=' '*avg_crime_ratio_per_100k=' '*sum='Avg Crime Ratio';
   where type_of_crime in &arson;
   title 'Average Arson Crime in Top Risk Cities';
run;

data work.crimedata_v5_trans_obj5;
	set work.crimedata_v5_trans_city_v2;
	where type_of_crime in &property or
		type_of_crime in &violent or
		type_of_crime in &arson;
run;

proc sgplot data=work.crimedata_v5_trans_obj5;
	vbar type_of_crime / response=avg_crime_ratio_per_100k group=risk_status groupdisplay=cluster stat=mean;
	title 'Average Crime Ratio in Top Risk Cities';
run; 

proc sgplot data=work.crimedata_v5_trans_obj5;
	vbar type_of_crime / response=avg_crime_ratio_per_100k group=city groupdisplay=cluster stat=mean;
	where risk_status = 'Top Low Risk';
	title 'Average Crime Ratio in Top Low Risk Cities';
run; 






