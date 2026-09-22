


/* Lecture 9. Modelling the Covariance */
data exercise;
     infile 'exercise-data.txt';
     input id group y0 y2 y4 y6 y8 y10 y12;
     y=y0; day=0; output;
     y=y4; day=4; output;
     y=y6; day=6; output;
     y=y8; day=8; output;
     y=y12; day=12; output;
     drop y0 y2 y4 y6 y8 y10 y12;
run;

data exercise;
     set exercise;
***************************************************;
*   Create additional copy of time variable   	  *;
***************************************************;
	time=day;
run;


title1 Unstructured covariance for strength data;
title2 Exercise Therapy Trial;
proc mixed data=exercise; 
     class id group time;
     model y = group time group*time / s chisq;
     repeated time / type=un subject=id r rcorr; /*request covariance and correlation estimates*/
run;



/* Autoregressive Covariance (REML Estimation)*/
title1 Autoregressive covariance for strength data;
title2 Exercise Therapy Trial;
proc mixed data=exercise; 
     class id group time;
     model y = group time group*time / s chisq;
     repeated time / type=ar(1) subject=id r rcorr;
run;



/* Exponential Covariance (REML Estimation)*/
title1 Exponential covariance for strength data;
title2 Exercise Therapy Trial;
proc mixed data=exercise; 
     class id group time;
     model y = group time group*time / s chisq;
     repeated time / type=sp(exp)(day) subject=id r rcorr;

run;



 
