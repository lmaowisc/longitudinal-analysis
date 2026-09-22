


/* HW1. Analysis of the National Cooperative Gallstone Study (NCGS)*/

/* read in the data */
data cholesterol;
     infile 'cholesterol-data.txt';
     input group id y1 y2 y3 y4 y5; 
run;



/*descriptive statistics */
proc means data=cholesterol n mean std var;
	var y1-y5;
	class group;
	output out=cholmean mean=mean1-mean5; 
	/*variables mean1-mean5 contain the means for y1-y5, respectively*/
run;

/*wide to long */
data chol_long;
	set cholesterol;
	y=y1; time=0;output;
	y=y2; time=6;output;
	y=y3; time=12;output;
	y=y4; time=20;output;
	y=y5; time=24;output;
	drop y1-y5;
run;

/*compute the means to be used in time plot */
proc means data=chol_long nway;
	var y;
	class group time;
	output out=cholmean mean=chol; 
run;

/* mean plot */
goptions reset = all;
   symbol1 value=circle color=black interpol = join;
   symbol2 value=triangle color=red interpol = join;
   axis1 order =(0 to 24 by 6) label=(h=2 'Time (months)'); /*h=2: make font size bigger*/
   axis2 order =(220 to 260 by 10) label = (h=2 angle=90 'Serum cholesterol (mg/dL)');
	legend label=none value=(h=2 'Chenodiol' 'Placebo') /* an informative legend*/
       position=(bottom right inside);
title1 h=2.5 Mean Serum cholesterol over time by treatment group;
proc gplot data=cholmean; 
   plot chol*time=group / haxis = axis1 vaxis = axis2 legend=legend1;
run;
title1; 

proc mixed data = chol_long;
	class id group (ref = "2") time (ref="0");
	model y = group time group*time/s chisq;
	repeated time /type = un subject = id r rcorr; 
	/*r and rcorr requests the residual (error) covariance and 
	  correlation matrices, respectively */
run;


