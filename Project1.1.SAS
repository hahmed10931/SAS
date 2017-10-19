/*
Programming Assignment I
Names: Joshua Song
Hassan Ahmed
Hugh Murray
Sanchit Thakrar
*/
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
      	Result3		: 	        8.
      	;

	format DoseDate date9.;
	
	if DoseDate lt '31DEC1997'd then DoseLot = 'P0576';
	if DoseDate le '10JAN1998'd and DoseDate gt '31DEC1997'd then DoseLot = 'P1122';
	if DoseDate gt '10JAN1998'd then DoseLot = 'S0526';
	if DoseDate = . then DoseLot = .;
	/* Fix the P1122 part */

	if Doselot = 'P0526' then do;
	prot_amend = 'B';
	if Sex = 1
	then Limit = 0.03;
	if Sex = 2
	then Limit = 0.02;
	end;
	if Doselot = 'S0576' or Doselot = 'P1122' then do;
	prot_amend = 'A';
	Limit = 0.02;
	end;	
run;

proc format;
/*Fixing needed*/
     value site_name 'J' = 'Aurora Health Associates'
	                 'R' =  'Sherwin Heights Healthcare'; 

     value Sex 	2 = 'Male'
				1 = 'Female';

     value Race 1 = 'Asian'
		        2 = 'Black'
		        3 = 'Caucausian'
		        4 = 'Other';
run;
proc print data=Study;
	var Site Pt Sex Race DoseDate DoseLot Height Weight Result1 Result2 Result3;
	
	/*var Study Site Pt DoseDate Sex Race Height Weight Result1 Result2 Result3 prot_amend Limit site_name;
	*/
	format Sex 			Sex.
		   Race 		Race.
		   DoseDate 	date9.;
run;
