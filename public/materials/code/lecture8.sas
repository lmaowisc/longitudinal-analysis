


/* Lecture 8. Modeling the Mean: Parametric Curves */

data smoke;
     infile 'smoking-data.txt';
     input id smoker time fev1;
***************************************************;
*   Create additional copy of time variable       *;
***************************************************;
	t=time;
	/*t will be used as a categorical variable to indicate repeated measurement in covariance model*/
	/* time will be used as a continuous variable in mean model */
run;

 

title1 Linear Trend Model for FEV1 data (REML);
proc mixed data=smoke; 
     class id t;
     model fev1 = smoker time smoker*time / s chisq;
     repeated t / type=un subject=id;
run;



 

 
/*Linear Trend Model (ML Estimation)*/
title1 Linear Trend Model for FEV1 data (ML);
proc mixed data=smoke method=ml; 
     class id t;
     model fev1 = smoker time smoker*time / s chisq;
     repeated t / type=un subject=id;
run;

/*Quadratic Trend Model (ML Estimation)*/
title1 Quadratic Trend Model for FEV1 data (ML);
proc mixed data=smoke method=ml; 
     class id t;
     model fev1 = smoker time time*time smoker*time smoker*time*time / s chisq;
     repeated t / type=un subject=id;
run;



 

 
/*Treatment of Lead Exposed Children (TLC) Trial*/
/*Piecewise Linear Model (REML Estimation)*/
/* Load TLC explicitly so no earlier lecture must be run first. */
data lead;
     infile 'tlc-data.txt';
     input id group $ lead0 lead1 lead4 lead6;
run;

data tlc;
     set lead;
     y=lead0; time=0; output;
     y=lead1; time=1; output;
     y=lead4; time=4; output;
     y=lead6; time=6; output;
     drop lead0 lead1 lead4 lead6;
run;

data tlc;
     set tlc;
***************************************************;
*   Create additional copy of time variable   *;
***************************************************;
	t=time;
	time_1=max(time-1, 0);
	succimer=(group='A');
run;

title1 Piecewise Linear Model with knot at Time = 1;
title2 Treatment of Lead Exposed Children (TLC) Trial;
proc mixed data=tlc; 
     class id t;
     model y = time time_1 succimer*time succimer*time_1 / s chisq;
     repeated t / type=un subject=id ;
run;


