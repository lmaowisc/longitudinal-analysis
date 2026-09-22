

/* Lecture 23. Special Topic: Repeated Measures Designs*/

/* Read in the headache trial data*/
data headache;
     infile 'headache-data.txt';
	 /*Variable List: 
ID, Center, Treatment Sequence (1-6), Period (0,1), 
Treatment (P,A,B), Response (Pain relief).*/
     input id center seq period trt $ y;
run;


/* summary statistics by sequence and period*/
proc means data=headache n mean std; 
   var y;
   class seq period;  
run;


/*create dummy variables for treatments A and B,
	carryout effects of A and B*/
data headache_new;
    set headache;
	A=(trt='A');
	B=(trt='B');
	CO_A=(seq in (2,6))*period;
	/*CO_A=1 if (sequence is 2 or 6) and in second period*/
	CO_B=(seq in (1,4))*period;
	/*CO_B=1 if (sequence is 1 or 4) and in second period*/
	keep id y A B period CO_A CO_B;
run;



proc mixed data=headache_new;
	model y=A B period CO_A CO_B/s;
	random intercept/ subject=id G;
	/*Use the compound symmetry covariance stucture
		by including a random intercept*/
	estimate "Difference between A and B" A 1 B -1;
	/*Testing the treatment effect comparing A and B*/
	contrast "Carry-over effects" CO_A 1, CO_B 1/chisq;
	/*Testing whether the carry-over effects are significant*/
run;


