*SAS Lecture Note 15-Exporting Data;

*There are 3 general methods for exporting data in SAS: create delimited or text files that the 
 other software can read, or create files in formats like HTML, RTF or XML, or lastly, write the data
 in the other software's native format;
*There are other ways of exporting SAS datasets to other operating environments, such as using CEDA 
 (Cross Environment Data Access), XPORT etc. If you are using SAS9 or later, then you can use the XML
 engine on the libname statement to create XML documents from your SAS datasets. The XML documents 
 can then be transferred to another computer and turned back into SAS datasets using the XML engine 
 for input. See SAS documentation for more info;
*The Export Wizard is a graphical user interface(GUI) to the EXPORT procedure and if you only need to 
 export data once in a while, then it's easier than trying to remember the PROC EXPORT statement. In 
 general, the PROC EXPORT is more powerful (we won't go over the Wizard, you can just go home and
 play with it on your own). The general form of PROC EXPORT is as follows (followed by a semicolon):
   PROC EXPORT DATA = dataset_name OUTFILE = 'filename'
 where dataset_name is the dataset you want to export and the filename is the name you make up for 
 the output data file. Note that the file name requires an extension. Here are some filename
 extensions and DBMS identifiers currently available with the Base SAS. If you specify the DBMS 
 option then it takes precedence over the file extension:
    Type of Files                Extension        DBMS Identifier
    commma-delimited             .csv             CSV
    tab-delimited                .txt             TAB
    space-delimited                               DLM
 Notice that for space-delimited files, there is no standard extension so you must use the sentence
 DBMS=option. Here is an example:
    PROC EXPORT DATA = hotels OUTFILE = 'c:\MyRawData\Hotels.spc' DBMS = DLM REPLACE
 In the above example, the REPLACE option tells SAS to replace any file with the same name. 
 If you want to create a file with a delimiter other than a comma, tab, or space, then you can add the
 DELIMITER statement. If you use the DELIMITER statement, then it does not matter what file extension 
 you use, or what DBMS identifier you specify. The file will have the delimiter that you specify in the 
 DELIMITER statement. For example:
   PROC EXPORT DATA = hotels OUTFILE = 'c:\MyRawData\Hotels.txt' DBMS = DLM REPLACE
   DELIMITER = '@'
 Here the delimiter is the "@" sign and of course, each sentence above will end with a semicolon;

LIBNAME dataset '\\sscwin\dfsroot\users\tgao4\Desktop'; *The LIBNAME statement is used to read the data
                                                         and put the data in a permanent SAS dataset 
                                                         in the directory;                                                                                                                
DATA dataset.class; *Note that you need this particular format to create this DATA step;
  INFILE '\\sscwin\dfsroot\users\tgao4\Desktop\scores.txt';
  INPUT Score @@;
PROC UNIVARIATE DATA = dataset.class PLOT NORMAL; 
  VAR Score;
RUN;       
PROC EXPORT DATA = dataset.class OUTFILE = '\\sscwin\dfsroot\users\tgao4\Desktop\newscore_exported.txt';
RUN;

*We recommend using the "txt" file whenver we are trying to output the file. It's easy to read and at 
 the same time easy to be converted into other types of formats;
 
*---------------------------------;

*We now learn how to use the DATA step to write out a dataset. Uinsg the FILE and PUT statements in the 
 DATA step, you can write almost any form of raw data files. The DATA step gives you flexibility to create 
 raw data files just the way you want. You can pretty much write raw data the same way that you read raw 
 data, with just a few changes. Instead of naming the external file in an INFILE statement, you name it in 
 a FILE statement. Instead of reading variables with an INPUT statement, you can simply write them with a 
 PUT statement. Basically, the INFILE and INPUT statements get raw data into SAS while the FILE and PUT 
 statements get the raw data out of SAS;

LIBNAME travel '\\sscwin\dfsroot\users\tgao4\Desktop';
DATA travel.golf;
  INFILE '\\sscwin\dfsroot\users\tgao4\Desktop\golf.dat';
  INPUT CourseName $18. NumberOfHoles Par Yardage GreenFees;
RUN;
LIBNAME activity '\\sscwin\dfsroot\users\tgao4\Desktop';
DATA _NULL_; *The _NULL_ is a special keyword that tells SAS not to bother making a new SAS dataset. This 
              helps you save computer resources;
  SET activity.golf; *The SET statement here simply reads the dataset;
  FILE '\\sscwin\dfsroot\users\tgao4\Desktop\golf.txt';
  PUT CourseName 'Golf Course' @32 GreenFees DOLLAR7.2 @40 'Par' Par; *Here the PUT statement contains two
                                                                       quoted strings: Golf Course and Par;
RUN;

*---------------------------------;

*No matter what your environment is, you can always create delimited files. One can use the data 
 procedure but can also apply Export Wizard and PROC EXPORT. In addition, ODS(Output Delivery System) 
 discussed before can create comma-separated values (CSV) files from any procedure output and a 
 simple PROC PRINT will produce a reasonable file for importing into other programs. Moreover, using 
 ODS, one can create HTML, RTF or XML file from any procedure output. Here is the general format:
   ODS CSV FILE = 'filepath'
     SAS code you want to write in the CSV file (it could be the PROC PRINT, or other procedures, such
     as PROC FREQ etc.
   ODS CSV CLOSE
 Of course, each sentence needs to be followed by a semicolon;

LIBNAME travel '\\sscwin\dfsroot\users\tgao4\Desktop';
DATA travel.golf;
  INFILE '\\sscwin\dfsroot\users\tgao4\Desktop\golf.dat';
  INPUT CourseName $18. NumberOfHoles Par Yardage GreenFees;
RUN;
ODS CSV FILE = '\\sscwin\dfsroot\users\tgao4\Desktop\golfinfo.csv';
PROC PRINT DATA = travel.golf;
  TITLE 'Golf Course Info';
RUN;
ODS CSV CLOSE;
LIBNAME travel '\\sscwin\dfsroot\users\tgao4\Desktop';
ODS HTML FILE = '\\sscwin\dfsroot\users\tgao4\Desktop\golfinfo.html';
PROC PRINT DATA = travel.golf;
  TITLE 'Golf Course Info';
RUN;
ODS HTML CLOSE;

*---------------------------------;

*Reference: Little SAS Chapter 9.1-9.6;
