

/* Lecture 20. Inverse Probability Weighting for Missing Data */

/*Read in the Amenorrhea data*/
data contracep;
     infile 'contracep-data.txt';
	 /*Variable List:
ID, Dose (0=Low,1=High), Occasion, Amenorrhea Status, Amenorrhea Status at Previous Occasion,
Response Indicator.
Note: Amenorrhea Status (1=Amenorrhea,0=No Amenorrhea,.=Missing).
         Response Indicator (1=If Amenorrhea Status Observed, 0=If Amenorrhea Status Missing)*/
     input id dose time y prevy r;
run;

proc sort data=contracep;
     by id time;
run;

 

/* Descriptive analysis*/
/* compute the proportions of amenorrhea by dose group and occasion*/
proc means data=contracep n mean nway; 
   var y;
   class dose time; 
   output out=am_mean mean=mean;  
run;

/*compute the log odds of amenorrhea */
data am_mean;
	set am_mean;
	logodds=log(mean/(1-mean));
run;


/*Plot the proportion of amenorrhea against time by dose group*/
goptions reset = all;
   symbol1 value=circle color=black interpol = join;
   symbol2 value=triangle color=red interpol = join;
   axis1 order =(0 to 3 by 1) label=('Time (quarters)');
   axis2 order =(0.15 to 0.55 by 0.1) label = (angle=90 'Proportion of amenorrhea');
   legend1  label=none value=(h=1.5 'Low dose' 'High dose') position=(bottom right inside);
title1 Time Plot of Proportion of Amenorrhea by Treatment Group;
proc gplot data=am_mean; 
   plot mean*time=dose / haxis = axis1 vaxis = axis2 legend=legend1;
run;
title1; 
/*Plot the log-odds of amenorrhea against time by dose group*/
goptions reset = all;
   symbol1 value=circle color=black interpol = join;
   symbol2 value=triangle color=red interpol = join;
   axis1 order =(0 to 3 by 1) label=('Time (quarters)');
   axis2 order =(-1.5 to 0.5 by 0.25) label = (angle=90 'Log-odds of amenorrhea');
   legend1  label=none value=(h=1.5 'Low dose' 'High dose') position=(bottom right inside);
title1 Time Plot of Log-Odds of Amenorrhea by Treatment Group;
proc gplot data=am_mean; 
   plot logodds*time=dose / haxis = axis1 vaxis = axis2 legend=legend1;
run;
title1; 





/*
IPW-GEE Estimation of Marginal Logistic Regression Model
*/
title1 Logistic Regression Model for Probability of Remaining on Study; 
title2 Clinical Trial of Contracepting Women;
proc genmod data=contracep descending;
     class time (ref="1");
	 /*selection model: a parsimonious model including measurement
	 	occasion, dose group, "lagged" response, and 
	 	interaction between dose group and "lagged" response*/
     model r = time dose prevy dose*prevy / dist=bin link=logit;
	 /*The baseline measurement is always observed*/
     where time ne 0;
	 /* output to sas dataset "predict" with column "probs" containing
	 	the \pi_ij's */
     output out=predict p=probs;
run;
title1;title2;

proc sort data=predict;
     by id time;
run;
 

/* compute the selection probabilities using the\pi_ij's*/
data wgt (keep=id time cumprobs probs);
     set predict;
     by id;
	 /*cumprobs=cumulative product of \pi_ij */
     retain cumprobs;
     if first.id then cumprobs=probs;
     else cumprobs=cumprobs*probs;
run;
 

/*merge the original dataset and the dataset containing weights*/
data combine;
     merge contracep wgt;
     by id time;
	  /*The baseline measurement is always observed*/ 
     if (time=0) then ipw=1;
     else ipw=1/cumprobs;
run;
 

title1 IPW-GEE Estimation of Marginal Logistic Regression Model for Odds of Amenorrhea;
title2 Clinical Trial of Contracepting Women;
proc genmod descending data=combine;
 	/*Use the WEIGHT statement to specify the weights*/
     weight ipw;
     class id;
     model y = dose time dose*time / dist=bin link=logit;
     repeated subject=id / type=ind;
run;
title1;title2;



/* compare with the naive (unweighted available-data) analysis*/
title1 Naive (unweighted) Estimation of Marginal Logistic Regression Model for Odds of Amenorrhea;
title2 Clinical Trial of Contracepting Women;
proc genmod descending data=combine;
     class id;
     model y = dose time dose*time / dist=bin link=logit;
     repeated subject=id / type=ind;
run;
title1;title2;

