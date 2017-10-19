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
	if DoseDate lt '10JAN1998'd and DoseDate < '21DEC1997'd
	then DoseLot = 'S0576';
	if DoseDate le '10JAN1998'd and DoseDate <= '10JAN1998'd
	then DoseLot = 'P1122';
	if DoseDate > '10JAN1998'd 
	then DoseLot = 'P0526';
	if DoseDate = .
	then DoseLot = .;
	
	if DoseLot = 'P0526' then do;  
	prot_amend = 'B';
	else prot_amend = 'A' and Limit = 0.02;
	
	if Sex = 'Female' then do;
	Limit = 0.03;
	else Limit = 0.02;
run;

proc format;
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
