/*
Programming Assignment I
Names: Hassan Ahmed
Joshua Song
Sanchit Thakrar
*/

/*  Item#1 Reading in the data in suppTRP-1062.txt. */
data Study;
	infile "/courses/dc4508e5ba27fe300/c_629/suppTRP-1062.txt" dsd missover;
	input Site		: 	       $1.	
      	Pt			: 	       $2.
      	Sex			: 			8.
      	Race		: 	 		8.
      	DoseDate	:			mmddyy10.
      	Height		: 	        8.
      	Weight		: 	        8.
      	Result1		: 	        8.
      	Result2		: 	        8.
      	Result3		: 	        8.;
     format DoseDate date9.;
	
/*  Item#2 Creating a new variable called Doselot (Dose Lot).*/ 
	if DoseDate lt '31DEC1997'd then DoseLot = 'S0576';
	if DoseDate le '10JAN1998'd and DoseDate gt '31DEC1997'd then DoseLot = 'P1122';
	if DoseDate gt '10JAN1998'd then DoseLot = 'P0526';
	if DoseDate = . then DoseLot = .;

/* Item#3 Create two new variables called prot_amend (Protocol Amendment) and Limit (Lower Limit of Detection).*/
    if Doselot = 'P0526' then do;
	if Sex = '1'
	then Limit = 0.03;
	if Sex = '2'
	then Limit = 0.02;
	prot_amend = 'B';
    end;
	
	if Doselot = 'S0576' or Doselot = 'P1122' then do;
	prot_amend = 'A';
	Limit = 0.02;
	end;
	

/* Item#4 Creating a new variable called site_name (Site Name).*/
    length site_name $30.;
	select (Site);
	when ('J') site_name = 'Aurora Health Associates';
	when ('R') site_name = 'Sherwin Heights Healthcare';
	end;


/* Item#5 Creating and applying formats to the Sex and Race variables.*/
proc format;
     value Sex 	2 = 'Male'
				1 = 'Female';

     value Race 1 = 'Asian'
		        2 = 'Black'
		        3 = 'Caucausian'
		        4 = 'Other';
run;

proc print data=Study;
	var Site Pt Sex Race site_name prot_amend Limit DoseDate DoseLot Height Weight Result1 Result2 Result3;
	
	/*var Study Site Pt DoseDate Sex Race Height Weight Result1 Result2 Result3 prot_amend Limit site_name;
	*/
	format Sex 			Sex.
		   Race 		Race.
		   DoseDate 	date9.;
run;

/*  Item#6 Creating labels for these variables.*/
proc format; 
label Site = 'Study Site'
			Pt = 'Patient'
			DoseDate = 'Dose Date'
			DoseLot = 'Dose Lot'
			prot_amend = 'Protocol Amendment'
			Limit = 'Lower Limit of Detection'
			site_name = 'Site Name'
			;
run;

/* Item#7 Combine the data from above */
libname class '/courses/dc4508e5ba27fe300/c_629/saslib';
proc sort data = class.DEMOG1062 out = demog1062i; 
    by pt site;
run;

proc sort data = study;
    by pt site;
run;

data Pat_Info;
   merge study DEMOG1062i;
   by pt site;
run;

/*Item#8 Creating pt_id
data Pat_Info;
   length pt_id $ 15;
   if Pt = . or Site = . then pt_id = .;
   pt_id = catx('_','Site','Pt');
run; */

/*Part 10: Mean*/
	data Pat_info;
	mean_result = round(mean(result1+result2+result3, 0.01)); 
	run;
/* Part 11: BMI Formula
	BMI = round((Weight / ((Height)**2) * 703, 0.1);
	run;*/
	





   
