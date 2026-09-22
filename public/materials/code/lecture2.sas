

/* Lecture 2. Linear Regression, Maximum Likelihood, and ANOVA.
   Set the SAS working directory to the folder containing fev1_baseline.txt.
   This program uses baseline lung-function examples, not the tox.txt
   guinea-pig example shown in the historical slides. */


data base;
	infile 'fev1_baseline.txt'; /* a space delimited file */
	input id height  age x y logfev; /* formatted input */
	loght=log(height);
run;

proc print data=base;
run;



PROC GLM DATA=base;
	MODEL logfev = age;
RUN;


/*create a SAS dataset base_agecat,
with agecat=1, 2, 3 indicating three age groups;
x2, x3 dummy variables for the second and third group, respectively.
*/
data base_agecat;
	set base;
	x2=0;
	x3=0;
	if (age<=8) then age_cat=1;
		else if (age>8 and age<=9) then do;
			age_cat=2;
			x2=1;
		end;
		else do;
			age_cat=3;
			x3=1;
		end;
run;


/*Anova: height vs age_cat*/
PROC GLM DATA=base_agecat;
	class age_cat;
	MODEL height=age_cat;
RUN;

/*regression: height vs x2+x3*/
PROC GLM DATA=base_agecat;
	MODEL height=x2 x3;
RUN;




proc means data=base p25 p75;
	var age;
run;


