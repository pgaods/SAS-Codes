*SAS Lecture Note 3-Data and Variables;

*The book Little SAS provides datasets and code from the following address:
 http://support.sas.com/publishing/bbu/61860/index.html;
 
*Since working on citrix can be tricky when it comes to the infile statement, we
 can do the following steps to ensure that SAS identifies the dataset successfully:
   1) Go onto the website http://support.sas.com/publishing/bbu/61860/index.html.
   2) Download the data (from Chapter 3 in this lecture note).
   3) A zipfile will show up. Now find the dataset "Garden.dat", right-click on it, 
      and click the option "View with Notepad".
   4) Once the notepad is opened, one can see what the data looks like. Now save the 
      file on the desktop of the citrix. Then the path of the data will be given by
      C:\Users\tgao4\Desktop\Garden.dat
   5) To back up the data, one can save the data in the flashdrive after executing 
      the exercises
  ;

*Now our first goal is to learn how to create variables in SAS. To do this exercise, 
 we first find a dataset called "Garden" with three input variables. Then our goal is 
 to create another 4 variables called "Zone", "Type", "Total" and "Pertom". We are now 
 about to create a new dataset called "homegarden" by using the original datset "Garden" 
 with the new variables to be created;

DATA homegarden;
  INFILE 'C:\Users\tgao4\Desktop\Garden.dat';
  INPUT Name $ 1-7 Tomato Zucchini Peas Grapes; 
  Zone = 14; *Here we define the new variable "Zone" to equal 14;
  Type = 'home'; *Here we define the new variable "Type" to be called "home";
  Zucchini = Zucchini*10; 
        *Here we define the new variable Zucchini to equal Zucchini*10. If you look at 
         the output window, the variable Zucchini appears only once. This is because 
         the new value replaced the old value. So here we learned a new rule about SAS: 
         when a variable already exists, SAS replaces the original value and erases the 
         old one. Using an existing name has the advantage of not cluttering your dataset 
         with a lot of similar variables. However, you don't want to overwrite a variable 
         unless you're really sure you won't need the original again;
  Total = (Tomato + Zucchini + Peas + Grapes);
  Pertom = (Tomato/Total)*100;
PROC PRINT DATA = homegarden;
  TITLE 'Home Garden Survey';
RUN;

*----------------------------------------------------------;

*The next example shows how to use built-in SAS functions to create new variables;

DATA contest;
   INFILE 'C:\Users\tgao4\Desktop\Pumpkin.dat';
   INPUT Name $16. Age 3. +1 Type $1. +1 Date MMDDYY10.
         (Scr1 Scr2 Scr3 Scr4 Scr5) (4.1);
		  *The variable "Name" has an informat of $16, meaning that it is a 
		   character variable and is 16 columns wide. The variable "Age" has 
		   an informat of 3, meaning that it is numeric, three columns wide, 
		   with no decimal places. The +1 here means skiping over one column.
		   The variable "Type" is a character with one column wide. The 
                   variable "Date" has an informat MMDDYY10., and reads dates in the 
                   form of 10-31-2003 or 10/31/2003, each 10 columns wide. The remaining 
                   variables Scr1 to Scr5 all have the same informat, 4.1. Here 4 means 
                   4 columns wide and 1 means 1 decimal place. In general, w.d reads the 
                   standard numeric data specifying the variable has w-width and 
                   d-decimal places. Note that the width includes all digits numbers, 
                   including decimals, so if one wants to read the data "345.87", the 
                   informat of the data would be 5.2. For more information about
                   informat, c.f. pp. 40-45. Also for informat, don't forget the period 
                   at the end of the informat!;             
   AvgScore = MEAN(Scr1, Scr2, Scr3, Scr4, Scr5);
     *The variable "AvgScore" is obtained by using the MEAN function, which returns the 
      mean of the non-missing arguments. This differs from simply adding the arguments 
      together and dividing by their number, which would return a missing value if any 
      of the arguments were missing;
   DayEntered = DAY(Date); *The function DATE() returns the day of the month;
   Type = UPCASE(Type); *The variable Type is transformed using the function UPCASE().
                         SAS is only case-sensitive when it comes to variable value. The
                         dataset has both lowercase and uppercase letters for the variable 
                         Type, so the function UPCASE() is used to make all the values 
                         writen in uppercase;
   Logscr5 = LOG(Scr5); *This function takes logs with e-based elementwise;
   Logscr5_10 = LOG10(Scr5); *log with 10-base;
   Summation = SUM(Scr1, Scr2); *This does the summation elementwise;
PROC PRINT DATA = contest;
   TITLE 'Pumpkin Carving Contest';
RUN; *A list of functions in SAS can be found on pp.80-81;

*----------------------------------------------------------;

*We will now learn how to use the IF-THEN statement to achieve variable creations, missing
 data imputation, data selections, data groupings and subsetting;
*The IF-THEN statemnent has the following format: IF condition THEN action. For example, 
 IF x = 'Mustang' THEN y = 1. Another example, IF x = 0.3, THEN y = 'Ford'. The terms on 
 either side of the comparison may be numbers, variables, or expressions;

DATA sportscars; *This program will demonstrates how to use the logic statement to create 
                  a new variable called Status and to fill in missing data;
  INFILE 'C:\Users\tgao4\Desktop\UsedCars.dat';
  INPUT Model $ Year Make $ Seats Color $;
  IF Year < 1975 THEN Status = 'classic'; 
    *This defines a new variable called Status in such a way that if Year is less than the
     year 1975, we classify the variable as classic;                                                                               
  IF Model = 'Corvette' OR Model = 'Camaro' THEN Make = 'Chevy';
    *This says when the model is either Corvette or Camaro, we classify the Make variable 
     as Chevy;
  IF Model = 'Miata' THEN DO;
     Make = 'Mazda';
     Seats = 2;
  END; *This whole 'IF...THEN DO...END' statement says if the Model = Miata, then we set 
        Make = Mazada, and Seats to be 2. Basically we are doing missing data imputation;
PROC PRINT DATA = sportscars;
  TITLE 'Cars Classification Data';
RUN;

*----------------------------------------------------------;

*One of the most common uses of IF-THEN statement is for grouping observations. The basic 
 command is IF...THEN..ELSE IF...THEN...ELSE IF...THEN......ELSE. Our goal of the next 
 exercise is to group observations by cost; 

DATA homeimprovements;
  INFILE 'C:\Users\tgao4\Desktop\Home.dat';
  INPUT Owner $ 1-7 Description $ 9-33 Cost;
  IF Cost =. THEN Classification = 'missing';
     ELSE IF Cost < 2000 THEN Classification = 'low';
     ELSE IF Cost < 10000 AND Cost > 2000 THEN Classification = 'medium';
     ELSE  Classification = 'high';
       *The whole statement means the following: if there is missing data on the variable
	Cost, then we classify it as missing. Otherwise, if Cost < 2000, we classify it as
	low. Otherwise, if Cost is between 2000 and 10000, we label it as medium. Otherwise,
	we label it as high. Note that without the first statement, observations with a 
	missing value for Cost would be incorrectly assigned a Classification of low.  This 
        is because SAS considers msising values to be smaller than non-missing values, 
	smaller than any printable character for character variables, and smaller than 
	negative numbers for numeric variables;
PROC PRINT DATA = homeimprovements;
  TITLE 'Home Improvement Cost Groups';
RUN;

*------------------------------------------------------------;

*Often programmers want to use some observations in a dataset and exclude the rest. The 
 most common way to achieve this is with a subsetting IF statement in a DATA step. The 
 basic forms of a subsetting IF are given by the following 2 equivalent commands:
 1) IF expression
 2) IF not_expression THEN DELETE
 Both of the two statements need to be ended with a semicolon of course;

DATA Scomedies;
  INFILE 'C:\Users\tgao4\Desktop\Shakespeare.dat';
  INPUT Title $ 1-26 Year Type $;
  IF Type = 'comedy';
PROC PRINT DATA = Scomedies;
  TITLE 'Shakespearean Comedies';
RUN;

DATA Scomedies;
  INFILE 'C:\Users\tgao4\Desktop\Shakespeare.dat';
  INPUT Title $ 1-26 Year Type $;
  IF Type = 'tragedy' OR Type = 'romance' OR Type = 'history' THEN DELETE;
PROC PRINT DATA = Scomedies;
  TITLE 'Shakespearean Comedies';
RUN; * The above two sets of programs give you the same result;

*--------------------------------------------------------------;

*We now learn how to work with the dates in SAS. A SAS date is a numeric value equal to
 the number of days since January 1st, 1960. So basically, the real date Jan 1st, 1959 
 is read -365 in SAS. The real date Jan 1st, 1961 is read 366 in SAS, etc. SAS has special
 tools for working with dates: 1) informats for reading dates, functions for manipulating
 dates, and formats for printing dates. c.f. Section 3.8;

*To read variables that are dates, we need to use the informats. When SAS sees a date with 
 a two-digit year like 07/04/78, SAS has to decide in which century the year belongs. The 
 system option YEARCUTOFF= specifies the first year of a hundred-year span for SAS to use. 
 The default value for this option is 1920, but you can change this value  with an OPTIONS 
 statement, c.f. pp.88-89;

*Once a variable has been read with a SAS date informat, it can be used in arithmetic 
 expressions like other numeric variables. For example, if a library book is due in three
 weeks, you could find the due date by adding 21 days to the date it was checked out, so 
 programwise, we write Duedate = DateCheckout + 21;

*We can also use a date as a constant in a SAS expression by adding quotation marks and a 
 letter D. For example, if we type Earthday05 = '22APR2005'D, we are basically creating
 a variable named Earthday05, which is equal to the SAS date value for April 22nd, 2005;

*For more information about date functions and formats, see pp.88-89;

*--------------------------------------------------------------;

*We now learn how to use the RETAIN and sum statement to preserve variables from previous
 data steps. This is a hard example! Check the output window!;

DATA gamestats;
  INFILE 'C:\Users\tgao4\Desktop\Games.dat';
  INPUT Month 1 Day 3-4 Team $ 6-25 Hits 27-28 Runs 30-31;
  RETAIN MaxRuns;
     *We use the retain statement when we want to preserve a variable's value from previous
      iteration of the DATA step. The RETAIN statement can appear anywhere in the DATA 
      step and has the folowing form, where all variables to be retained are listed after
      the RETAIN keyword--RETAIN variable_list;
     *Of course we can specify an initial value, so our command becomes the following--
      RETAIN variable_list initial_value;
  MaxRuns = MAX(MaxRuns, Runs);
     *The variable MaxRuns is set equal to the maximum of its value from the previous
      iteration of the DATA step (since it appears in the RETAIN statement) or the value of 
      the variable Runs. The variable Runstodate (defined below) adds the number of runs;
  Runstodate + Runs;
     *A sum statement also retains values from the previous iteration of the DATA step, but
      when you use it, you are cumulatively adding the value of an expression to a variable.
      A sum statement contains no keywords. It has the following form--variable + expression
      (this statement basically adds the value of the expression to the variable while 
      retaining the variable's value from one iteration of the DATA step to the next. The 
      variable has to be numeric and has the initial value of zero;
PROC PRINT DATA = gamestats;
  TITLE 'Games statistics';
RUN;

*--------------------------------------------------------------;

*We now learn how to use the ARRAY statement to group variables for simplicity. For example,
 sometimes one may wants to take the log of every numeric variable or change every 
 occurance of zero to a missing value. One could write a series of assignment statements to 
 exert on each variable. But if there are lots of variables for transformation, then using 
 arrays will greatly simplify the program. An array is an ordered group of variables. In 
 command, we type ARRAY array_name (n) variable_list. Here the array_name is the name given 
 to the group of variables. n is the number of variables in the array;

DATA songs;
  INFILE 'C:\Users\tgao4\Desktop\WBRK.dat';
  INPUT City $ 1-15 Age domk wj hwow simbh kt aomm libm tr filp ttr;
  ARRAY song (10) domk wj hwow simbh kt aomm libm tr filp ttr;
  DO i = 1 TO 10;
    IF song(i) = 9 THEN song(i) = .;
       *The Do statement is excuted 10 times. This is a loop. So the computer is basically
        doing i = 1,2,3...10 for each i, and then execute the IF-THEN statement;
  END;
PROC PRINT DATA = songs;
  TITLE 'WBRK Song Survey';
RUN;

*--------------------------------------------------------------;

*Reference: Little SAS Chapter 3.1-3.10;


