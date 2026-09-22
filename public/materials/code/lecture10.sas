


/* Lecture 10. Linear Mixed Effects Models */
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


/*linear mixed effects models with random intercept and slope*/
 proc mixed data = exercise;
	class id group;
	model y=group time time*group /s chisq;
	random intercept time / type=un subject=id G V Vcorr;
	/* type=un specifies unstructured G matrix */
	/* G request the G matrix */
	/* Can request overall covariance matrix \Sigma and corresponding
		covariance matrix by options V and Vcorr, respectively */
run;
