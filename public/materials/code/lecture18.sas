

/* Lecture 18. Contrasting GEE and GLMM*/



/* Read in the leprosy trial data*/
data leprosy;
     infile 'leprosy-data.txt';
     input drug $ y1 y2;
		id+1;
		A=0;
		B=0;
		if drug='A' then A=1;
		if drug='B' then B=1;
run;

data leprosy;
     set leprosy;
     y=y1; time=0; output;
     y=y2; time=1; output;
	 keep id  A B y time drug;
run;

data leprosy;
     set leprosy;
     visit=time;
run;



/* Plot the mean counts for the leprosy trial data*/
proc means data=leprosy n mean nway; 
   var y;
   class drug time; 
   output out=lep_mean mean=mean;  
run;

goptions reset = all;
   symbol1 value=circle color=black interpol = join;
   symbol2 value=triangle color=red interpol = join;
	symbol3 value=square color=blue interpol = join;
   axis1 order =(0 to 1 by 1) label=('Follow-up');
   axis2 order =(5 to 14 by 3) label = (angle=90 'Mean count of leprosy bacilli');
   legend1  label=none value=(h=1.5 'A' 'B' 'C') position=(bottom right inside);
title1 Pre- and Post-Treatment Mean Count of Leprosy Bacilli by Treatment Group;
proc gplot data=lep_mean; 
   plot mean*time=drug / haxis = axis1 vaxis = axis2 legend=legend1;
run;
title1; 



/* GEE log-linear model for leprosy trial data*/ 
proc genmod data=leprosy;
     class id visit;
     model y= A B time A*time B*time / dist=poisson link=log;
     repeated subject=id /within=visit  type=ind modelse;
	 /* modelse: requests variance estimates based on the specified Poisson model
	 	with independent covariance structure*/
	 /* The modelse option is used here only to get an estimate */
	 contrast 'Drug x Time Interaction' A*time 1, B*time 1/wald;
	 /* use wald option to request the wald test; otherwise it give score test */
	 /* The score test and wald test are equivalent in large samples*/
run;



 /* GLMM poisson model for leprosy trial data*/ 
proc glimmix data=leprosy method=quad(qpoints=50);
     class id ;
     model y= A B time A*time B*time / dist=poisson link=log s chisq;
	random intercept /subject=id;
	 contrast 'Drug x Time Interaction' A*time 1, B*time 1/chisq;
run;


 /* GLMM negative binomial model for leprosy trial data*/ 
proc glimmix data=leprosy method=quad(qpoints=50);
     class id ;
     model y= A B time A*time B*time / dist=negbinomial link=log s chisq;
	 /*dist=negbinomial for negative binomial (NB) regression*/
	 /* Variance function of the NB: mu+k*mu^2, where k is the scale
	 	parameter estimated in the "Covariance Parameter Estimates" table*/
	random intercept /subject=id;
	 contrast 'Drug x Time Interaction' A*time 1, B*time 1/chisq;
run;





/*Read in data from the Crossover Trial on Cerebrovascular Deficiency*/ 
data ecg;
     infile 'ecg-data.txt';
     input id seq period trt y;
run;



/*Marginal Models for the Crossover Trial on Cerebrovascular Deficiency*/
title1 Marginal Logistic Regression Model;
title2 Crossover Trial on Cerebrovascular Deficiency;

proc genmod data=ecg descending;
     class id;
     model y = trt period / dist=binomial link=logit;
     repeated subject=id / type=ind;
run;
/*
Mixed Effects Logistic Regression Model (Random Intercept)
*/
title1 Mixed Effects Logistic Regression Model (Random Intercept);
title2 Crossover Trial on Cerebrovascular Deficiency;

proc glimmix data=ecg method=quad(qpoints=50);
     class id;
     model y(event='1') = trt period / dist=binomial link=logit solution;
     random intercept / subject=id g;     
run;


