

/* Lecture 13. Residual analysis and model diagnostics*/

/* read in the MIT Growth and Development data**/
data fat;
     infile 'fat-data.txt';
	/* Variable List: 
	 Subject ID, Current Age (years), Age at Menarche (years), 
		Time relative to Menarche (years), Percent Body Fat.*/
     input id age menarche_age time fat;
run;

/* create the positive part of time */
data fat;
     set fat;
	 time_p=max(0, time);
run;


/*linear mixed effects "broken-stick" model for MIT 
	Growth and Development study */
ods graphics on;
 proc mixed data = fat;
	class id;
	model fat=time time_p /s chisq vciry outpm=mit_pred1;
		/* vciry: residual plots for the Cholesky-transformed residuals */
		/* outpm= output Cholesky-transformed residuals to a SAS dataset*/
	random intercept time time_p/ type=un subject=id G;
run;
ods graphics off;

/* plot smoothed (lowess) curve for residual vs time */
ods graphics on;
proc sgplot data=mit_pred1 noautolegend;
   title 'Transformed residual vs time';
   loess y=ScaledResid x=time;
   /* y: dependent variable; x: independent variable*/
run;
ods graphics off;


/* Refit the model with a quadratic term for post-menarche time */
ods graphics on;
 proc mixed data = fat;
	class id;
	model fat=time time_p time_p*time_p/s chisq vciry outpm=mit_pred2;
		/* vciry: residual plots for the Cholesky-transformed residuals */
		/* outpm= output Cholesky-transformed residuals to a SAS dataset*/
	random intercept time time_p/ type=un subject=id G;
	contrast "Test on difference in change pattern before and after event" time_p 1, time_p*time_p 1/chisq;
run;
ods graphics off;


/* plot smoothed (lowess) curve for residual vs time */
ods graphics on;
proc sgplot data=mit_pred2 noautolegend;
   title 'Transformed residual vs time for the post-event quadratic model';
   loess y=ScaledResid x=time;
run;
ods graphics off;
title '';
