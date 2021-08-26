*SAS Lecture Note 12-Intro to Macro Facility;

*Macros allow you to write a piece of code once and use it over and over, in the same program 
 or in different prpograms You can even store programs in a central location, which is called an  autocall library, and share them between programs and between programmers. In essence, SAS
 must pass your macro statements to the macro processor which resolves your macros generating 
 standard SAS code, before SAS can compile and execute your program. Because you are writing 
 a program that writes a program, this is sometimes called meta-programming;

*SAS macro code consists of two basic parts--macros and macro variables. The names of macro
 variables are prefixed with an ampersand sign "&" while the names of macros are prefixed with a
 percent sign "%". A macro variable has only a single value, and it does not belong to a dataset.
 Its value is always character. This value could be a variable name, a numeral, or any text that
 you want substitued into your program. A macro, on the other hand, is a larger piece of a
 program that may contain complex logic including DATA and PROC steps and macro statements such
 as %DO, %END, and %IF-%THEN/%ELSE statements. 

*Macro variables can be either local or global. A macro variable is local if it is defined 
 inside a macro. It is global if it is defined in open code which is everything outside a macro. 
 You can use a global macro variable anywhere in your program, but you can use a local macro   variable only inside its own macro. Before you can use macros you must have the MACRO system
 option turned on. This option is usually turned on by default, but may be turned off, especially 
 on mainframes, because SAS runs slightly faster when it doesn't have to bother with checking for  macros. If you are not sure whether the MACRO option is turned on, you can find out by typing the  following statement:
   PROC OPTIONS OPTION = MACRO
   RUN
 Check your SAS log. If you see the option MACRO, then the macro processor is turned on, and you
 can use it. If you see NOMACRO there, then you need to specify the MACRO option at invocation 
 or in a configuration file. To get more details on this, check the SAS help documentations;

*To avoid macro errors, we highly suggest you write the standard SAS code first, then when you 
 make sure that it is bug free, you can convert it to macro logic adding one feature at a time;


*---------------------------------;

*We now learn how to create a macro variable with the "%LET" statement. When SAS encounters the name 
 of a macro variable, the macro processor simply replaces the name with the value of that macro variable. That value is a character constant that you specify. The simplest way to assign a value to 
 a macro variable is with the %LET statement. The general form of this statement is:
   %LET macro-variable-name = value
 where macro-variable-name must follow the rules for SAS variable names (32 characters or fewer in
 length, start with a letter or underscore, and contain only letters, numerals, and underscores). 
 Value here is the text to be substituted for the macro variable name, and can be longer than you are ever likely to need. For example, the following statements each create a macro variable:
   %LET iterations = 10
   %LET country = New Zealand
 Notice that unlike an ordinary assignment statement, value does not require quotation marks even when
 it contains characters. Except for blanks at the beginning and end, which are trimmed, everything 
 between the equals sign and the semicolon becomes part of the value for that macro variable;

*We now learn how to use a macro variable. To do so, you simply add the ampersand prefix "&" and stick 
 the macro variable name wherever you want its value to be substituted. Keep in mind that the macro
 processor doesn't look for macros inside single quotation marks. To get around this, simply use the 
 double quotation marks. Here are some examples:
   DO i=1 to &iterations
   TITLE "Addresses in &country"
 After being resolved by the macro processor, these statements would become the following:
   DO i=1 to 10
   TITLE "Addresses in New Zealand"
 Of course, each sentence should be followed by a semicolon;

%LET flowertype = Ginger;
DATA flowersales;
  INFILE 'c:\Users\tgao4\Desktop\TropicalSales.dat';
  INPUT CustomerID $ @6 SaleDate MMDDYY10. @17 Variety $9. Quantity;
  IF Variety = "&flowertype";
PROC PRINT DATA = flowersales;
  FORMAT SaleDate WORDDATE18.;
  TITLE "Sales of &flowertype";
RUN; *Note that because the variable &flowertype is defined outside a macro, it is a global macro variable and can be used anywhere in this program. In this case, the value Gingeris substituted for &flowertype in a subsetting IF sttement and a TITLE statement;

*---------------------------------;

*We now learn how to write the general form of a macro. You can think of a macro as a sandwich. The 
 %MACRO macro-name and %MEND macro-name statements are like two slices of bread. Between those slices 
 you can put any statements you want. The general form of a macro is given by:
   %MACRO macro-name
     macro-text
   %MEND macro-name 
 The macro-name in the %MEND statement is optional but we recommend you put it there to ease debugging.
 Of course, each sentence is ended with a semicolon. The %MACRO statement tells SAS that this is the
 beginning of a macro while the %MEND statement marks the end. Macro-name is a name you make up, and
 it can be 32 characters in length, start with a letter or undersore, and contain only letters, 
 numerals or underscores. After you have defined a macro you can invoke it by adding the percent sign prefix to its name like this:
   %macro-name
 Note that in this case, a semicolon is not required when invoking a macro, though adding one
 generally does not harm. We now give an example of a macro with no parameters. Parameters, simply 
 put, are just macro variables whose value you set when you invoke a macro. We will cover more
 examples with parameters later;

DATA flowersales;
  INFILE 'c:\Users\tgao4\Desktop\TropicalSales.dat';
  INPUT CustomerID $ @6 SaleDate MMDDYY10. @17 Variety $9. Quantity;
RUN;

%MACRO samples; *We will call our macro program samples. This is the beginning of our macro, so later you shall expect to see a MEND statement ending our macro;
  PROC SORT DATA = flowersales;
    BY DESCENDING Quantity;
  PROC PRINT DATA = flowersales (OBS=5);
    FORMAT SaleDate WORDDATE18.;
    TITLE 'Five Largest Sales';
%MEND; *So now we have finished creating our macro program, called samples;

%samples; *This statement invokes the macro!;
RUN;

*The above program does the following: it creates a macro named %sample to sort the data by Quantity and print the five observations with the largest sales. The program reads the data in a standard DATA step and invokes the macro. Note that this macro is very limited because it does
 the same thing every time;

*---------------------------------;

*The macros in this book are defined and invoked inside a single program, but you can also store macros in a central location, called an autocall library. Macros in a library can be shared by programs and programmers Basically you save your macros as files in a directory or as members of a partitioned dataset (depending on your operating environment), and use the MAUTOSOURCE and SASAUTOS=system options to tell SAS where to look for macros. Then you can invoke a macro even though the original macro does not appear in your program; 

*---------------------------------;


*We now learn how to write macros with parameters. Parameters are macro variables whose value you set when you invoke a macro. To add parameters, you simply list the macro-variable names between parentheses in the %MACRO statement. Here is one of the possible forms of the parameter-list:
   %mACRO macro-name (parameter1 = , parameter2= ,...parameterk= )
     macro-text
   %MEND
 For example, a macro named %Quarterly might start like this:
   %MACRO Quarterly (quarter=, salesrep= )
 This macro has two parameters: &quater and &salesrep. You could invoke the macro with this statement:
   %Quarterly (quarter=3, salesrep=Smith)
 Then the SAS macro processor would replace each occurrence of the macro variable &quarter with the value 3 and would substitute Smith for &salesrep;

%MACRO select_macro (customer=, sortvar= );
  PROC SORT DATA = flowersales OUT = saleout;
    BY &sortvar;
    WHERE  CustomerID = "&customer";
  PROC PRINT DATA = saleout;
    FORMAT SaleDate WORDDATE18.;
  TITLE1 "Orders for Customer Number &customer";
  TITLE2 "Sorted by &sortvar";
%MEND select_macro;

DATA flowersales;
  INFILE 'c:\Users\tgao4\Desktop\TropicalSales.dat';
  INPUT CustomerID $ @6 SaleDate MMDDYY10. @17 Variety $9. Quantity;
RUN;

*We now invoke the macros;
%select_macro(customer=356W, sortvar=Quantity)
%select_macro(customer=240W, sortvar=Variety)
RUN;


*---------------------------------;

*Reference: Little SAS Chapter 7.1-7.4;
