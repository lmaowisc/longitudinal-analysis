

/* Lecture 14. Generalized linear models*/

/* read in the toenail and epilepsy data**/
data toenail;
     infile 'toenail-data.txt';
/*
Variable List: Subject ID, Response (0=none or mild, 1=moderate or severe), 
Treatment (0=Itraconazole, 1=Terbinafine), Month, Visit.
*/
     input id y treatment month visit;
run;


data epilepsy;
	  infile 'epilepsy-data.txt';
/*
Variable List:
Patient ID, Treatment (0=Placebo, 1=Progabide), Age, 
Baseline 8 week seizure count, First 2 week seizure count,
Second 2 week seizure count, Third 2 week seizure count,
Fourth 2 week seizure count.
*/
	       input id treatment age y0 y1 y2 y3 y4;
		   label 	y0="Y0 (8 weeks)"
					y1="Y1 (2 weeks)"
					y2="Y2 (2 weeks)"
					y3="Y3 (2 weeks)"
					y4="Y4 (2 weeks)"
;
run;


/* create baseline datasets */
data toenail_base;
	set toenail;
	where visit=1;
run;

data epilepsy_base;
	set epilepsy;
	drop y1-y4;
run;


/* Analysis of baseline data*/
/* Logistic regression for baseline toenail study data */
proc genmod data=toenail_base descending;
	model y=treatment/dist=binomial link=logit;
run;

/* Poisson regression for baseline epilepsy data */
proc genmod data=epilepsy_base; 
	model Y0=treatment age/dist=poisson link=log;
run;



