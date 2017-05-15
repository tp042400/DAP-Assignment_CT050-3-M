/* To study the crime details in the selected top states.			*/
/* 	Top 3 states with highest crime rate: California, Texas, New York	*/
/* 	Top 3 states with lowest crime rate: North Dakota, New Hampshire, Idaho	*/
/*	*/

%let tophighstate = ('UTAH', 'NEW MEXICO', 'MISSOURI');
%let toplowstate = ('HAWAII', 'NEW YORK', 'IDAHO');
%let property = ('Burglary' 'Larceny_theft' 'Motor_vehicle_theft');
%let violent = ('Murder', 'Total_rape', 'Robbery', 'Aggravated_assault');
%let arson = ('Arson');

/* Add column 'Risk_status' to identify low or high risk state */
data work.crimedata_v5_trans_state;
	set work.crimedata_v5_trans;
	where state in &tophighstate or
		state in &toplowstate;
	if state in &tophighstate then Risk_status = 'Top High Risk';
	else if state in &toplowstate then Risk_status = 'Top Low Risk';
run;

/* Explore Property Crime */
proc tabulate data=work.crimedata_v5_trans_state;
   class year risk_status state type_of_crime;
   var crime_ratio_per_100k;
   table risk_status*state, (year all)*type_of_crime=' '*crime_ratio_per_100k=' '*mean='Average Crime Ratio';
   where type_of_crime in &property;
   title 'Average Property Crime in Top Risk States by Year';
run;

proc sgplot data=work.crimedata_v5_trans_state;
	where type_of_crime in &property;
	hbar type_of_crime / response=crime_ratio_per_100k group=risk_status groupdisplay=cluster stat=mean;
	title 'Average Property Crime in Top Risk States';
run;

/* Explore Violent Crime */
proc tabulate data=work.crimedata_v5_trans_state;
   class year risk_status state type_of_crime;
   var crime_ratio_per_100k;
   table risk_status*state, (year all)*type_of_crime=' '*crime_ratio_per_100k=' '*mean='Average Crime Ratio';
   where type_of_crime in &violent;
   title 'Average Violent Crime in Top Risk States by Year';
run;

proc sgplot data=work.crimedata_v5_trans_state;
	where type_of_crime in &violent;
	hbar type_of_crime / response=crime_ratio_per_100k group=risk_status groupdisplay=cluster stat=mean;
	title 'Average Violent Crime in Top Risk States';
run;

/* Explore Arson Crime */
proc tabulate data=work.crimedata_v5_trans_state;
   class year risk_status state type_of_crime;
   var crime_ratio_per_100k;
   table risk_status*state, (year all)*type_of_crime=' '*crime_ratio_per_100k=' '*mean='Average Crime Ratio';
   where type_of_crime in &arson;
   title 'Average Arson Crime in Top Risk States by Year';
run;

proc sgplot data=work.crimedata_v5_trans_state;
	where type_of_crime in &arson;
	hbar type_of_crime / response=crime_ratio_per_100k group=risk_status groupdisplay=cluster stat=mean;
	title 'Average Arson Crime in Top Risk States';
run;

data work.crimedata_v5_trans_obj3;
	set work.crimedata_v5_trans_state;
	where type_of_crime in &property or
		type_of_crime in &violent or
		type_of_crime in &arson;
run;

proc sgplot data=work.crimedata_v5_trans_obj3;
	hbar type_of_crime / response=crime_ratio_per_100k group=risk_status groupdisplay=cluster stat=mean;
	title 'Average Crime Details by Selected States';
run;





