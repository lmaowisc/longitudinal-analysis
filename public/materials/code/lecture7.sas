


/* Lecture 7. More on analysis of response profiles */


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


/* create dummy variables group and time */
data tlc;
     set tlc;
	succimer=(group='A');
	w0=(time=0);/*this dummy variable will NOT be used because baseline will be the reference*/
	w1=(time=1);
	w4=(time=4);
	w6=(time=6);
run;



/* using proc mixed for response profile analysis */
/* single df contrasts*/
/*dummy coding: X2=succimer, X3=w1, X4=w4, X5=w6*/
proc mixed data=tlc;
	class id  time;
	model y=succimer w1 w4 w6 succimer*w1 succimer*w4 succimer*w6/S chisq;
	repeated time /TYPE=UN SUBJECT=id;
	contrast "Overall (3-DF) test of interaction" succimer*w1 1, succimer*w4 1, succimer*w6 1/chisq;
	estimate "pre- and post-treatment" succimer*w1 1 succimer*w4 1 succimer*w6 1/divisor=3;
	estimate "diff in AUC" succimer*w1 4 succimer*w4 5 succimer*w6 2/divisor=12;
run;



/* create response difference from baseline */
data lead_diff;
	set lead;
	lead1_d=lead1-lead0;
	lead4_d=lead4-lead0;
	lead6_d=lead6-lead0;
run;
/*wide to long */
data tlc_diff;
    set lead_diff;
    y=lead1; yd=lead1_d; time=1; output;
    y=lead4; yd=lead4_d; time=4; output;
    y=lead6; yd=lead6_d; time=6; output;
    drop lead1 lead4 lead6 lead1_d lead4_d lead6_d;
run;

/* create dummy variables for time occasion */
data tlc_diff;
    set tlc_diff;
	succimer=(group='A');
	w1=(time=1);/*this dummy variable will NOT be used because baseline will be the reference*/
	w4=(time=4);
	w6=(time=6);
run;


/* analysis of mean response change profiles */
/* dummy coding: Y^*=yd, X2=succimer, X3=w4, X4=w6*/
proc mixed data=tlc_diff;
	class id time;
	model yd = succimer w4 w6 succimer*w4 succimer*w6/S chisq;
	repeated time /TYPE=UN SUBJECT=id;
	contrast "Overall (3-DF) test of main effect and interaction" succimer 1, succimer*w4 1, succimer*w6 1/chisq;
run;


/* analysis of mean response profiles with baseline adjusted as covariate */
proc mixed data=tlc_diff;
	class id time;
	model y = succimer w4 w6 succimer*w4 succimer*w6 lead0/S chisq;
	repeated time /TYPE=UN SUBJECT=id;
	contrast "Overall (3-DF) test of main effect and interaction" succimer 1, succimer*w4 1, succimer*w6 1/chisq;
run;
