

/* Lecture 3. Descriptive and Graphical Analysis Using SAS.
   Set the SAS working directory to the folder containing tlc-data.txt. */



/* read in the data */
data lead;
     infile 'tlc-data.txt';
     input id group $ lead0 lead1 lead4 lead6; 
	 /*the $ sign indicates that group is a character variable*/
run;
 



/* Some summary statistics */

proc means data=lead n mean std; 
   var lead0 lead1 lead4 lead6;
   class group;  
run;



/* sort the data by group */
proc sort data=lead;
	by group;
run;



/* correlation matrix*/
ods graphics on;
title1 Subsample (N=50) of data on Blood Lead Levels from the Succimer Group;
title2 Treatment of Lead Exposed Children (TLC) Trial;
proc corr data=lead plots=matrix;
     var lead0 lead1 lead4 lead6;
     /*where group='A';*/
	 by group;
run;
ods graphics off;
title1;title2;






/* wide to long */
data tlc;
    set lead;/* for each record in "lead", output multiple records to tlc*/
    y=lead0; time=0; output;
    y=lead1; time=1; output;
    y=lead4; time=4; output;
    y=lead6; time=6; output;
    drop lead0 lead1 lead4 lead6;
run;
/* print the first 10 records of the newly created long dataset: tlc*/
proc print data=tlc(obs=10);
run;



/*create the treatment subset*/
data succimer;
   set tlc;
   if (group = 'A');
run;
 
proc sort; 
   by id time;
run;

 

/* reset all gplot options */
goptions reset = all;

/*Use proc gplot to produce time plots */
   symbol1 value=circle color=black interpol = join repeat=50;
   axis1 order =(0 to 6 by 1) label=('Time (in Weeks)');
   axis2 order =(0 to 70 by 10) label = (angle=90 'Blood Lead Levels (mcg/dL)');
title1 Time Plot, with Joined Line Segments, of Blood Lead Levels in the Succimer Group;
title2 Treatment of Lead Exposed Children (TLC) Trial;

proc gplot data = succimer;
   plot y*time = id / haxis = axis1 vaxis = axis2 nolegend;
run;

 

proc means data=tlc n mean nway; 
   var y;
   class time group; 
   output out=leadmean mean=mean;  
run;

goptions reset = all;
   symbol1 value=circle color=black interpol = join;
   symbol2 value=triangle color=red interpol = join;
   axis1 order =(0 to 6 by 1) label=('Time (in Weeks)');
   axis2 order =(10 to 30 by 5) label = (angle=90 'Blood Lead Levels (mcg/dL)');

title1 Time Plot of Mean Blood Lead Levels in the Placebo and Succimer Groups;
title2 Treatment of Lead Exposed Children (TLC) Trial;
proc gplot data=leadmean; 
   plot mean*time=group / haxis = axis1 vaxis = axis2;
run;
title1; title2;
 

