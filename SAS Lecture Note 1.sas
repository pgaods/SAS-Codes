*SAS Lecture Note 1-Basics of SAS;

PROC OPTIONS; *The OPTIONS statement is part of a SAS program and affects 
               all steps that follow it. It starts with the keyword OPTIONS 
               and follows with a list of options and their values. The 
               OPTIONS statement does not belong to either PROC or DATA 
               steps. This global statement can appear anywhere in your SAS 
               program,but it usualy makes sense if we can put it at the 
               beginning of the program. Any subsequent OPTIONS statements 
               in a program override previous ones;
RUN;

*---------------;

PROC PRINT DATA=Pgzsas.coffee;
  *To use this command, we first need to enter the data into the data editor. 
   Then we save the table in the library created, called Pgzsas, and we call 
   this dataset "coffee" (library_name.dataset_name);
RUN;

*---------------;

DATA Presidents; 
     *This program illustrates how we can type raw data directly in the SAS 
      program so that the data can be considered internal raw data. Here we 
      are creating a raw dataset called Presidents in the Work Library;
   INPUT President $ Party $ Number; 
     *The INPUT statement defines the variables of the dataset, namely President, 
      Party and Number. The dollar sign after each variable tells SAS that 
      Presidents and Party are categorical (as opposed to numerical) in nature. 
      The CARDS statement below (some people use DATALINES) tells SAS that our 
      data is internal. The CARDS statemnt must be the last statement in the 
      DATA step. All lines in the program following the CARDS are considered data 
      until SAS encounters a semicolon;
  CARDS;
Adams   F 2
Lincoln R 16
Grant   R 18
Kennedy D 35
  ;
RUN; 
    *After we run this program, we can basically open the Work Library in the 
     Explorer Window to see the data;

PROC PRINT DATA = Presidents;
  TITLE 'SAS Dataset President';
RUN;

*----------------;

DATA Presidents; 
     *This command tells SAS to read an external dataset called "President" 
      from C-disk with the input variables Presdient, Party and Number;
  INFILE 'C:\Users\tgao4\Documents\Presidents.sas7bdat' LRECL=2000;
     *The LRECL command here basically tells SAS this is a long dataset so as 
      to read all of them (2000); 
  INPUT President $ Party $ Number;
RUN;
    *For more information about reading raw data, check the handbook "little 
     SAS" pp.38-73;

*---------------;

*The following two examples illustrate the difference between temporary and 
 permanent SAS datasets;

DATA distance; *Here the dataset called "distance" is from the Work Library;
  Miles = 26.22;
  Kilometers = 1.61 * Miles;
PROC PRINT DATA = distance;
RUN; 

DATA pgzsas.distance; 
    *Here the dataset "distance" is from the Library Pgzsas, of course we need 
     to create this library first before using all of the command in this program;
  Miles = 26.22;
  Kilometers = 1.61*Miles;
PROC PRINT DATA = Pgzsas.distance;
  Title 'Miles and Kilometers Example';
RUN; 

*---------------;

DATA funnies; 
      *This example illustrates how to use the 'CONTENTS' command to list the 
       contents of the SAS dataset, called funnies;
  INPUT Id Name $ Height Weight DoB Mmddyy8;
  LABEL Id = 'identification number'
    Height = 'height in inches'
    Weight = 'weight in inches'
    DoB    = 'date of birth'; 
                *The LABEL command allows you to document your variables in more 
                 detail and the descriptions will be stored in the dataset and will 
                 be printed by the PROC CONTENTS command;
  INFORMAT DoB Mmddyy8; *INFORMAT tells SAS to read a variable in certain ways;
  FORMAT DoB Workdate18; *FORMAT tells SAS to write a variable in certain ways;
  CARDS;
53 Susie   42 41 07-11-81
54 Charlie 46 55 10-26-54
55 Calvin  40 35 01-01-81
56 Lucy    46 52 01-13-55
;
PROC CONTENTS DATA = funnies;
RUN;

*--------------;


*Reference: Little SAS Chapter 1-2;
