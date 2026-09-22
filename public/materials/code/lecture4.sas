


/* Lecture 4. Single-group analysis of trend */


/* read in the TLC data */
data lead;
     infile 'tlc-data.txt';
     input id group $ lead0 lead1 lead4 lead6; 
	 /*the $ sign indicates that group is a character variable*/
run;
 

/* subset to the treatment for single-group trend analysis */
/* wide to long */
data succimer;
    set lead;
	where group="A";
    y=lead0; time=0; output;
    y=lead1; time=1; output;
    y=lead4; time=4; output;
    y=lead6; time=6; output;
    drop lead0 lead1 lead4 lead6;
run;



/* using proc mixed for trend analysis */
proc mixed data=succimer;
	/* SAS automatically uses the last level as reference */ 
	/* class id time(ref="0"); */ 
	class id time;
	model y = time /S CHISQ; /*The model statement is similar to proc glm*/
	/* S requests analysis of regression coefficients*/
	/* CHISQ requests chisq tests */
	 repeated time /TYPE=UN SUBJECT=id;
	/* time: the repeated measures variable */
	/* subject=id: the clustering variable */
	/* type=un: unstructured covariance matrix */
	contrast "Week 6 - Week 0" time -1 0 0 1 / CHISQ;
	/*contrast the means between week 6 and baseline; request the chisq test */
run;



/*compare with classicial one-way ANOVA by proc glm*/
proc glm data=succimer;
	class time;
	model y = time /solution;
	estimate "Week 6 - Week 0" time -1 0 0 1;
run;
/*produces same results as the previous proc mixed procedure without the `repeated' statement */


