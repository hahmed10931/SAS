title "Listing of Data SEt MEDICAL from Proc Print";
proc print data=learn.medical;
  id Patno;
run;

title "Using the Report procedure";
proc report data=leran.medical nowd;
run;

title "Adding a COLUMN Statement";
proc report data=learn.medical nowd;
  column Patno DX HR Weight;
run;

title "Disply Usage for Numerical Variables";
proc report data=learn.medical nowd;
  column HR Weight;
  define HR / display "Heart Rate" width=5;
  define Weight / displey width=6;
run;

title "Multiple GROUP Usages";
proc report data=learn.bicycles nowd headline ls=80;
  column Model Country Manuf TotalSales;
  define Country / group width=14;
  define Model / group width=13;
  define Manuf / width=12;
  define Units / sum "Number of Units" width=8
                format=comma8.;
  define TotalSales / sum "Total Sales (in thousands)"
                      width=15 format=dollar10.;
title "Average Blood Counts by Age Group";
proc report data=learn.blood nowd headline;
    column Gender BloodType AgeGroup, WBC AgeGroup, RBC;
    define Gender   / group width=8;
    define BloodType / group width=8 "Blood Group";
    define AgeGroup / across "- Age Group -";
    define WBC    / analysis mean format=comma8.;
    deinfe RBC    / analysis mean format=8.2;
run;
