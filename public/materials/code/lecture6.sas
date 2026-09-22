


/* Lecture 6. Analysis of response profiles */


/* read in the TLC data */
data lead;
     infile 'tlc-data.txt';
     input id group $ lead0 lead1 lead4 lead6; 
	 /*the $ sign indicates that group is a character variable*/
run;
 

/* wide to long */
data tlc;
    set lead;
    y=lead0; time=0; output;
    y=lead1; time=1; output;
    y=lead4; time=4; output;
    y=lead6; time=6; output;
    drop lead0 lead1 lead4 lead6;
run;



/* using proc mixed for response profile analysis */
proc mixed data=tlc;
	/* SAS automatically uses the last level as reference */ 
	/* class id time(ref="0"); */ 
	class id group(ref="P") time(ref="0");
	model y = group time group*time/S CHISQ; /*The model statement is similar to proc glm*/
	/* S requests analysis of regression coefficients*/
	/* CHISQ requests chisq tests */
	 repeated time /TYPE=UN SUBJECT=id;
	/* time: the repeated measures variable */
	/* subject=id: the clustering variable */
	/* type=un: unstructured covariance matrix */
run;



