/*

Programming Assignment I

Names: Joshua Song
Hassan Ahmed


*/
data Study;
	infile "/courses/dc4508e5ba27fe300/c_629/suppTRP-1062.txt" dsd missover;
	input Site		: 	       $1.	
      	Pt			: 	       $2.
      	Sex			: 		8.
      	Race		        : 	 	8.
      	Height		        : 	        8.
      	Weight		        : 	        8.
      	Result1		        : 	        8.
      	Result2		        : 	        8.
      	Result3		        : 	        8.
      	;
format DoseDate date9.;
run;

proc DoseLot;
      if DoseDate = 1997 then DoseLot = 'S0576';
      if DoseDate = 1998 or > '10Jan1998' then DoseLot = 'P1122';
      if DoseDate > '10Jan1998' then DoseLot = 'P0526';
run;

proc prot_amend 
proc Limit;
      if DoseLot = 'P0526' then prot_amend = 'B';
      if Limit = 0.03 then prot_amend = 'A';
      if Limit = 0.02 then prot_amend = 'P0526';
      if DoseLot = 'S0576' and 'P1122' then Limit = '0.02';
run;


proc format;
     value site_name  'J' = 'Aurora Health Associates'
		'Q' = 'Omaha Medical Center'
	        'R' =  'Sherwin Heights Healthcare'; 

     value Sex 2 = 'Male'
		1 = 'Female';

     value Race 1 = 'Asian'
		        2 = 'Black'
		        3 = 'Caucausian'
		        4 = 'Other';
run;

proc print data=Study;
	/*var Site Pt Sex Race DoseDate Height Weight Result1 Result2 Result3;
	@Hassan: Your code above there is nothing wrong but it was lacking the requeired variables. I improved it by adding 
	all 14 variables. I added them so we can all show that we have all 14 variables we used. Ms. Flavin approved of this. 
	*/
	var Study Site Pt DoseDate Sex Race Height Weight Result1 Result2 Result3 prot_amend Limit site_name;
	format Sex sex.
		   site_name site_name.
		   Race Race.
		   DoseDate date9.;
run;
