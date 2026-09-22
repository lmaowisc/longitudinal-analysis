

/* Lecture 21. Penalized splines for semiparametric regression*/



/*
semiparametric Regression Model for Log Progesterone Concentration 
 */


data progest; 
     infile 'progesterone-data.txt';
	 /*Variable List:
ID, Group (0=non-conceptive, 1=conceptive), Time (in days),  Log PdG*/
     input id group time logp;
*************************************************************************************************;
*   Use ARRAY statement in SAS to create truncated line functions for piecewise    *; 
*   linear curve with 22 knots located consecutively from days  -7 through 14           *;                                       
*************************************************************************************************;
	array bf(22) bf1 - bf22;
	do j = 1 to 22;
     	knot = -8 + j;
     	bf(j) = max(0, time - knot);
	end;
	drop j knot;
run;
 



/* Descriptive analysis*/
/* compute the mean log pdg by group and time*/
proc means data=progest n mean nway; 
   var logp;
   class group time; 
   output out=logp_mean mean=mean;  
run;




/*Plot the  Mean of Log PdG by Group*/
goptions reset = all;
   symbol1 value=circle color=black interpol = join;
   symbol2 value=triangle color=red interpol = join;
   axis1 order =(-8 to 15 by 1) label=('Time (days)');
   axis2 order =(-1.2 to 2.2 by 0.2) label = (angle=90 'Mean of log PdG');
   legend1  label=none value=(h=1.5 'Non-Conceptive' 'Conceptive') position=(bottom right inside);
title1 Time Plot of the Mean of Log PdG by Group;
proc gplot data=logp_mean; 
   plot mean*time=group / haxis = axis1 vaxis = axis2 legend=legend1;
run;
title1; 





title1 Mixed Model Representation of Semiparametric Regression Model 
	for Log Progesterone Concentration;
title2 Study of Log Progesterone Concentration during Menstrual Cycle;
/*bfk=(time-k+8)_+*/
proc mixed data=progest; 
     class id;
     model logp = time group group*time group*bf15 / solution;/*bf15=(time-7)_+*/
     random bf1-bf22 / type=toep(1) solution;
     random intercept time / subject=id type=un;
run;




