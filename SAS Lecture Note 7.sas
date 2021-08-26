*SAS Lecture Note 7-Introduction to ODS

*ODS stands for Output Delivery System. It determines where the output should go and what it 
 should look like when the data are obtained from the PROC step. It's like an airport,  or more 
 precisely, a packaging machine that packages data and presents them to the market. This means 
 the question to ask is not whether one wants to use ODS--we always use ODS. The question is 
 whether to accept default output or choose something else. Different types of ODS output are 
 called destinations. What the data look like when they get to their destination is determined 
 by something called templates in SAS. A template is a set of instructions telling ODS how to 
 format the data;

*Whenever you don't specify a destination a priori, your output will be sent to the listing 
 destination by default. The listing is what you see in the output window if you use the SAS 
 windowing environment, or in the listing or output file if you use batch mode. Here are the 
 major destinations in SAS:
   LISTING  standard SAS output
   OUTPUT   SAS output dataset
   HTML      
   RTF      Rich Text Format
   PRINTER  high resolution printer output
   PS       PostScript
   PCL      Printer Control Language
   PDF
   MARKUP   markup languages including XML
   DOCUMENT output document
 From the above, the MARKUP destination is a general purpose tool for creating output in markup
 formats. This includes XML, HTML, LaTeX, CSV, and many other formats where data can be thought 
 of as separated by tags. The DOCUMENT destination, on the other hand, allows you to create a 
 reusable output "document" that you can rerender for any destination. So, if your boss really 
 wants that report in PDF, not RTF, you can replay the output document without having to rerun 
 the entire SAS program that created the data;

*Templates describe how ODS should format and present your data. The two most common types of 
 templates are table templates and style templates (also called table definitions and style
 definitions, respectively). A table template specifies the basic structure of your output while
 a style template specifies how the output will look. ODS combines the data produced by some 
 procedure with a table template and together they are called an "output object". The output 
 object is then combined with a style template and sent to a destination to create your final 
 output, c.f. pp.144-145;

*You can create your own table and style templates using the TEMPLATE procedure. However, PROC
 TEMPLATE's syntax is rather arcane. So instead, one can change the look of the output by using 
 the built-in style templates. To view a list of the style templates vaialble on your system,
 simply type in the following commands, with each sentence ended by a semicolon:
   PROC TEMPLATE
     LIST STYLES
   RUN
 The results are shown in the output window. Notice that RTF and PRINTER are names of both 
 destinations and styles;

*A few procedures, most notably PRINT, REPORT, and TABULATE, don't have already-made table
 templates. Instead, the syntax for these procedures requires you to use STYLE= option directly
 in the procedure step to control individual features of the output without having to create a 
 whole new template;

*---------------------------------;

*When ODS receives data from a procedure, it combines that data with a table template. Together
 the data and corresponding table template are called an output object. For many procedures ODS
 produces just one output object, while for others it produces several. In addition, for most 
 procedures when you use a BY statment, SAS produces one output object for each BY group. Every 
 output object has a name. You can find the names of those output objects using the ODS TRACE 
 statement and then use an ODS SELECT or ODS EXCLUDE statement to choose just the output objects 
 you want;

*The ODS TRACE statement tells SAS to print information about output objects in your SAS log. 
 There are 2 ODS TRACE statements--one to return on the trace and one to turn it off. Here is how
 they work:
    ODS TRACE ON
       the PROC steps you want to trace go here
    RUN
    ODS TRACE OFF
 After catching the name of the output object (specified in the log, check the Path:), you can 
 use an ODS SELECT (or EXCLUDE) statement to choose just the output objects you want. The general
 form of an ODS SELECT statement is given by:
    The PROC step with the output objects you want to select
    ODS SELECT output_object_list
    RUN
 Note that the output_object_list is the name, label, or path of one or more output objects 
 separated by spaces. By default, an ODS SELECT statement lasts for only one PROC step, so by 
 placing the SELECT statement after the PROC statement and before the RUN statement, you are sure
 to capture the correct output. ODS EXCLUDE statement works the same way except you list output 
 objects that you want to eliminate;

DATA giant;
  INFILE 'c:\Users\tgao4\Desktop\Tomatoes.dat' DSD;
  INPUT Name :$15. Color $ Days Weight;
    *the :$15. is an informat with a colon modifier, see pp.48-49. The colon here tells SAS to 
     read until encountering a space, c.f. Lecture 2;
ODS TRACE ON; *This starts to trace PROC MEANS;
PROC MEANS DATA = giant;
  BY Color;
  TITLE 'Red Tomatoes';
RUN;
ODS TRACE OFF; *If you check the log, because it contains a BY statement, the MEANS procedure
                produces one output object for each BY group (red and yellow). Notice that these
                2 output objects have the same name, label, and template, but different paths;

DATA giant;
  INFILE 'c:\Users\tgao4\Desktop\Tomatoes.dat' DSD;
  INPUT Name :$15. Color $ Days Weight;
PROC MEANS DATA = giant;
  BY Color;
  TITLE 'Red Tomatoes';
ODS SELECT Means.ByGroup1.Summary;
RUN;

*---------------------------------;

*Sometimes one may want to put the results from a procedure into a SAS dataset. Once the results
 are in the dataset, one can merge them with another dataset, create new variables, or use the 
 results in other procedures. With ODS you can save almost every part of procedure output as a 
 SAS dataset by sending it to the OUTPUT destination. First you use an ODS TRACE statement to 
 determine the name of the output object you want. Then you use an ODS OUTPUT statement to send 
 that object to the OUTPUT destination. Here is a general form of a basic ODS OUTPUT statement:
    ODS OUTPUT output_object = new_dataset
 where output_object is the name, label or path of the piece of output you want to save, and the
 new_dataset is the name of the SAS dataset you intend to create. The ODS OUTPUT statement does 
 not belong to either a DATA or a PROC step, but you need to be careful where you put it. The 
 ODS OUTPUT statement opens a SAS dataset and waits for the correct procedure output. The dataset 
 remains open till the next encounter with the end of a PROC step. Note that because the ODS 
 OUTPUT statement executes immediately, it will apply to whatever PROC is currently being 
 processed, or it will apply to the next PROC if there is not a current PROC. Thus, it is highly 
 recommended that one puts the ODS OUTPUT statement after the PROC statement, and before the next
 PROC, DATA, or RUN statement;

DATA giant1; *This program uses an ODS OUTPUT statement to create a SAS dataset called 'tabout'
              from the Table output object. Then PROC PRINT prints the new dataset;
  INFILE 'c:\Users\tgao4\Desktop\Tomatoes.dat' DSD;
  INPUT Name :$15. Color $ Days Weights;
PROC TABULATE DATA = giant1;
  CLASS Color; *The CLASS statement tells SAS which variables are categorical data;
  VAR Days Weights; *The VAR statement tells SAS which variables are continuous;
  TABLE Color ALL, (Days Weights)*MEAN;
  TITLE 'Standard Tabulation Output';
ODS OUTPUT Table = tabout; *Note that the 3rd word in this command 'table' is the name of the
                            output object. One needs to know the name of the output object 
                            beforehand of course;
RUN;
PROC PRINT DATA = tabout;
  TITLE 'Output SAS Dataset from TABULATE';
RUN;

*---------------------------------;

*From now on we learn how to use ODS statements to create HTML, RTF, or PRINTER outputs. Their 
 commands are very similar, except things in the 'options' statements. All of them require 2
 statements, one to open the ODS and one to close it;

*When you send output to the HTML destination, you get files in HTML format. These files are 
 ready to be posted on a website for viewing by your boss or colleagues, but HTML output has 
 other uses too. It can be read into spreadsheets, and even printed or imported into word
 processors. To genrate HTML files, all you need are two statements--one to open the HTML file
 and one to close it. A good place to put the first ODS statement is just before the PROC step
 whose output you wish to capture, and the best place to put the second ODS statement is right
 after the PROC step following a RUN statement;

*To send output to the HTML destination, we need to use the ODS HTML statement. The general form 
 of this statement is given by the following:
   ODS HTML BODY = 'body_filename.html' options
 where the body file contains the results of your procedures. The options FILE= and BODY= are 
 synonymous. Using options such as CONTENTS, PAGE, FRAME etc., you can definitely create other 
 types of HTML files. For example:
   ODS HTML BODY = 'body_filename.html'  
            CONTENTS = 'contents_filename.html' 
            PAGE = 'page_filename.html'
            FRAME = 'frame_filename.html'
            STYLE = style_name
 (After the word style_name, you need to end with a semicolon while in the middle we do not need 
 semicolons!) Note that you always want to create a body file, but the other files are optional.
 For example, the following statement tells SAS to send output to the HTML destination, save a 
 body file named AnnualReport.html, and use the D3D style:
   ODS HTML BODY = 'AnnualReport.html' 
            STYLE = D3D;

ODS HTML BODY = 'c:\Users\tgao4\Desktop\marinebody.html'
         CONTENTS = 'c:\Users\tgao4\Desktop\sealifecontent.html'
         PAGE = 'c:\Users\tgao4\Desktop\sealifepage.html'
         FRAME = 'c:\Users\tgao4\Desktop\sealifeframe.html'
         STYLE = D3D;
DATA marine;
  INFILE 'c:\Users\tgao4\Desktop\SeaLife.dat';
  INPUT Name $ Family $ Length @@;
PROC MEANS DATA = marine;
  CLASS Family;
  TITLE 'Whales and Sharks';
PROC PRINT DATA = marine;
RUN;
ODS HTML CLOSE;

*---------------------------------;

*Rich Text Format (RTF) was developed for tables in Microsoft Word. When you create RTF outputs, 
 you can copy and paste them into Word documents. To send output to the RTF destination, you use
 the same statements as with HTML but with different options. The general form of the ODS
 statements to open RTF files is given by the following:
    ODS RTF FILE = 'filename.rtf' options 
 Here again, FILE= and BODY=  are synonymous. The options include COLUMNS=n, BODYTITLE, SASDATE,
 and STYLE= etc. The COLUMNS=n requests columnar output where n is the number of columns. The 
 BODYTITLE puts titles and footnotes in the main part of the RTF document. By default, titles 
 and footnotes are put into Word headers and footers. SASDATE tells SAS to use the date and time
 when the current SAS session or job started running;

ODS RTF FILE = 'c:\Users\tgao4\Desktop\marine1.rtf' BODYTITLE;
DATA marine;
  INFILE 'c:\Users\tgao4\Desktop\SeaLife.dat';
  INPUT Name $ Family $ Length @@;
PROC MEANS DATA = marine;
  CLASS Family;
  TITLE 'Whales and Sharks';
PROC PRINT DATA = marine;
RUN;
ODS RTF CLOSE;

*---------------------------------;

*The PRINTER destination produces output for high resolution printers. By default, it sends the
 output to your printer, but it can also write files in PostScript, PCL, or PDF formats. Like 
 other statements, you need 2 statements to generate PRINTER output, one to open the destination 
 and one to close it. The most basic form of the ODS statement to open the PRINTER destination is
 given by:
   ODS PRINTER
 Like RTF, there is only one kind of PRINTER file, a file containing procedure output. FILE= and 
 BODY= are synonymous. Here are the general forms of statements to create specific kinds of
 outputs. The first statement is for default printer, second for PCL, third for PDF, and fourth
 for PostScript:
   ODS PRINTER FILE = 'filename.extension' options
   ODS PCL FILE = 'filename.pcl' options
   ODS PDF FILE = 'filename.pdf' options
   ODS PS FILE = 'filename.ps' options
 Some of the options available for this destination are given by:
   COLUMNS=n (this requests columnar output where n is the number of columns)
   STYLE=
 Here is an example to tell SAS to create a PostScript output, save the results in a file named
 AnnualReport.ps, and use the FANCYPRINTER style:
   ODS PS FILE = 'AnnualReport.ps' STYLE = FANCYPRINTER
 Again, a good place to put the first ODS statement is just before the PROC step whose output you
 wish to capture. The general form of the ODS statement to close a PRINTER file is given by:
   ODS destination_name CLOSE
 where destination_name is either PRINTER, PCL, PDF or PS matching the destination name in your
 opening statement;

ODS PDF FILE = 'c:\Users\tgao4\Desktop\marine2.pdf';
DATA marine;
  INFILE 'c:\Users\tgao4\Desktop\SeaLife.dat';
  INPUT Name $ Family $ Length @@;
PROC MEANS DATA = marine;
  CLASS Family;
  TITLE 'Whales and Sharks';
PROC PRINT DATA = marine;
RUN;
ODS PDF CLOSE;

*---------------------------------;

*Reference: Little SAS Chapter 5.1-5.6;
