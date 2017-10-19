/*
Programming Assignment I
Names: Hassan Ahmed
Hugh Murray
Joshua Song
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
	
	if DoseDate lt '31DEC1997'd then DoseLot = 'S0576';
	if DoseDate le '10JAN1998'd and DoseDate gt '31DEC1997'd then DoseLot = 'P1122';
	if DoseDate gt '10JAN1998'd then DoseLot = 'P0526';
	if DoseDate = . then DoseLot = .;

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
	
	length site_name $30.;
	select (Site);
	when ('J') site_name = 'Aurora Health Associates';
	when ('R') site_name = 'Sherwin Heights Healthcare';
	end;
run;

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
