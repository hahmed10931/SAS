title "Demonstarting a GROUP Usage";
proc report data=learn.medical nowd;
  column Clinic HR Weight;
  define Clinic / group width=11;
  define Weight / analysis mean "Average Heart Rate" width=12
                  format=5.;
  define Weight / analysis mean "Average Weight" width=12
                  format=6.;
run;
