*SAS Lecture Note 6-Data Tabulation and Report;

*Now we learn how to use PROC TABULATE, which is more powerful and elegant than PROC PRINT/
 MEANS/FREQ etc. The general form of PROC TABULATE is given by the following commands:
   PROC TABULATE 
     CLASS classification_variable_list
     TABLE page_dimension, row_dimension, column_dimension
   RUN
 Of course after each sentence we have a semicolon. 
 The CLASS statement tells SAS which variables contain categorical data to be used in order 
 to divide observations into groups (later we'll learn another statement that deals with 
 continous, or non-categorical data), while the TABLE statement specifies how to organize 
 the table. Each table statement defines only one table, but you can certainly have several 
 TABLE statements, and each one can specify up to three dimensions (and each dimension is
 separated by commas). If you specify only one dimension, then that becomes the column 
 dimension by default. If you specify two dimensions, then you get rows and columns, but not
 page dimension. If you specify all of the three, you get pages, rows, and columns. Note
 also that if a variable is listed in a CLASS statement, then, by default, PROC TABULATE
 produces simple counts of the number of observations in each category of that variable. In 
 general PROC TABULATE offers many other stats too (c.f. Section 4.13);

*In addition, remember that by default, observations are excluded from tables if they have
 missing values for variables listed in a CLASS statement. If you actually want to keep 
 these observations, then simply add the MISSING option to your PROC TABULATE statement:
 PROC TABULATE MISSING;

DATA boats;
  INFILE 'c:\Users\tgao4\Desktop\Boats.dat';
  INPUT Name $ 1-12 Port $ 14-20 Locomotion $ 22-26 Type $ 28-30 Price 32-36;
PROC TABULATE DATA = boats;
  CLASS Port Locomotion Type; 
    *If you look at the data there are only two kinds of ports--Lahaina and Maalea, so SAS
     will tabulate two tables in the output--one for Lahaina and one for Maalea;
  TABLE Port, Locomotion, Type;
    *Here the TABLE statement creates a three-dimensional report with the values of Port for
     the pages, Locomotion for the rows, and Type for the columns. You can try to delete one
     of the variables in the TABLE statement and see what the output window looks like;
  TITLE 'Number of Boats by Port, locomotion, and Type';
RUN;

*---------------------------------;

*We now learn how to do more complicated things using PROC TABULATE, such as calculating
 more statistics for tabulation. A slightly more general form of PROC TABULATE is given by:
   PROC TABULATE 
     VAR continous_variable_list
     CLASS categorical_classification_variable_list
     TABLE page_dimension, row_dimension, column_dimension
   RUN
 Note that while the CLASS statement lists categorical variables, the VAR statement tells
 SAS which variables are continuous. Note also that all variables listed in a TABLE statement 
 must also appear in either a CLASS or a VAR statement;

*In addition, each dimension can contain some keywords in the TABLE statement to calculate
 more fancy statistics, such as ALL(adds a row, column, or page showing the total), MAX, 
 MIN, MEAN, MEDIAN, N, NMISS, P90(the 90th percentile), PCTN (the percentage of observations
 for that group), PCTSUM (percentage of a total sum represented by that group), STDDEV, and 
 SUM etc. Meanwhile, within a dimension, variables and keywords can be concatenated/crossed/
 grouped (see the output result for the next example). To concatenate variables or keywords,
 simply list them separated by a space. To cross variables or keywords, separate them with 
 an asterisk. To group them, enclose the variables or keywords in parentheses. The keyword 
 ALL is generally concatenated. To request other stats, however, we need to cross that keyword 
 with the variable names. Below are a few examples:
   TABLE variable_1 variable_2 ALL
   TABLE MEAN*continous_variable)
   TABLE PCTN*(variable_1 variable_2)
 Of course for each SAS command we need a semicolon at the end;

DATA boats;
  INFILE 'c:\Users\tgao4\Desktop\Boats.dat';
  INPUT Name $ 1-12 Port $ 14-20 Locomotion $ 22-26 Type $ 28-30 Price 32-36;
PROC TABULATE DATA = boats;
  CLASS Locomotion Type; 
  VAR Price; 
  TABLE Locomotion ALL, MEAN*Price*(Type ALL);
  TITLE 'Mean Price by Locomotion and Type';
RUN;
  
*Compare the above tables with the following commands;

PROC TABULATE DATA = boats;
  CLASS Locomotion Port Type; 
  VAR Price; 
  TABLE Locomotion ALL, MEAN*Price(Type ALL);
  TABLE Port Locomotion, MEAN*Price(Type ALL);
  TABLE Locomotion, Port, MEAN*Price*(Type);
  TABLE Locomotion, Port, NMISS*Price MEAN*Price(Type) P90*Price(Type ALL);
  TITLE 'Various Tabulation Displays';
RUN;

*---------------------------------;

*We now learn how to enhance the appearance of PROC TABULATE. There are three things worth
 mentioning. 1) FORMAT = options. 2) BOX = options. 3) MISSTEXT  = options. The first method 
 FORMAT = options is used to chnage the format of all the data cells in your table, e.g.
 PROC TABULATE FORMAT = COMMA10.0 means that we are tabulating the table using the COMMAw.d 
 format, which writes numeric values with a comma that separates every three digits and a 
 period that separates the decimal fraction, and remember that FORMAT statement can only go 
 in the PROC statement;

*While the FORMAT statement must be used in the PROC statement, the BOX and MISSTEXT must 
 go in TABLE statements. 1) The BOX statement allows you to write a brief descriptive phrase 
 in the normally empty box that appears in the upper left corner of every TABULATE report. 
 2) The MISSTEXT specifies a value or a phrase for SAS to print in empty data cells. The 
 period that SAS prints for missing values can seem downright mysterious to your CEO, so you 
 can give them something more meaningful by using the MISSTEXT = option. For example:
   TABLE Region, Mean*sales / BOX = 'MEAN Sales by Region' MISSTEXT = 'No Sales'
 This tells SAS to print the title "Mean Sales by Region" in the upper left corner of the 
 table and to  print the words "No Sales" in any cells of the table that have no data. Note
 that the BOX and MISSTEXT statements must be separated from the dimensions of the TABLE 
 statement by a slash; 

DATA boats;
  INFILE 'c:\Users\tgao4\Desktop\Boats.dat';
  INPUT Name $ 1-12 Port $ 14-20 Locomotion $ 22-26 Type $ 28-30 Price 32-36;
PROC TABULATE DATA = boats;
  CLASS Locomotion Type; 
  VAR Price; 
  TABLE Locomotion ALL, MEAN*Price*(Type ALL) MAX*Price*(Type ALL) MIN*Price*(Type ALL)
    /BOX = 'Full Day Excursions' MISSTEXT = 'missing value';
  TITLE;
RUN;

*----------------------------------;

*We now learn how to change headers in the PROC TABULATE output. First, note that TABULATE
 reports have two basic types of headers--headers that are the values of variables listed
 in a CLASS statement, and headers that are the names of variables and keywords. To change 
 headers which are the values of variables listed in a CLASS statement, we need to use the 
 FORMAT procedure to create a user-defined format. We can then assign the format to the 
 variable in a FORMAT statement (see Section 4.7). To change headers which are the names of 
 variables or keywords, we can put an equal sign after the variable or keyword followed by 
 the new header enclosed in quotation marks. You can eliminate a header entirely by setting 
 it equal to blank. You can also change variable headers with a LABEL statement(c.f. Section 
 4.1), and keyword headers with a KEYLABEL statement. However, the TABLE statement method
 is the only way that you can remove a variable header without leaving a blank box behind;

DATA boats;
  INFILE 'c:\Users\tgao4\Desktop\Boats.dat';
  INPUT Name $ 1-12 Port $ 14-20 Locomotion $ 22-26 Type $ 28-30 Price 32-36;
PROC FORMAT; 
    *This procedure basically aims to change the headers in the table. In the following set 
     of commands, we create a new self-defined format called $typ, and The special codes 
    'cat', 'sch', and 'yac' that appear originally in the raw dataset, are converted to the 
     names of the corresponding boat-types, called 'catamaran', 'schooner' and 'yacht'
     respectively. Fore more information, refer to the online SAS documentation "Creating a 
     Format for Character Values" and check the information regarding the VALUE statement;
  VALUE $Typ 'cat' = 'catamaran'
             'sch' = 'schooner'
             'yac' = 'yacht';		                    
PROC TABULATE DATA = boats FORMAT = DOLLAR9.2;
  CLASS Locomotion Type;
  VAR Price;
  FORMAT Type $Typ.; *Don't forget to put a period at the end of the self-defined format!;
  TABLE Locomotion = '' ALL, MEAN = ''*Price = 'Mean Price by Type of Boat'*(Type = '' ALL)
    /BOX = 'Full Day Excursions';
      *Compare the table with the previous ones and see the difference!;
  TITLE;
RUN;

*---------------------------------;

*Using the FORMAT = option in a PROC TABULATE statement, you can easily specify a format but
 you can only apply this format to all data. If you want to use more than one format in your
 table, you can put the FORMAT statement in your TABLE statement. To apply such technique, the
 general form of the TABLE statement looks like the following:
   variable_name*FORMAT = formatw.d
 Then you insert this rather complicated construction in your TABLE statement:
   TABLE Region, MEAN*(Sales*FORMAT = COMMA8.0 Profit*FORMAT = DOLLAR10.2)
 This TABLE statement applies the COMMA8.0 format to a variable called Sales, and the 
 DOLLAR10.2 format to another variable called Profit;

DATA boats_data;
  INFILE 'c:\Users\tgao4\Desktop\Boats2.dat';
  INPUT Name $ 1-12 Port $ 14-20 Locomotion $ 22-26 Type $ 28-30 Price 32-36 Length 38-40;
PROC TABULATE DATA = boats_data;
  CLASS Locomotion Type;
  VAR Price Length;
  TABLE Locomotion ALL, MEAN*(Price*FORMAT = DOLLAR6.2 Length*FORMAT = 6.0)*(Type ALL);
  TABLE Locomotion ='' ALL, 
        MEAN = ''*
               (Price = 'Mean Price by Type'*FORMAT = DOLLAR6.2 
                Length = 'Mean Length by Type'*FORMAT = 6.0)*
                                                             (Type = '' ALL)
        /BOX = 'Row: Locomotion\Column: Mean Price and Length';
  TITLE 'Price and Length by Type of Boat';
RUN;

*---------------------------------;

*From now on, we learn the REPORT procedure, which is another version of PROC TABULATE. We 
 start from the simplest version. Here is the general form of a basic REPORT procedure:
   PROC REPORT NOWINDOWS
     COLUMN variable_list
   RUN
 In its simplest form, the COLUMN statement is similar to a VAR statement in PROC PRINT,
 telling SAS which variables to include and in what order. If you leave out the COLUMN 
 statement, SAS will, by default, include all the variables in your dataset. If you leave 
 out the NOWINDOWS option, SAS will open the Interactive Report Window;

*PROC REPORT prints your data immediately beneath the column headers by default. So in order 
 to separate the headers and data, use the HEADLINE or HEADSKIP options as the following:
   PROC REPORT NOWINDOWS HEADLINE
   PROC REPORT NOWINDOWS HEADSKIP
 HEADELIN draws a line under the column headers while HEADSKIP puts a blank line beneath the 
 column headers. Moreover, if you have at least one character variable in your report, then, 
 by default, you will get a detailed report with one row per observation. If, on the other 
 hand, your report includes only numeric variables, the, by default, PROC REPORT will sum up 
 those variables. Even dates will be summed because they are numeric. Now compare the two 
 following procedures below;

DATA nparks;
  INFILE 'c:\Users\tgao4\Desktop\Parks.dat';
  INPUT Name $ 1-21 Type $ Region $ Museums Camping;
    LABEL Museums = 'Number of Museums';
    LABEL Camping = 'Number of Camps';
PROC REPORT DATA = nparks NOWINDOWS HEADLINE;
  TITLE 'Report with Character and Numeric Variables';
RUN;
PROC REPORT DATA = nparks NOWINDOWS HEADSKIP;
  COLUMN Museums Camping;
  TITLE 'Report with only Numeric Variables';
RUN;
  *While the two PROC steps are only slightly different. One can easily see they produced
   totally different outputs. The first report is almost identical to the output you would
   get from a PROC PRINT. The second report, since it contained only numeric variables, was
   summed up;

*---------------------------------;

*Now we learn how to use the DEFINE statement, which is a general-purpose statement that 
 specifies options for an individual variable. You can have a DEFINE statement for every 
 variable, but you only need to have a DEFINE statement if you want to specify an option 
 for that particular variable. The general form of a DEFINE statement is the following:
   DEFINE variable/ options 'column-header'
 In a DEFINE statement, you specify the variable name followed by a slash and any options 
 for that particular variable.
 1).The most important option is a usage option that tells SAS how that variable is to be 
    used. Possible and commonly-used candidates for such options include the following:
    ACROSS (creates a column for each unique value of the variable)
    GROUP (creates a row for each unique value of the variable)
    ANALYSIS (calculates statistics for the numeric variable. The default one is sum)
    DISPLAY (creates one row for each character observation in the dataset)
    ORDER (creates one row for each observation with rows arranged according to the values
           of the order variable)
 2). There are several ways to change the column headers in PROC REPORT including using the 
     LABEL statement (c.f. Section 4.1). Meanwhile, using a slash in a column header tells 
     SAS to split the header at that point. Here is an example:
       DEFINE Age/ ORDER 'Age at/Admissions'
 ;

DATA nparks1;
  INFILE 'c:\Users\tgao4\Desktop\Parks.dat';
  INPUT Name $ 1-21 Type $ Region $ Museums Camping;
    LABEL Museums = 'Number of Museums';
    LABEL Camping = 'Number of Camps';
PROC REPORT DATA = nparks1 NOWINDOWS HEADSKIP MISSING;
  COLUMN Region Name Museums Camping;
    DEFINE Region/ ORDER;
    DEFINE Camping/ ANALYSIS 'Camp/Grounds';
  TITLE 'National Parks and Monuments Arranged by Region';
    *Notice that there are three values of Region--Missing, East, and West;
RUN;
PROC REPORT DATA = nparks1 NOWINDOWS HEADLINE;
  COLUMN Region Type Museums Camping;
    DEFINE Region/ GROUP;
    DEFINE Type/ GROUP;
  TITLE 'Summary Reports with 2 Group Variables';
RUN;
PROC REPORT DATA = nparks1 NOWINDOWS HEADLINE;
  COLUMN Region Type Museums Camping;
    DEFINE Region/ ACROSS;
    DEFINE Type/ ACROSS;
  TITLE 'Summary Reports with 2 Across Variables';
RUN; *This table looks ugly! Try not to use it;
PROC REPORT DATA = nparks1 NOWINDOWS HEADLINE MISSING;
  COLUMN Region Type Museums Camping;
    DEFINE Region/ GROUP;
    DEFINE Type/ ACROSS;
  TITLE 'Summary Report with a Group and an Across Variables II.';
RUN; *This table looks ugly! Try not to use it!;
PROC REPORT DATA = nparks1 NOWINDOWS HEADLINE;
  COLUMN Region Type, (Museums Camping);
    DEFINE Region/ GROUP;
    DEFINE Type/ ACROSS;
  TITLE 'Summary Report with a Group and an Across Variables I.';
  FOOTNOTE 'c.f. p.137';
RUN;

*The lessons we learned: 1) In terms of visual aesthetics, you can use many GROUP variables
 as you want but try to avoid defining more than one across variables. 2) When we define the 
 across variabless, try to compacticize them like what we did in the tabulation procedures 
 (so in the table everything is stacked);

*---------------------------------;

*Two kinds of statements allow you to insert breaks into a report. The BREAK statement adds
 a break for each unique value of the variable you specify, while the RBREAK statement does 
 the same for the entire report. Notice that the BREAK statement requires you to specify a 
 variable, but the RBREAK statement does not. That's because the RBREAK produces only one
 break (at the beginning or end) while the BREAK produces one break for every unique value 
 of the variable you specify. That variable must be either a group or order variable and
 thus must also be listed in a DEFINE statement with either the GROUP or ORDER usage option. 
 You can use an RBREAK statement in any report, but you can use BREAK only if you have at 
 least one GROUP or ORDER variable. The general forms of these statements are given by:
   BREAK location variable/ options
   RBREAK location/ options
 Here location has two possible values--BEFORE or AFTER--depending on whether you want the 
 break to precede or follow that particular section of the report. The options that come
 after the slash tell SAS what kind of break to insert. Some of the possible options are:
   OL (draws a line over the break)
   UL (draws a line under the break)
   PAGE (starts a new page)
   SKIP (inserts a blank line)
   SUMMARIZE (inserts sums of numeric variables)
 Remember: You can only BREAK on GROUPing and ORDERing variables!;

DATA nparks2;
  INFILE 'c:\Users\tgao4\Desktop\Parks.dat';
  INPUT Name $ 1-21 Type $ Region $ Museums Camping;
    LABEL Museums = 'Number of Museums';
    LABEL Camping = 'Number of Camps';
PROC REPORT DATA = nparks2 NOWINDOWS HEADLINE;
  COLUMN Name Region Museums Camping;
    DEFINE Region/ ORDER;
    BREAK AFTER Region/ SUMMARIZE OL SKIP;
    RBREAK AFTER/ SUMMARIZE OL SKIP;
  TITLE 'National Park Table with Breaks';
RUN;

*Compare the above with the program below:;

PROC REPORT DATA = nparks2 NOWINDOWS HEADLINE;
  COLUMN Name Region Museums Camping;
    DEFINE Region/ ORDER;
    BREAK AFTER Region/ SUMMARIZE OL SKIP;
  TITLE 'National Park Table with Breaks I.';
RUN;

PROC REPORT DATA = nparks2 NOWINDOWS HEADLINE;
  COLUMN Name Region Museums Camping;
    DEFINE Region/ ORDER;
    RBREAK AFTER/ SUMMARIZE OL SKIP;
  TITLE 'National Park Table with Breaks II.';
RUN;

PROC REPORT DATA = nparks2 NOWINDOWS HEADLINE;
  COLUMN Name Region Museums Camping;
    DEFINE Region/ ORDER;
    BREAK AFTER Region/ SUMMARIZE UL SKIP;
    RBREAK AFTER/ SUMMARIZE OL SKIP;
  TITLE 'National Park Table with Breaks III.';
RUN;

*---------------------------------;

*Finally we learn how to add statistics to PROC REPORT. An easy method is to insert a special
 statistics keyword directly into the COLUMN statement along with the variable names. This is 
 very similar to the situation in PROC TABULATE except that instead of using an asterisk to 
 cross a statistics keyword with a variable, you use a comma. In fact, PROC REPORT is basically 
 the same thing as PROC TABULATE. So whenever possible, we should try to use PROC TABULATE 
 because its syntaxes are easier, relatively speaking;

DATA nparks3;
  INFILE 'c:\Users\tgao4\Desktop\Parks.dat';
  INPUT Name $ 1-21 Type $ Region $ Museums Camping;
PROC REPORT DATA = nparks3 NOWINDOWS HEADLINE;
  COLUMN Region Type N (Museums Camping), MEAN;
    DEFINE Region/ GROUP;
    DEFINE Type/ GROUP;
  TITLE 'Stats with Two Group Variable';
RUN;
PROC REPORT DATA = nparks3 NOWINDOWS HEADLINE;
  COLUMN Region N Type, (Museums Camping), MEAN;
    DEFINE Region/ GROUP;
    DEFINE Type/ ACROSS;
  TITLE 'Statistics with a Group and Across Variable';
RUN;

*---------------------------------;

*Reference: Little SAS Chapter 4.12-4.21;
