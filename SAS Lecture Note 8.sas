*SAS Lecture Note 8-Customizations in ODS;

*In ODS output, your style template tells SAS how titles and footnotes should look. However, you
 can easily change the appearance of titles and footnotes by inserting a few simple options in
 your TITLE and FOOTNOTE statements. The general form for a TITLE or FOOTNOTE statement is:
   TITLE options 'text string-1' options 'text string-2' options 'text-string-3'
   FOOTNOTES options 'text string-1' options 'text string-2' options 'text-string-3'
 Texts can be broken into pieces with different options applying to each piece. SAS will
 concatenate text strings just the way you type them, so be sure to include any necessary blanks.
 Each option applies to the text string that follow, and stays in effect until another value is 
 specified for that option, or until the end of the statement. Here are some main options that 
 you can choose from:
   COLOR=
   BCOLOR= 
   HEIGHT=
   JUSTIFY=
   FONT=
   BOLD
   ITALIC
 The COLOR= option specifies the color of hte text, possible colors include BLACK, BLUE, STEEL, 
 CHARCOAL, CREAM, CYAN, GOLD, GREEN, LILAC, LIME MAGENTA, MAROON, OLIVE, ORANGE, SALMON, TAN, 
 WHITE, YELLOW etc. BCOLOR= stands for background color. HEIGHT= specifies height of the text. 
 The units include points (pt), inches (in), or centimeter (cm), for example:
   TITLE HEIGHT = 12pt 'Small' HEIGHT = 0.25in 'Medium' HEIGHT = 1cm 'Large'
 For JUSTIFY=, the optional values are LEFT, RIGHT and CENTER. For example:
   TITLE JUSTIFY=LEFT 'left' JUSTIFY=CENTER 'vs. ' JUSTIFY=RIGHT 'Right'
 By default, titles and footnotes are both bold and italic. When you change the font, you also 
 turn off the bold and italic features. You can turn tem on by using the BOLD and ITALIC options.
 There is no option to turn off boldness and italics, so if you wish to turn them off, use the 
 FONT= option;

DATA custom; *For details of this section, see pp.156-157;
  INPUT y x;
  CARDS;
    1 3
    2 2
    ;
PROC PRINT DATA = custom;
TITLE COLOR = MAGENTA BCOLOR = GRAY FONT = Courier'Fake Data' 
      FONT = ARIAL BOLD ITALIC COLOR = GREEN ' and Real Data' 
      JUSTIFY = RIGHT ' Examples'; *Make sure to check the results in the output window!;
RUN;

*---------------------------------;

*The reporting procedures, PRINT, REPORT, and TABULATE allow you to change the style of various 
 parts of the table that these procedures produce using the STYLE=option in the procedure's 
 statements. The general form of the STYLE=option in the PROC PRINT statement is given by:
   PROC PRINT STYLE(location-list) = {style-attribute = value}
 Here the location-list indicates which parts of the table should take on the style, and the
 style-attribute indicates what attribute you want to change, and the value is the value of the 
 attribute. For example, the following statement says that the DATA location should have the 
 BACKGROUND style attribute set to the value of PINK:
   PROC PRINT STYLE(DATA) = {BACKGROUND = PINK}
 You can have several STYLE=option on one PROC PRINT statement, and you can have the same style 
 apply to several locations. The following shows some of the locations you can specify and which 
 parts of the table they represent:
   Location           Table region affected
   DATA               all the data cells
   HEADER             the column headers (variable names)
   OBS                the data in the OBS column or ID column if using an ID statement
   OBSHEADER          the header for the OBS or ID column
   TOTAL              the data in the totals row produced by a SUM statement
   GRANDTOTAL         the data for the grand total produced by a SUM statement 
 By placing the STYLE= option in the PROC PRINT statement, the entire table will be affected by 
 the STYLE. For example, if you specify HEADER as the location, then all of the column headers 
 will have the new style. But what if you just want to change the header of just one column? Then
 you can put the STYLE= option in the VAR statement as follows:
   VAR variable-list / STYLE(location-list) = {style-atribute = value}
 Only the variables listed in the VAR statement will have the specified style. If you want 
 different variables to have different styles, then you should use multiple VAR statements. Only 
 the DATA and HEADER locations are valid on the VAR statement;

*This program reads the data and uses PROC PRINT to create an HTML file using the DEFAULT style 
 template;
ODS HTML FILE = 'c:\Users\tgao4\Desktop\result1.html';
DATA Skating; 
  INFILE 'c:\Users\tgao4\Desktop\women.txt' DSD MISSOVER;
  INPUT Year Name :$20. Country $ Time $ Record $;
PROC PRINT DATA = Skating;
  TITLE "Women's 5000 Meter Speed Skating";
  ID Year;
RUN;
ODS HTML CLOSE;

*This program reads the data and uses PROC PRINT to create an HTML file using the DEFAULT style 
 template except for the fact that the STYLE=option on the PROC PRINT statement changes the 
 background of all the data cells in the table to red;
ODS HTML FILE = 'c:\Users\tgao4\Desktop\result2.html';
DATA Skating; 
  INFILE 'c:\Users\tgao4\Desktop\women.txt' DSD MISSOVER;
  INPUT Year Name :$20. Country $ Time $ Record $;
PROC PRINT DATA = Skating STYLE(DATA) = {BACKGROUND = RED};
  TITLE "Women's 5000 Meter Speed Skating";
  ID Year;
RUN;
ODS HTML CLOSE;

*This program reads the data and uses PROC PRINT to create an HTML file while 1) adding VAR 
 statements to change the font style and the font weight of the Record column to italic and bold
 and 2) change the font style of the previous three variables to italic;
ODS HTML FILE = 'c:\Users\tgao4\Desktop\result3.html';
DATA Skating; 
  INFILE 'c:\Users\tgao4\Desktop\women.txt' DSD MISSOVER;
  INPUT Year Name :$20. Country $ Time $ Record $;
PROC PRINT DATA = Skating STYLE(DATA) = {BACKGROUND = GREEN};
  TITLE "Women's 5000 Meter Speed Skating";
  VAR Name Country Time / STYLE(HEADER) = {FONT_STYLE = ITALIC};
  VAR Record / STYLE(DATA) = {FONT_STYLE = ITALIC FONT_WEIGHT = BOLD};
  ID Year;
RUN;
ODS HTML CLOSE;

*---------------------------------;

*Now we learn how to add styles to the PROC REPORT programs. The general form of the 
 STYLE= option in the PROC REPORT statement is:
   PROC REPORT STYLE(location-list) = {style-attribute = value}
 Here the location-list indicates which parts of the table should take on the style, and the
 style-attribute (such as text color or fonts) indicates what attribute you want to change, and 
 the value is the value of the attribute. For example, if you created a report from a SAS dataset
 named mysales and you wanted the column headers to have a green background, then you should use 
 the following statement:
   PROC REPORT DATA = mysales STYLE(HEADER) = {BACKGROUND = GREEN}
 You can specify more than one location in a single STYLE= option statement, and you can have 
 several STYLE= options in oe PROC REPORT statement. Here are some of the locations whose 
 appearance you can control in PROC REPORT:
   Location      Table Region Affected
   HEADER        column headings
   COLUMN        data cells
   SUMMARY       totals created by SUMMARIZE option in BREAK or RBREAK statements
 If you put a STYLE= option in a PROC REPORT statement, then it will affect the whole table. You
 can change part of a report by using the STYLE= option in other statements. To specify a style 
 for a particular variable, put the STYLE= option in a DEFINE statement. For example, the next
 statement tells SAS to use Month as a group variable, and make the background BLUE for both the
 data and header:
   DEFINE Month / GROUP STYLE(HEADER COLUMN) = {BACKGROUND = BLUE}
 To specify a style for particular summary breaks, use th STYLE= option in a BREAK or RBREAK
 statement. For example, the following statements tell SAS to use a red background for summary 
 breaks for each value of Month, and an orange background for the overall report summary:
   BREAK AFTER Month / SUMMARIZE STYLE(SUMMARY) = {BACKGROUND = RED}
   RBREAK AFTER / SUMMARIZE STYLE(SUMMARY) = {BACKGROUND = ORANGE}
 Now compare the following three sets of programs;

DATA skating; *This program uses PROC REPORT statement to create an HTML file using the DEFAULT
               style template;            
  INFILE 'c:\Users\tgao4\Desktop\speed.dat' DSD;
  INPUT Name :$20. Country $ Year NumGold @@;
ODS HTML FILE = 'c:\Users\tgao4\Desktop\speed1.html';
PROC REPORT DATA = skating NOWINDOWS;
  COLUMN Name Country NumGold, SUM;
  DEFINE Name / GROUP;
  DEFINE Country / GROUP;
  TITLE 'Olymip Gold Metal 1';
RUN;
ODS HTML CLOSE;

DATA skating; *This program also uses the DEFAULT style template, but adds a STYLE= option in the 
               PROC REPORT statement to change the background color of all the datacells to 
               orange and to justify the data to the center;
  INFILE 'c:\Users\tgao4\Desktop\speed.dat' DSD;
  INPUT Name :$20. Country $ Year NumGold @@;
ODS HTML FILE = 'c:\Users\tgao4\Desktop\speed2.html';
PROC REPORT DATA = skating NOWINDOWS
            STYLE(COLUMN) = {BACKGROUND = ORANGE JUST = CENTER};
  COLUMN Name Country NumGold, SUM;
  DEFINE Name / GROUP;
  DEFINE Country / GROUP;
  TITLE 'Olymip Gold Metal 2';
RUN;
ODS HTML CLOSE;

DATA skating; *This program uses the STYLE= option in a DEFINE statement to simply affect only 
               one column;
  INFILE 'c:\Users\tgao4\Desktop\speed.dat' DSD;
  INPUT Name :$20. Country $ Year NumGold @@;
ODS HTML FILE = 'c:\Users\tgao4\Desktop\speed3.html';
PROC REPORT DATA = skating NOWINDOWS;
  COLUMN Name Country NumGold, SUM;
  DEFINE Name / GROUP
    STYLE(COLUMN)= {BACKGROUND = BEIGE JUST = CENTER};
  DEFINE Country / GROUP;
  TITLE 'Olymip Gold Metal 3';
RUN;
ODS HTML CLOSE;

*---------------------------------;

*Now we learn how to add styles to PROC TABULATE statements. There are many style attributes you 
 can change (see Section 5.12 in the textbook). The following list shows some of the TABULATE 
 statements that accept the STYLE= option and which parts of the table are affected:
   Statement        Table region affected
   PROC TABULATE    all the data cells
   CLASS            class variable name headings
   CLASSLEV         class level value headings
   TABLE            element's data cell
   VAR              analysis variable name headings
 If you place the STYLE= option on the PROC TABULATE statement, all the table's data cells will 
 have the same style. For example, if you want all the data cells created from the mysales SAS 
 dataset to have a yellow background, then you would use the following statement:
   PROC TABULATE DATA = mysales STYLE = {BACKGROUND = YELLOW}
 If you want some of the data cells to have a different style from the rest, then you need to add
 the STYLE= option to the TABLE statement and cross the style with the variable or keyword you 
 want to change. Any style assigned in a TABLE statement will override styles assigned in the 
 PROC TABULATE statement. For example, the following TABLE statement produces a table where the 
 data cells in the ALL column have a red background:
   TABLE City, Month ALL*{STYLE = {BACKGROUND = RED}}
 The CLASSLEV, VAR, and CLASS statements all require that you place the STYLE= option after a 
 slash sign /. Any variable that appears in a CLASSLEV statement must also appear in a CLASS 
 statement. For example, suppose you had a table with a class variable Month, and you wanted all
 the Month level headings (Jan, Feb,..) to have a foreground color of green, then you would use 
 the CLASSLEV statement as follows:
   CLASSLEV Month / STYLE = {FOREGROUND = GREEN}
 The following program reads the data into a SAS dataset called skating. The Year and N headings 
 are eliminated by setting them equal to a null string (='') in the TABLE statement;

ODS HTML FILE = 'c:\Users\tgao4\Desktop\record1.html';
DATA skating; 
  INFILE 'c:\Users\tgao4\Desktop\records.dat';
  INPUT Year Event $ Record $ @@;
PROC TABULATE DATA = skating
              STYLE = {JUST = CENTER BACKGROUND = CRIMSON};
  CLASS Year Record;
  TABLE Year='', Record*N='';
  TITLE "Men's speed skating";
RUN;
ODS HTML CLOSE;
 
*---------------------------------;

*Traffic-lighting is a feature that allows you to control the style of cells in the table based 
 on the value of the cell. This way you can draw attention to important values in your report, or
 highlight relationships between values. Traffi-lighting can be used in any of the 3 reporting 
 procedures: PRINT, REPORT and TABULATE. To implement traffic-lighting, first you need to create 
 a user-defined format specifying different values for the style attribute you want to change 
 over the range in data values. Then set the style attribute equal to the format you defined in 
 the STYLE= option. For example, if you had a FORMAT procedure that created a format as follows:
   PROC FORMAT
     VALUE posneg.
       LOW -< 0 = 'Red'
       0-HIGH = 'Black'
 Then in a VAR statement in a PRINT procedure, set the value of the attribute equal to the format
 in the STYLE= option as follows:
   VAR Balance / STYLE = {FOREGROUND = posneg.}
 Do not forget the period at the end of the format!;

ODS HTML FILE = 'c:\Users\tgao4\Desktop\mens.html';
DATA results; 
  INFILE 'c:\Users\tgao4\Desktop\mens5000.dat' DSD;
  INPUT Place Name :$20. Country :$15. Time;
PROC PRINT DATA = results;
  ID Place;
RUN;
ODS HTML CLOSE;

ODS HTML FILE = 'c:\Users\tgao4\Desktop\mens.html';
PROC FORMAT;
  VALUE recformat
    0-<378.72 = 'VIOLET'
	378.72-<382.20 = 'MAROON'
	382.20 - HIGH = 'OLIVE';
DATA results; 
  INFILE 'c:\Users\tgao4\Desktop\mens5000.dat' DSD;
  INPUT Place Name :$20. Country :$15. Time;
PROC PRINT DATA = results;
  ID Place;
  VAR Name Country;
  VAR Time / STYLE = {BACKGROUND = recformat.};
RUN;
ODS HTML CLOSE;

*---------------------------------;

*Reference: Little SAS Chapter 5.1-5.6. Note that some of these programs may require to be 
 debugged. See the SAS logs;
