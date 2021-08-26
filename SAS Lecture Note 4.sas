*SAS Lecture Note 4-Enhancing Procedures and Output;

*Our first example illustrates how to use the TITLE, FOOTNOTE statement to enhance
 our SAS procedure;

DATA Oildata;
INPUT type $ visc state $;
        LABEL type='oil type';
        LABEL visc='viscosity'; *When a LABEL statement is used in a DATA step, the 
                                 lables becomes part of the dataset. If LABEL is used
                                 in the PROC step, then the labels stay in effect only 
                                 for the duration of that step;
        CARDS;  
   Cnvntnl 44 CA
   Cnvntnl 49 CA
   Cnvntnl 37 IL
   Synthet 52 NY
   Synthet 57 OH
   Hybrid  60 NC
   Hybrid  58 NY
   Hybrid  78 TX
   ;
PROC PRINT DATA = oildata;
  TITLE "Peter's oil data";
    *If you find that your title contains an apostrophe, use double quotation marks 
     around the title;
  FOOTNOTE 'the above data are generated randomly for drill purpose';
    *The FOOTNOTE command works in the same way as TITLE, but prints at the bottom of 
     the page. Usually it makes more sense to put TITLE or FOOTNOTE at the PROC step; 
RUN;

*Titles and footnotes stay in effect till you replace them with new ones or cancel them 
 completely. To cancel them, simply type TITLE followed by a semicolon. In addition, 
 when you specify a new title or footnote, it replaces the old title or footnote with 
 the same number and cancels those with a higher number. For example, a new TITLE2
 cancels an existing TITLE3 if there is one;

*-------------------------;

DATA Artists;
  INFILE 'C:\Users\tgao4\Desktop\Artists.dat';
  INPUT Name $ 1-21 Genre $ 23-40 Origin $ 42;
PROC PRINT DATA = Artists;
  WHERE Genre = 'Impressionism';
    *THE WHERE statement tells a procedure to use a subset of the data. The difference
     between WHERE and IF statement is that IF works in the DATA steps while WHERE works
     in the PROC steps. This basically means that using WHERE statement will not create
     a new dataset because it's executed in the PROC part. The general form of command 
     is WHERE conditions. For example, WHERE rainfall>20. Another example, WHERE Region
     IS NOT MISSING;
  TITLE 'Major Impressionist Painters';
  FOOTNOTE 'F = France, N = Netherlands, U = US';
RUN;

*Compare the above program with the following program, c.f. p.102;

DATA Artists;
  INFILE 'C:\Users\tgao4\Desktop\Artists.dat';
  INPUT Name $ 1-21 Genre $ 23-40 Origin $ 42;
  IF Genre = 'Impressionism';
PROC PRINT DATA = Artists;
  TITLE 'Major Impressionist Painters';
  FOOTNOTE 'F = France, N = Netherlands, U = US';
RUN;

*-------------------------;

*We now learn how to sort data. The basic form of sorting is PROC SORT followed by a 
 semicolon. Then from the second line, we write BY variable_1 variable_2...variable_n.
 You can specify as many BY variables as you wish. With more than one variable, SAS sorts 
 observations by the first variable, then by the second within categories of the first, 
 and so on;

*The DATA= and OUT=options specifies the input and output datasets. If you don't specify
 the DATA=option, then SAS will use the most recently created dataset. If you don't 
 specify the OUT=option, then SAS will replace the original dataset with the newly sorted 
 version. e.g. PROC SORT DATA = messy OUT = neat NODUPKEY. The NODUPKEY options tells SAS
 to eliminate any duplicate observations that have the same values for the BY variables.
 Also, by default, SAS sorts data in ascending order, from lowest to highest or from A to
 Z. To have your data sorted from highest to lowest, simply add the keyword DESCENDING to 
 the BY statement before each variable that should be sorted from highest to lowest. e.g.
 BY state DESCENDING City;

DATA marine;
  INPUT Name $ Family $ Length;
  CARDS;
humpback whale 50 
beluga   whale 15 
sperm    whale 60
basking  shark 30 
gray     whale . 
blue     whale 100
killer   whale 30
mako     shark 12 
; 
RUN; *Note that we have a missing value here at gray-whale-.;
PROC SORT DATA=marine OUT=seasort;
  BY DESCENDING Length;
RUN;
PROC PRINT DATA = seasort;
  TITLE 'Whales and Sharks Data';
  FOOTNOTE 'the OUT=option writes the sorted data into anew dataset called seasort';
RUN; *Note that missing value is put before the smallest length;

*-------------------------;

*The next example shows some features of PRINT procedure. So naturally, the following 
 statements are often used frequently under PROC PRINT DATA = dataset_name.--1) BY 
 variable_list. 2) ID variable_list. 3) SUM variable_list. 4) VAR variable_list. The BY
 statement starts a new section in the output for each new value of the BY variables
 and prints the values of the BY variables at the top of each section. The data must be
 pre-sorted first by the BY variables. The ID statement aims to print the data so that 
 the observation numbers are not printed out explicitly. Instead, the variables in the 
 ID variable list appear on the left-hand side of the page. The SUM statement prints sums 
 for the variables in the list. The VAR statement specifies which variables to be printed
 out in order. Without a VAR statement, SAS will print out all variables in the dataset 
 in order;

DATA sales;
  INFILE 'C:\Users\tgao4\Desktop\Candy.dat';
  INPUT Name $ 1-11 Class @15 DateReturned MMDDYY10. CandyType $ Quantity;
  Profit = Quantity*1.25;
PROC SORT DATA = sales;
  BY Class;
PROC PRINT DATA = sales; *The sorted dataset sales will obliterate the previous dataset;
  BY Class;
  SUM Profit; *You just add up Profits across observations;
  VAR Name DateReturned CandyType Profit;
  TITLE 'Candy Sales for Field Trip by Class';
RUN;

*Compare the above program with the following one. Pay special attention to the VAR and ID 
 statements;

DATA sales;
  INFILE 'C:\Users\tgao4\Desktop\Candy.dat';
  INPUT Name $ 1-11 Class @15 DateReturned MMDDYY10. CandyType $ Quantity;
    *@15 here says to go to the 15th column, so the 16th column will start reading the 
     variable DateReturned;
  Profit = Quantity*1.25; *we are creating a new variable called Profit;
PROC SORT DATA = sales;
  BY Class;
PROC PRINT DATA = sales;
  BY Class;
  SUM Profit;
  VAR DateReturned CandyType Profit;
  ID Name;
  TITLE 'Candy Sales for Field Trip by Class';
RUN;

*-------------------------;

*We now learn how to use the FORMATS to print values. The general forms of a SAS format
 are 1) $formatw. 2) formatw.d 3) formatw. Just like informats, don't forget the period!;

*The FORMAT statement starts with a word FORMAT followed by the variable name or a list of
 variables. The FORMAT statement can either go in DATA or PROC steps. If the FORMAT 
 statement is in DATA step then the format association is permanently stored with the 
 dataset. If it's in PROC step, then it is temporary--affecting only the results from that
 procedure, c.f. pp. 108-111;

DATA formatted_sales;
  INFILE 'C:\Users\tgao4\Desktop\Candy.dat';
  INPUT Name $ 1-11 Class @15 DateReturned MMDDYY10. CandyType $ Quantity;
  Profit = Quantity*1.25; 
PROC PRINT DATA = formatted_sales;
  VAR Name DateReturned CandyType Profit;
  FORMAT DateReturned DATE9. Profit DOLLAR6.2; 
    *The DATE9. is a format which says the variable can be converted into the standard 
     date format while the data reads 9 columns wide;
    *The format DOLLAR6.2 has width 6 because including the dollar sign and decimal point, 
     there are 6 columns used, and 2 decimal places;
  TITLE 'Candy Sales Using Formats';
RUN;

*-------------------------;

*There is also a way to create self-defined formats by PROC FORMAT, c.f. Section 4.7-4.8.
 The FORMAT procedure creates self-defined formats using PROC FORMAT and print the formatted
 texts instead of the coded values. The general form of the FORMAT command is given by:
   PROC FORMAT
     VALUE format_name 
       range_1 = 'formatted_text_1'
       range_2 = 'formatted_text_2'
       ...
       range_s = 'formatted_text_s'
   RUN
 The format_name in the VALUE statement is the name of the format you are creating. If the 
 format is for character data, the name must start with a $. It must not start or end with
 a number, and cannot contain any special characters except the underscore. Each range is 
 the value of a variable that is assigned to the text given in quotation marks on the right 
 side of the equal sign. Here is an example:
   'A' = 'Asia'
   1,3,5,7,9 = 'Odd'
   5000-High = 'Not Affordable'
   13-20 = 'Teens'
   OTHERS = 'Bad Data'
 Note that character values must be enclosed in quotation marks ('A' for example). If there 
 is more than one value in the range, then separate the values with a comma or use the
 hyphen (-) for a continuous range. The OTHER keyword can be used to assign a format to any
 values not listed in the VALUE statement;

DATA carsurvey;
  INFILE 'C:\Users\tgao4\Desktop\Cars.dat';
  INPUT Age Sex Income Color $; *Only the variable Color is categorical here;
PROC FORMAT;
  VALUE fmgender 1 = 'Male'
                 2 = 'Female';
  VALUE fmagegroup 13 -< 20 = 'Teen'
                   20 -< 65 = 'Adult'
                   65 - HIGH = 'Senior'; *Note that -< cannot be replaced by <= here!;
  VALUE $fmcol 'W' = 'Moon White'
               'B' = 'Sky Blue'
               'Y' = 'Sunburst Yellow'
               'G' = 'Rain Cloud Gray';
PROC PRINT DATA = carsurvey;
  FORMAT Sex fmgender. Age fmagegroup. Color $fmcol. Income DOLLAR8.;
    *Note that the format names do not end with periods in the VALUE statement, but they do
     in the FORMAT statement!;
  TITLE 'Survey Results with User-defined Format';
RUN;

*-------------------------;

*Reference: Little SAS Chapter 4.1-4.8;

