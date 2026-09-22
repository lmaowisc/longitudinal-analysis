

/* Lecture 15. Marginal Models: Generalized Estimating Equations */

/* read in the toenail data**/
data toenail;
     infile 'toenail-data.txt';
/*
Variable List: Subject ID, Response (0=none or mild, 1=moderate or severe), 
Treatment (0=Itraconazole, 1=Terbinafine), Month, Visit.
*/
     input id y treatment month visit;
run;




/* Analysis of toenail data*/
data toenail;
	set toenail;
	int=round(month);
	month_d=int;
	if int=4 then month_d=3;
	else if int in (5, 7) then month_d=6;
	else if int in (8, 10) then month_d=9;
	else if int>=11 then month_d=12;
	drop int;
run;

proc means data=toenail n mean nway; 
   var y;
   class treatment month_d; 
   output out=ony_mean mean=prop;  
run;

goptions reset = all;
   symbol1 value=circle color=black interpol = join;
   symbol2 value=triangle color=red interpol = join;
   axis1 order =(0 to 12 by 3) label=('Time (in Months)');
   axis2 order =(0 to 0.4 by 0.05) label = (angle=90 'Proportion with Onycholysis');

title1 Proportion with Onycholysis by Treatment Group;
title2 Oral Treatment of Toenail Infection Trial;
proc gplot data=ony_mean; 
   plot prop*month_d=treatment / haxis = axis1 vaxis = axis2;
run;
title1; title2;


/* Logistic regression for toenail study data */
proc genmod data=toenail descending;
	class id visit;
	model y=month treatment treatment*month/dist=binomial link=logit;
	repeated subject=id/within=visit type=un;
run;






proc genmod data=toenail descending;
	class id visit;
	model y=month treatment*month/dist=binomial link=logit;
	repeated  subject=id /within=visit type=ind;
run;




