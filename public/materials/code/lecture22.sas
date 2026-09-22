

/* Lecture 22. Multilevel models*/


/* read in the tbsfp data */
data tvandcc;
	infile "tvsfp-data.txt";
	/*Variable List: 
School ID, Class ID, School-based Resistance Curriculum (1=yes,0=no)
Television-based Prevention Program (1=yes,0=no),
Pre-interventions THKS score, Post-interventions THKS score.*/
	input sid cid cc tv baseline THKS;
run;




proc mixed data=tvandcc COVTEST;
/*The covtest option tests the covariance parameters;
note that the test is not entirely rigorous for variances,
whose values cannot be negative*/
	class sid cid;
	model thks = baseline cc tv cc*tv / S;
	random INTERCEPT / SUBJECT=sid G;/*School-level random intercept*/
	random INTERCEPT / SUBJECT=cid G;/*Class-level random intercept*/
RUN;



