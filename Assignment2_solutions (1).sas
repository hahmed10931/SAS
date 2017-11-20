/* Assignment2.sas */
/*
1-6 - Create the data set STUDY using your corrected code for Assignment 1.
*/

/*
7 -  DEMOG1062 is a permanent SAS data set located on the server in the directory /courses/u_ucsd.edu1/i_536036/c_629/saslib

Create a new data set called PAT_INFO by merging STUDY and DEMOG1062 by their two common variables. 
Also add items in 8-12 to PAT_INFO. 
Note: Your code should create a single data set called PAT_INFO, which contains the merge code and items 8-12. 
PAT_INFO should contain 15 observations and 21 variables.
*/
libname class "/courses/dc4508e5ba27fe300/c_629/saslib" access=readonly;

proc sort data=study;
  by site pt;
run; 

proc sort data=class.demog1062 out=demog;
  by site pt;
run;

data pat_info;
  merge study demog;
  by site pt;

/*
8 - Create a variable called pt_id by concatenating Site and Pt and adding a hyphen between the two variables. 
An example value of pt_id should look like: Z-99. Label the variable 'Site-Patient'.
*/
/* Comments: cats function can also be replaced with cat or catx('-',site,pt) */

  if not missing(site) and not missing(pt) then 
  pt_id=cats(site,'-',pt); 

/*  
9 - Use 1 statement to create a variable dose_qtr by concatenating the letter 'Q' to the number which corresponds to the quarter of the year in which the dose date falls. 
Values of dose_qtr should look like Q1, Q2, etc. 
*/

  if not missing(dosedate) then dose_qtr=cats('Q',qtr(dosedate));

/*
10 - Create a variable mean_result which is the mean of result1, result2, and result3. 
The mean should be calculated using all non-missing values of the three variables. 
Format mean_result to 2 decimal places.
*/

  if nmiss(of result1-result3) < 3 then mean_result=mean(of result1-result3);

/*
11 - Create a variable BMI which is calculated as:  Weight ÷ (Height)2 x 703
Format BMI to 1 decimal place.
*/

  if nmiss(weight,height)=0 and height ne 0 then 
  BMI=weight*703/(height**2);

/*
12 - Create a variable est_end which is the Estimated Termination Date for the patient. 
Use an assignment statement. Do not use a function.

If Protocol Amendment is A then est_end is 120 days after Dose Date.
If Protocol Amendment is B then est_end is 90 days after Dose Date.
Apply a format so that the est_end is displayed as mm/dd/yyyy.
Label the variable 'Estimated Termination Date'.
*/
  /* option 1: use if-then statements */
  if prot_amend='A' then est_end=dosedate+120;
  else if prot_amend='B' then est_end=dosedate+90;
  /* option 2: use select statement */
  select(prot_amend);
    when ('A') est_end=dosedate+120;
    when ('B') est_end=dosedate+90;
    otherwise;
  end;

  label pt_id='Site-Patient' 
        est_end='Estimated Termination Date';

  format mean_result 8.2 bmi 4.1 est_end mmddyy10.;
run;

/*
13 - Using the data set PAT_INFO, generate the following output using PROC PRINT:
*/
/* comment: There are two ways to prevent the datetime and page numbers at the top of the output window 
   from interfering with your output.
   (1) use options nodate nonumber; - this turns off these options
   (2) use title2 or title3 to move your output below the datetime and page numbers */

options nodate nonumber;
title3 Listing of Baseline Patient Information for Patients Having Weight > 250 ;
proc print data=pat_info double split='*';
  where weight > 250; 
  by site site_name;
  id site site_name;
  var pt age sex race height weight dosedate doselot;
  label age='Age' 
        dosedate='Date of*First Dose'
		doselot='Dose Lot Number';
  format dosedate mmddyy.;
run;

/* turn off title */
title;

/*
14 - Use the data set PAT_INFO and one PROC MEANS to do the following:
Create output stratified by Sex for the variables Result1, Result2, Result3, Height, and Weight. 
The display should show the number of non-missing values, mean, standard error, minimum value, maximum value and be formatted to one decimal point.
Also create an output data set that contains the median value of Weight stratified by Sex. 
Name the variable that contains the median value of weight med_wt. 
Your output data set should contain two observations and two variables, Sex and med_wt.
*/
/*
15 - Combine the data sets PAT_INFO and the output data set from item 14 by the variable Sex and create a new variable called wt_cat as follows:

If the patient's weight is less than or equal to the median weight for all patients of that sex, then wt_cat=1.
If the patient's weight is more than the median weight for all patients of that sex, then wt_cat=2.

Label this variable 'Median Weight Category'.

Create and apply a descriptive format to wt_cat: 
For wt_cat=1, the descriptor is '<= Median Weight'
For wt_cat=2, the descriptor is '> Median Weight'
Hint: Your new data set should contain 15 observations.
*/
/* There are 2 solutions to 14 & 15 */

/* Option 1 - use a CLASS statement */

/* Item 14 */

proc means data=pat_info n mean stderr min max maxdec=1 nway;
  class sex;
  var result1-result3 height weight; 
  output out=med_wt_class(drop = _:) median(weight)=med_wt;
run;

/* Note: If the variables on the var statement are re-ordered, the output statement can be simplified as follows:

proc means data=pat_info n mean stderr min max maxdec=1 nway;
  class sex;
  var weight result1-result3 height; 
  output out=med_wt_class(drop = _:) median=med_wt;
run;

*/

/* Item 15 */

proc format;
  value wt_cat
    1 = '<= Median Weight'
	2 = '> Median Weight'
	  ;
run;

proc sort data=pat_info;
  by sex;
run;

data pat_info_class;
  merge pat_info med_wt_class;
  by sex;
  if . < weight <= med_wt then wt_cat=1;
  else if weight > med_wt then wt_cat=2;
  format wt_cat wt_cat.;
  label wt_cat='Median Weight Category';
run;

/* Option 2 - use a BY statement */

/* Item 14 */

proc sort data=pat_info;
  by sex;
run;

proc means data=pat_info n mean stderr min max maxdec=1;
  by sex;
  var result1-result3 height weight; 
  output out=med_wt_by(drop = _:) median(weight)=med_wt;
run;

/* Item 15 */

proc format;
  value wt_cat
    1 = '<= Median Weight'
	2 = '> Median Weight'
	  ;
 run;

data pat_info_by;
  merge pat_info med_wt_by;
  by sex;
  if . < weight <= med_wt then wt_cat=1;
  else if weight > med_wt then wt_cat=2;
  format wt_cat wt_cat.;
  label wt_cat='Median Weight Category';
run;

/*                                                                                        
16 - Using your data set from Item 15 and one PROC FREQ to do the following:
Show the frequency distributions of (1) Dose Lot Numbers and (2) Median Weight Category. Exclude missing values from the frequency distributions.
Generate a two-way table for Race by Weight. Include missing values in the frequency distribution. 
Use formats to group Race and Weight variables as follows:
If Race is Caucasian then display the race as 'White'.
If Race is anything else (including missing) then display the race as 'Other'.
Group Weight into the following 4 categories: < 200, 200 to < 300, >= 300, Missing 
*/

proc format;
  value races
    other ='Other' 3='White';
  value wt
    .        = 'Missing'
    low-<200 = '<200'
    200-<300 = '200-<300'
    300-high = '>=300'; 
run;

proc freq data=pat_info_by;
  tables doselot wt_cat;
  tables race*weight / missing;
  format race races. weight wt.;
run;

/*
17 - Using your data set from Item 15 and one PROC UNIVARIATE to do the following:
Generate summary statistics for Height stratified by Median Weight Category. 
Identify the extreme values using the Site-Patient identifier variable.
*/
/* Note: Either a BY statement or a CLASS statement can be used. 
   However, using CLASS eliminates the need to sort the data. */

proc univariate data=pat_info_by;
 class wt_cat;
 var height; 
 id pt_id;
run;
