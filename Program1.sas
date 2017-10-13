/*
Programming Assignment I
Name: Joshua Song
*/
data Study;
infile '/courses/dc4508e5ba27fe300/c_6269/suppTRP-1062.txt' missover;
input Site 1.	
	Pt $2.
	  Sex $8.
	  Race $8.
	  Dosedate mmddyy8.
	  Height 8.
	  Weight 8.
	  Result1 8.
	  Result2 8.
	  Result3 8.;
	if DoseDate = '1997' then DoseLot = 'S0576';
	if DoseDate = '1998' or > '10 January 1998' then DoseLot = 'P1122';
	if DoseDate > '10 January 1998' then DoseLot = 'P0526';
	if DoesDate = ' ' then DoesLot = 'Missing';
	if DoesLot = 'P0526' then prot_amend = 'B';
	if Limit = 0.03 
	else prot_amend = 'A';
	if Limit = 0.02 then prot_amend = 'P0526';
	if DoesLot = 'S0576' and 'P1122' then Limit = '0.02';
	if DoesLot = 'Missing' then prot_amend = 'Missing' and Limit = 'Missing';
proc format;
	value Site 'J' = 'Aurora Health Associates'
			   'Q' = 'Omaha Medical Center'
			   'R' =  'Sherwin Heights Healthcare'
	; 
	value $Sex '2' = 'Male'
			   '1' = 'Female'
	;
	value $Race '1' = 'Asian'
				'2' = 'Black'
				'3' = 'Caucausian'
				'4' = 'Other'	
	;
	value names   Site = 'Site'.	
				  Pt =  'Patient'
				  Sex = 'Patient Sex'
				  Race = 'Patient Race'
				  Dosedate = 'Dose Date'
				  prot_amend = 'Protocol Amendment'
				  Limit = 'Lower Limit of Detection'
				  site_name = 'Site Name';
run;
