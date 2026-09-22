


/* Lecture 11. Prediction in Mixed Effects Models */
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


/*linear mixed effects model with random intercept and slope*/
 proc mixed data = exercise;
	class id group;
	model y=group time time*group /s chisq outp=exer_pred;
	/*outp=exer_pred: output a SAS dataset named "exer_pred" 
		containing the predicted mean responses */
	/* Match the random-intercept/random-slope model on Lecture 11, slide 15. */
	random intercept time / type=un subject=id G solution;
	/* type=un specifies unstructured G matrix */
	/* G request the G matrix */
	/* solution (or s) solves for random effects */
run;


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
 proc mixed data = fat;
	class id;
	model fat=time time_p /s chisq outp=mit_pred;
	random intercept time time_p/ type=un subject=id G s;
	/* type=un specifies unstructured G matrix */
	/* G request the G matrix */
	/* solution (or s) solves for random effects */
run;

