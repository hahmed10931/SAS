/* Name: Joshua Song
	Hassan Ahmed
	Sanchit
*/
/* /* Assignment1.sas */
 
proc format;
  value sex 
    1=Female 
    2=Male
     ;
  value race 
    1=Asian 
    2=Black 
    3=Caucasian 
    4=Other
     ;
run;

/*
Create a SAS data set called STUDY as follows:
1 - Read in the data in suppTRP-1062.txt.
Create the variable Site with length of 1.
Create the variable Pt as character of length 2.
All other variables should be created as numeric with the default length of 8.
*/

data study;
  /* on infile statement need (1) dsd or dlm=',' (2) missover or truncover */
  infile '/courses/dc4508e5ba27fe300/c_629/suppTRP-1062.txt' dlm=',' missover;

  /* Method 1: use informat and input statements */
  /* informat can be either mmddyy8. or mmddyy10. */
  informat Site $1. Pt $2. Dosedate mmddyy10.;
  input Site Pt Sex Race Dosedate Height Weight Result1 Result2 Result3;

  /* Method 2: use an input statement - any of these will work */
  * input Site:$1. Pt:$2. Sex:8. Race:8. Dosedate:mmddyy10. Height:8. Weight:8. Result1-Result3:8.;
  * input Site:$1. Pt:$2. Sex Race Dosedate:mmddyy10. Height Weight Result1-Result3;

/*
2 - Using if-then statements, create a new variable called Doselot (Dose Lot).
If the dose date is in 1997, then the dose lot is S0576. 
If the dose date is in 1998 and on or before 10 January 1998, then the dose lot is P1122. 
If the dose date is after 10 January 1998, then the dose lot is P0526. 
*/
  
  if '01JAN1997'd <= dosedate <= '31DEC1997'd then doselot='S0576';
  else if '31DEC1997'd < dosedate <= '10JAN1998'd then doselot='P1122';
  else if dosedate > '10JAN1998'd then doselot='P0526';

/*
3 - Using two do loops, create two new variables called prot_amend (Protocol Amendment) and 
Limit (Lower Limit of Detection).
If the dose lot is P0526 then the Protocol Amendment is B.
For all other dose lots, the Protocol Amendment is A.
The Lower Limit of Detection is 0.03 for female patients who received dose lot P0526.
The Lower Limit of Detection is 0.02 for male patients who received dose lot P0526.
The Lower Limit of Detection is 0.02 for patients who received dose lots S0576 and P1122.
*/

  if doselot='P0526' then do;
    prot_amend='B';
    if sex=1 then limit=0.03;
    else if sex=2 then limit=0.02;
  end;
  else if doselot = 'S0576' or doselot='P1122' then do;
    prot_amend='A';
    limit=0.02;
  end;

/*
4 - Using a select statement, use the variable Site to create a new variable called site_name (Site Name) which contains the name of the Study Site.
The Site values and associated names are:
J=Aurora Health Associates, Q=Omaha Medical Center, R=Sherwin Heights Healthcare
*/

length site_name $30;
  select(site);
    when ('J') site_name='Aurora Health Associates';
    when ('Q') site_name='Omaha Medical Center';
    when ('R') site_name='Sherwin Heights Healthcare';
    otherwise;
  end;

/* 
5 - Create and apply formats to the Sex and Race variables.
The decodes for sex are 1=Female, 2=Male
The decodes for race are 1=Asian, 2=Black, 3=Caucasian, 4=Other
*/

  format sex sex. race race. dosedate date.;

/*
6 - Using the descriptive information provided previously, create labels for these variables:
 
Site, Pt, Dosedate, Doselot, prot_amend, Limit, site_name
*/

  label site='Study Site' 
        pt='Patient'
        dosedate='Dose Date'
        doselot='Dose Lot'
        prot_amend='Protocol Amendment'
        limit='Lower Limit of Detection'
        site_name='Site Name';
run;
/* Some parts are incomplete. I will explain the location of missing code */
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


	

/*Part 8*/
data Site_pt;
	set Site pt;
run;
data pat_info;
	infile '/courses/dc4508e5ba27fe300/c_629/saslib';
	/*The infile is the location in which DEMOG1062 is located*/
	/* IDK if this is correct (The way I have it) but I have it as reference */
	/* Concatinate Study and DEMOG1062*/
	informat prot_amend = mmddyy10.;
	/*Variables*/
	input prot_amend, est_end, BMI;
	
/* Part 9:  ??? 
Using 2 functions (one function will be embedded within the other) to create a 
variable dose_qtr by concatenating the letter ‘Q’ to the number which 
corresponds to the quarter of the year in which the dose date falls.
Values of dose_qtr should look like Q1, Q2, etc. 
If the dose date is missing then dose_qtr should be missing.
Use 1 programming statement for this item.*/
	if dose_date = missing then dose_qtr = missing;
	

/*Part 10: Mean*/
	data Pat_info;
	mean_result = round(mean(result1+result2+result3, 0.01)); 
	run;
/* Part 11: BMI Formula*/
	BMI = round((Weight / ((Height)**2) * 703, 0.1);
	run;
/* Part 12: ??? */ 
  	if prot_amend = 'A' then do;
  		est_end = 120;
  	if prot_amend = 'B' then do;
  		est_end = 90;
  	end;
  	label est_end = 'Estimated Termination Date';
run;  	
/* Part 13: ??? */
proc print data=pat_info;
title "Listing of Baseline Patient Information for Patients Having Weight > 250";
var SiteName Patient Age Sex Race Height Weight DoseDate DoseLot;
label site_name = "Site Name"
		pt = "Patient"
		age = "Age"
		sex = "Sex"
		race = "Race"
		height = "Height"
		weight = "Weight"
		dosedate = "Date of First Dose"
		doselot = "Dose Lot Number";
run;
/* Part 14: ??? */
proc means data=pat_info;
/* Variables to be used: sex result1 result2 result3 height weight */
run;
/* Part 15: ??? */
data wt_cat;
	for wt_cat = 1 the descriptor is <= 'Median Weight'
	for wt_cat = 2 the descriptor is > 'Median Weight'; 
run;
/* Part 16: ??? */
proc freq data=pat_info;
	format race two.;
	if race = 'Caucasian' then race = 'White'
	else then race = 'Other';
run;
/* Part 17: ??? */
proc univariate data=wt_cat;
/* May be incorrect. Consider correcting this */
/* Add code here */
run;
