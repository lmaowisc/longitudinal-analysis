

/* Lecture 16. Case studies for marginal models*/

/* read in the arthritis data**/
data arthritis;
     infile 'arthritis-data.txt';
	 /*
Variable List:
ID, Treatment (0=placebo, 1=auranofin therapy), baseline age (years), Arthritis Categorical Scale month 0, Arthritis Categorical Scale month 2, 
Arthritis Categorical Scale month 4, Arthritis Categorical Scale month 6.
	 */
     input id trt age y1 y2 y3 y4;
run;

/*wide to long */
data arthritis;
     set arthritis;
     y=y1; month=0; output;
     y=y2; month=2; output;
     y=y3; month=4; output;
     y=y4; month=6; output;
	 drop y1-y4;
run;


/* Plot the mean score plot */
proc means data=arthritis n mean nway; 
   var y;
   class trt month; 
   output out=art_mean mean=avg_score;  
run;

goptions reset = all;
   symbol1 value=circle color=black interpol = join;
   symbol2 value=triangle color=red interpol = join;
   axis1 order =(0 to 6 by 2) label=('Time (months)');
   axis2 order =(1 to 5 by 1) label = (angle=90 'Arthritis Categorical Scale');
   legend1  label=none value=(h=1.5 'Placebo' 'Auranofin') position=(bottom right inside);
title1 Time Plot of Mean Scale in the Placebo and Auranofin Therapy Groups;
title2 Arthritis Trial;
proc gplot data=art_mean; 
   plot avg_score*month=trt / haxis = axis1 vaxis = axis2 legend=legend1;
run;
title1; title2;


data arthritis;
     set arthritis;
     if y=. then delete;
	 visit=month;
run;


/*GEE proportional odds analysis*/
proc genmod data=arthritis;
     class id visit;
     model y = trt month trt*month age/ dist=multinomial link=cumlogit;
	 /* dist=multinomial: specify the multinomial distribution
	 	link=cumlogit: cumulative logit link, giving rise to
	 	the proportional odds model
	 */
     repeated subject=id /within=visit type=ind;
run;



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



/* Plot the mean count plot */
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



/* GEE log-linear model*/ 
proc genmod data=leprosy;
     class id visit;
     model y= A B time A*time B*time / dist=poisson link=log;
     repeated subject=id /within=visit  type=ind;
	 contrast 'Drug x Time Interaction' A*time 1, B*time 1/wald;
	 /* use wald option to request the wald test; otherwise it give score test */
	 /* The score test and wald test are equivalent in large samples*/
run;



 
