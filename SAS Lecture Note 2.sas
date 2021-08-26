*SAS Lecture Note 2-Data Importation of SAS;

*The book Little SAS provides datasets and code from the following address:
 http://support.sas.com/publishing/bbu/61860/index.html;
*We now use datasets from Chapter 2;
 
*Since working on citrix can be tricky if we use infile statement, we can do the 
 following steps to ensure that SAS identifies the dataset successfully:
   1) Go onto the website http://support.sas.com/publishing/bbu/61860/index.html.
   2) Download the data (from Chapter 3 in this lecture note)
   3) A zipfile will show up. Now find the dataset "Garden.dat", right-click on 
      it, and click the option "View with Notepad"
   4) Once the notepad is opened, one can see what the data looks like. Now save 
      the file on the desktop of the citrix. Then the path of the data will be 
      given by C:\Users\tgao4\Desktop\Garden.dat
   5) To back up the data, one can save the data in the flashdrive after executing 
      the exercises
 ;

*In this lecture we study how we can import data into SAS. There are mainly three 
 styles of INPUT for data: 1) list style. 2) column style. 3) formatted Style;

*--------------------------------------------------------;

DATA toads; 
    *This is an example of the list style. To use this style, one needs to make 
     sure that 1) The values in the raw data file are all separated by at least 
     one space. 2) Any missing data must be indicated with a period. 3) For 
     character data, if present, they must be simple (no embedded spaces and no 
     values greater than eight characters in length. In addition, there is no data 
     in any date/time/any other special format. The list style is the easiest way
     to read the data but it's also very restricted in use;
  INFILE 'C:\Users\tgao4\Desktop\ToadJump.dat';
  INPUT ToadName $ Weight Jump1 Jump2 Jump3;
PROC PRINT DATA = toads;
    *If you look at the raw data, they are not well aligned. But this is ok! The
     list style will automatically read everything cleverly as long as the above
     criteria are met;
  TITLE 'Toad';
RUN;

DATA sales;
    *Some raw data files do not have spaces or other delimiters between all the 
     values or periods for missing data, so the files can't be read using list 
     input. But if each of the variable's values is always found in the same place 
     in the data line, then one can use the column input as long as all the values 
     are characters or standard numeric. Numbers with embedded commas or dates are 
     not deemed standard;
  INFILE 'C:\Users\tgao4\Desktop\OnionRing.dat';
  INPUT VisitingTeam $ 1-20 ConcessionSales 21-24 BleacherSales 25-28 OurHits 29-31
        TheirHits 32-34 OurRuns 35-37 TheirRuns 38-40;
     *The above command means that the first variable VisitingTeam is a categorical 
      variable ($) and they are contained in column 1 to column 20. The second 
      variable ConcessionSales are given in column 21-24 etc. Note that data with 
      street addresses are good candidates for column inputs. For example, Street 
      Martin Luther King Jr. Blvd should be read as one variable, not five;
PROC PRINT DATA = sales;
  TITLE 'SAS Dataset Sales'; *For the output of the command, c.f. pp.40-41;
RUN;

DATA contest;
    *Sometimes raw data are not striaghtforward numeric or character. So neither 
     the list nor the column style will work. However, Informats are useful in 
     this case. Numbers with embedded commas, dollar signs, data in hexadecimal 
     or packed decimal formats, dates and time, are all nonstandard formats. There
     are three general types of informats: character, numeric, and date. These 
     three types of informats have the following general forms: 1) $informatw., 
     2) informatw.d, 3) informatw.. Note that informat is the name of the informat, 
     w is the total width and d is the number of decimal places (numeric only). 
     Note that the period at the end of the informat is very important which should 
     not be forgotten. A selected list of informats can be found in Section 2.8 of
     Little SAS book;
  INFILE 'C:\Users\tgao4\Desktop\Pumpkin.dat';
  INPUT Name $16. Age 3. +1 Type $1. +1 Date MMDDYY10. (Score1 Score2 Score3
        Score4 Score5) (4.1);
       *Here the variable Name has an informat of $16, which means it's a character 
        variable with 16 columns wide. Variable Age has an informat of three, which 
        is numeric. The +1 means to skp over one column. The variable Type is a
        character with width of 1. Variable Date has an informat MMDDYY10. and reads 
        dates in the form 10-31-2003, each 10 columns wide. The remaining variables 
        Score1 to Score5 all have the same informat of 4.1 (4 column wide and 1 
        decimal places), c.f. pp.43-45;
PROC PRINT DATA = contest;
  TITLE 'Pumpkin Carving Contest';
RUN;

DATA nationalparks;
    *Sometimes we can do the mixing input styles (informat + column). This is b/c
     column and formatted styles do not require spaces or other delimiters between 
     variables and can read embedded blanks. Formatted style can read special data 
     such as dates. Sometimes we can combine the advantages of these two styles!;
  INFILE 'C:\Users\tgao4\Desktop\NatPark.dat';
  INPUT ParkName $ 1-22 State $ Year @40 Acreage COMMA9.;
    *The column pointer @40 here tells SAS to move to column 40 before reading 
     the value of Acreage. So the 40th column is the first part of the data Acreage
     will start to be read. Whereas if you remove the column pointer from the INPUT 
     statement, then SAS will start reading the variable Acreage right after the 
     variable Year. Also, note that the COMMA9. numeric informat tells SAS to read 9 
     columns, and SAS did so even when those columns were completely blank;
PROC PRINT DATA = nationalparks;
  TITLE 'Selected National Parks1';
RUN;

*Compare the above program with the next one!;

DATA nationalparks; 
  INFILE 'C:\Users\tgao4\Desktop\NatPark.dat';
  INPUT ParkName $ 1-22 State $ Year Acreage COMMA9.; 
    *Now we don't have the column pointer @n anymore, compare this code with the 
     previous result!;
    *The column pointer @n has other uses too and can be used anytime you want SAS
     to skip backwards or forwards within a data line. You could use it to skip over 
     unneeded data or to read a variable twice using different informats;
PROC PRINT DATA = nationalparks;
  TITLE 'Selected National Parks2';
RUN;

DATA weblogs;
    *When data are not lining up in nice columns/rows, we need to use either the 
     column pointer @'character' or the colon modifier : to read the messy data. 
     For example, sometimes you don't know the starting columns of the data, but 
     you do know that it always comes after a particular character or word. For 
     these situations, one can use the @'character' to point to the data. On the 
     other hand, if one only wants SAS to read until it encounters a space, then 
     the colon modifier may come in handy. To use a colon modifier, simply put a 
     colon : before the informat, c.f. pp. 48-49;
    *Here is an example. suppose you have a data file that has info about dog 
     ownership. Nothing in the file lines up, but you know that the breed of the 
     dog always follows the word Breed:. You could read the dog's breed using the 
     following INPUT statement--INPUT @'Breed:' DogBreed $--but the problem is that
     sometimes the name of the dog is too long (more than 8 characters), so some
     of the data will not be fully read. An example is a dog breed's name, called
     Rottweiler Vet Bill. If we use an informat of $20., SAS will for sure read the
     whole thing (20 columns total), but sometimes because the data are messy, you 
     may have let SAS read unwanted part of the data. If we only want to read the 
     word Rottweiler, simply put a colon modifier in front of the informats, which 
     tells SAS to stop reading once it encounters a space. Compare the following 3
     statements, each gives a different way of reading the data:
       SAS statements                            SAS will read
       INPUT @'Breed:' DogBreed $                Rottweil
       INPUT @'Breed:' DogBreed $20.             Rottweiler Vet Bill
       INPUT @'Breed:' DogBreed :$20.            Rottweiler
     ;
  INFILE 'C:\Users\tgao4\Desktop\dogweblogs.txt';
  INPUT @'[' AccessDate DATE11. @'GET' File :$20.;
    *@'[' is used to position the column pointer to read the date, then the @'GET' 
     is to position the column pointer to read the filename. Because the filename 
     is more than 8 characters, but not always the same number of characters, an 
     informat with a colon modifier :$20. is used to read the filename;
PROC PRINT DATA = weblogs;
  TITLE 'Dog Care Web Logs';
RUN;

*------------------;

DATA temp;
    *Sometimes data for each observation are spread over more than one line, so to 
     solve this problem, we use the line pointers / or #n, where n specifies the 
     line number. For example, the sign #2 means to go to the second line for that  
     observation. The slash / simply means go to the next line;
  INFILE 'C:\Users\tgao4\Desktop\Temperature.dat';
  INPUT City $ State $ /NormalHigh NormalLow #3 RecordHigh RecordLow;
    *The INPUT statement reads the values for the City and State from the first 
     line of data. Then the slash tells SAS to move to column 1 of the next line of 
     data before reading NormalHigh and NormalLow. Likwise, #3 tells SAS to move 
     to column 1 of the 3rd line of data for that observation before reading
     RecordHigh and RecordLow. There are many ways to do this, you could replace the 
     slash with #2 or replace #3 with a slash. All of them give you the same thing;
PROC PRINT DATA = temp;
  TITLE 'High and Low Temperature in July of Cities';
RUN;

DATA rainfall;
    *This example illustrates how to read multiple observations per line of raw data. 
     When you have multiple observations per line of raw data, you can use @@ at the 
     end of your INPUT statement to tell SAS "Stop, hold that line of raw data." SAS 
     will then hold that line of data, continuing to read observations until it 
     either runs out of data or reaches an INPUT statement that does not end with @@;
  INFILE 'C:\Users\tgao4\Desktop\Precipitation.dat';
  INPUT City $ State $ NormalRain MeanDaysRain @@;
PROC PRINT DATA = rainfall;
 TITLE 'Normal Total Precipitation and';
 TITLE2 'Mean Days with Precipitation for July';
RUN;

*The next example shows how to read data partially. This is rarely used because in the
 future one can use IF THEN statement to achieve such effect;

DATA freeways;
    *Sometimes you want to read part of the data. The tool we are going to use is @.
     This tells SAS to hold that line of raw data. While the trailing @ holds that
     line, you can test the observation with an IF statement to see it's the one you 
     want. By using an @ without specifying a column, it is as if you are telling SAS
     to stop reading and follow the next instruction. This example shows how you can
     read only the freeway data (part of the data from Traffic);
  INFILE 'C:\Users\tgao4\Desktop\Traffic.dat';
  INPUT Type $ @;
  IF Type = 'surface' THEN DELETE;
  INPUT Name $ 9-38 AMTraffic PMTraffic;
    *Notice that there are two INPUT statements. The first reads the character variable
     Type and then ends with an @ which holds each line of the data while the next IF
     statement tests it. The second INPUT statement reads the rest of the data. If an 
     observation has a value of 'surface' for the variable Type, then the second INPUT
     statement never executes. Instead, SAS returns to the beginning of the DATA step 
     to process the next observation and does not add the unwanted observation to the 
     freeways dataset; 
PROC PRINT DATA = freeways;
  TITLE 'Traffic for Freeways';
RUN;

*------------------;

*We now learn how to use options in the INFILE statement. There are three main useful ones
 we will cover here: FIRSTOBS=, OBS= and MISSOVER. There are other similar INFILE commands
 such as TRUNCOVER and TRUNCOVER, which we will not cover here. For a good reference, see
 the online tutorial for these commands;

DATA icecream;
  INFILE 'C:\Users\tgao4\Desktop\IceCreamSales2.dat' FIRSTOBS = 3 OBS = 5;
    *The FIRSTOBS= option tells SAS at what line to begin reading the data. This is useful
     when you have a dataset that contains descriptive text or header info at the beginning
     and you want to skip over these lines to begin reading the data. The OBS= option is
     used anytime you want to read only a part of your data file, telling SAS to stop 
     reading when it gets to that line in the raw dataset. So basically FIRSTOBS and OBS are
     like antonyms in SAS language;
  INPUT Flavor $ 1-9 Location BoxesSold;
PROC PRINT DATA = icecream;
  TITLE 'IceCreamyeah';
RUN;

DATA class102;
  INFILE 'C:\Users\tgao4\Desktop\AllScores.dat' MISSOVER;
    *By default, SAS goes to the next data line to read more data if SAS has reached the 
     end of the data line and there are still more variables in the INPUT statement that 
     have not been assigned values. The MISSOVER option tells SAS that if it runs out of 
     data, don't go to the next dataline. Instead, assign missing values to any remaining 
     variables;
  INPUT Name $ Test1 Test2 Test3 Test4 Test5;
PROC PRINT DATA = class102;
  TITLE 'Class';
RUN;

*------------------;

*Delimited files are raw data files that have a special character separating data values, 
 say commas or tab characters for delimiters. SAS gives you two options for the INFILE 
 statement that make it easy to read delimited data files: the DLM= option and the DSD 
 option;

*The DLM= option: if you read your data using list input, the DATA step expects your file to
 have spaces between your data values. The DELIMITER= or DLM= in the INFILE statement allows
 you to read data files with other delimiters. You can read data files with any delimiter 
 character by just enclosing the delimiter character in quotation marks after the DLM= 
 option, for example, DLM = '&' where & is the delimiter;
*The DSD= option: this command does 3 things. First, it ignores delimiters in data values
 enclosed in quotation marks. Second, it does not read quotation marks as data. Third, it 
 treats two delimiters in a row as a missing value. The DSD option assumes that all the 
 delimiters are commas. If your delimiter is not a comma, then you can use the DLM= option 
 with the DSD option to specify the delimiter;

DATA reading;
  INFILE 'C:\Users\tgao4\Desktop\Books.dat' DLM = ',';
  INPUT Name $ Week1 Week2 Week3 Week4 Week5;
RUN;
PROC PRINT DATA = reading;
  TITLE 'Reading List';
RUN;

DATA music;
  INFILE 'C:\Users\tgao4\Desktop\Bands2.csv' DLM = ',' MISSOVER;
  INPUT BandName :$30. GigDate :MMDDYY10. EightPM NinePM TenPM ElevenPM;
PROC PRINT DATA = music;
  TITLE 'Customers at Each Gig';
RUN;

*--------------------------------------------------------------;


*Reference: Little SAS Chapter 2.5-2.15;
