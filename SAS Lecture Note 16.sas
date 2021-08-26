*SAS Lecture Note 16-Debugging;

*To avoid bugs in SAS, it's always wise to print the data from time to time after the DATA step to avoid writing out 
 the wrong data. If you are reading data from a file, you can use the OBS= option statement in the INFILE statement
 to tell SAS to stop reading when it gets to that line in teh file. This way you can read only the first 50 or 100 
 lines of data or however many it takes to get a good representation of your data. You can also use the other trick 
 FIRSTOBS= option to start reading from the middle of hte data file. So for example, if the first 100 data lines are 
 not a good representation of your data but 101 thru 200 are, you can use the following statement to read just those 
 lines from 101 thru 200:
   INFILE 'Mydata.Dat' FIRSTOBS = 101 OBS = 200
 In addition, you can put the FIRSTOBS= option and OBS= option in the SET/MERGE/UPDATE statement. Here are some good
 examples drawn from previous lectures:

DATA train;
  INFILE '\\sscwin\dfsroot\users\tgao4\Desktop\train.dat';
  INPUT Time TIME5. Cars People;
RUN;

DATA modifiedtrains1;
  SET train;
  PeoplePerCar = People/Cars;

DATA modifiedtrains2;
  SET train (FIRSTOBS=2 OBS=6);
  PeoplePerCar = People/Cars;

PROC PRINT DATA = modifiedtrains1 STYLE(DATA) = {BACKGROUND = GREEN};
  TITLE 'Average Number of People per Train Car1';
  FORMAT Time TIME5.;
RUN; 

PROC PRINT DATA = modifiedtrains2 STYLE(DATA) = {BACKGROUND = BLUE};
  TITLE 'Average Number of People per Train Car2';
  FORMAT Time TIME5.;
RUN; 

*---------------------------------;

*Also, be careful with the semicolons and naming each dataset. To avoid confusing SAS when naming datasets in each
 DATA step, one is always suggested to put this command at the beginning of all the programs:
 OPTIONS DATASTMTCHK = ALLKEYWORDS
 ;

*---------------------------------;

*We now start discussing possible errors in SAS logs. The first common error is something called 'lost card'. A 
 lost card means that SAS was expecting another line of data and did not find it. If you are reading multiple lines 
 of data for each observation, then a lost card could mean that you have missing or duplicate lines of data;

*---------------------------------;

*The second common error is something called invalid data. This note appears whne SAS is unable to read from a raw 
 data file because the data are inconsistent with the INPUT statement. 

*---------------------------------;

*The third common error is related to missing values. Pay close to attention to missing value problems. Even though
 sometimes they are not errors, they may create troubles. Note also that the SUM() and MEAN() functions use only the
 non-missing values in the dataset. So in order to try to detect missing values, it's always recommended to use the 
 PROC MEAN to find the number of missing values. To kick out those missing values. One only needs to do a subset IF
 statement, for example:
   IF Average = .
 ;

*---------------------------------;

*The fourth common error is the wrong conversion problem, that is, sometimes we accidentally converted numeric values
 to character (or vice versa). Of course, when this happens, one can go back tot he DATA step and correct such a 
 problem. Yet sometimes it's just not practical. Instead you can convert the variables from one type to another. For
 example, to convert variables from character to numeric, you can use the INPUT() function. To convert from numeric 
 to character, you may use the PUT() function in the assignment statement. Here are three examples:
   newvar_name1 = INPUT(oldvar_name1, informat)
   newvar_name2 = PUT(oldvar_name2, informat)
   score = INPUT(Score, 2.)
 ;


*---------------------------------;

*Reference: Little SAS Chapter 10.1-10.14;
