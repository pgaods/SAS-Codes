*SAS Lecture Note 13-Some Important Macro Tools;

*Combining macros and macro variables gives you a lot of flexibility for programming, but you can increase that flexibility even more by adding macro statements such as %IF. Here are some general forms of the stateents used for conditional logicl in macros (each sentence followed by a semicolon):
  %IF condition %THEN action
    %ELSE %IF condition %THEN action
    %ELSE action

  %IF condition %THEN %DO
    SAS statements
  %END
Note that these macro statements can be used only inside a macro;

*Of course you can write these conditional logic statements using standard SAS code, the reason we have the parallel macro versions of %IF statements is that the macro version can contain actions that standard IF statements can not contain, such as complete DATA or PROC steps and even other macro statements (so you will have a macro inside a macro);

*Every time you invoke SAS, the macro processor automatically creates certain macro variables. You can use these variables in your programs. The most common automatic macro variables are the following:
  Variable Name    |    Example   |   Description
  &SYSDATE              29MAY02       the character value of the data that job or sessoin began
  &SYSDAY               Wednesday     the day of the weeak that job or session began
For example, you could combine conditional logic and an automatic variable like the following:
  %IF &SYSDAY = Tuesday %THEN %LET country=Belgium
    %ELSE %LET country=France
Of course, each sentence above must be ended with a semicolon;

%MACRO dailyreports_macro;
  %IF &SYSDAY = Monday %THEN %DO;
    PROC PRINT DATA = flowersales;
      FORMAT SaleDate WORDDATE18.;
	  TITLE 'Monday Report: Current Flower Sales';
  %END;
  %ELSE %IF &SYSDAY = Tuesday %THEN %DO;
    PROC MEANS DATA = flowersales MEAN MIN MAX;
	  CLASS Variety;
	  VAR Quantity;
	  TITLE 'Tuesday Report: Summary of Flower Sales';
  %END;
%MEND dailyreports_macro;

DATA flowersales;
  INFILE 'c:\Users\tgao4\Desktop\TropicalSales.dat';
  INPUT CustomerID $ @6 SaleDate MMDDYY10. @17 Variety $9. Quantity;
RUN;

PROC MEANS DATA = flowersales MEAN MIN MAX;
  CLASS Variety;
  VAR Quantity;
  TITLE 'Tuesday Report: Summary of Flower Sales';
RUN;

*---------------------------------;

*When you submit a SAS program containing macros it goes first to the macro processor which generates standard SAS code from the macro reference. Then SAS complies and executes your program. Not until execution, the final stage, does SAS see any actual data values. This motivates us to learn the CALL SYMPUT statement, which takes a value from a DATA step and assigns it to a macro variable. You can then use this macro variable in later steps. To assign a value to a single macro variable, you can use the CALL SYMPUT statement with the following general form:
  CALL SYMPUT ("macro-variable-name", value)
where macro-variable-name enclosed in quotation marks, is the name of a macro variable, either new or old, and value is the value you want to assign to that macro variable. The value term can be the name of a variable whose value SAS will use, or it can be a constant value enclosed in quotation marks. The CALL SUMPUT statement is often used together with the IF-THEN statement in the following way:
  IF Age>=18 THEN CALL SYMPUT("status", "adult")
    ELSE CALL SYMPUT("status", "Minor")
Of course each statement is ended with a semicolon. These statements create a macro variable named &Status and assign to it a value of eithe rAdult or MInor depending on the variable Age;

*A word of caution: you cannot create a macro variable with CALL SYMPUT and use it in the same DATA step because SAS does not assign a value to the macro variable till the DATA step executes. DATA steps execute when SAS encounters a step boundary such as subsequent DATA, PROC, or RUN statement;

DATA flowersales;
  INFILE 'c:\Users\tgao4\Desktop\TropicalSales.dat';
  INPUT CustomerID $ @6 SaleDate MMDDYY10. @17 Variety $9. Quantity;
PROC SORT DATA = flowersales;
  BY DESCENDING Quantity;
DATA _NULL_;
  SET flowersales;
  IF _N_ = 1 THEN CALL SYMPUT ("selectedcustomer", CustomerID);
  ELSE STOP;
PROC PRINT DATA = flowersales;
  WHERE CustomerID = "&selectedcustomer";
  FORMAT SaleDate WORDDATE18.;
  TITLE "Customer &selectedcustomer Had the Single Largest Order";
RUN;
*This program says the following: First we sort the data, then we use the CALL SYMPUT to assign the value of the variable CustomerID to the macro variable &selectedcustomer when _N_ = 1 (the first iteration of the DATA step). Since that is all we need from this DATA step, we can use the STOP statement to tell SAS to end this DATA step. The STOP statement is not necessary, but it is efficient because it prevents SAS from reading the remaining observations for no reason. When SAS reaches the PROC PRINT step, SAS knows that the DATA step has ended so SAS executes the DATA step. At this point, the macro variable &selectedcustomer has the value 356W (the customer's ID with the largest single order) and can be used in the PROC PRINT. This is a hard problem!;

*---------------------------------;

*Lastly, we learn how to debug macro errors. First things first, the general procedure to avoid mistakes is to write
 your program in standard SAS code first, then when it's bug-free, add the macro logic one feature at a time. Add 
 your %MACRO and %MEND statements. When that's working, add your macro variables, one at a time, and so on, until your
 macro is complete and bug-free;

*For quoting problems, the macro processor does not resolve macros inside single quotation marks, To get around this, 
 use double quotation marks whenever you refer to a macro or macro variable and you want to SAS to resolve it. So the
 rule of thumbs is that whenever macro is involved, try the double quotation mark in order for the macro to run;

*Regarding system options for debugging macros: the next five system, options affect the kinds of messages SAS writes 
 in your log. The default settings appear in bold:
   MERROR|NOMERROR  when this option is on, SAS will issue a warning if you invoke a macro that SAS cannot find
   SERROR|NOSERROR  when this option is on, SAS will issue a warning if you use a macro variable that SAS cannot find
   MLOGIC|NOMLOGIC  when this option is on, SAS prints in your log details about the execution of macros
   MPRINT|NOMPRINT  when this option is on, SAS prints in your log the standard SAS code generated by macros
   SYSMBOLGEN|NOSYMBOLGEN  when this option is on, SAS prints in your log the values of macro variables
 While you want the MERROR and SERROR options to be on at all time, you will probably want to turn on MLOGIC, MPRINT
 and SYMBOLGEN one at a time and only wihle you are debugging since they tend to make your log hard to read. To turn 
 them on or off, use the OPTIONS statement, for example:
   OPTIONS MPRINT NOSYSMBOLGEN NOMLOGIC
 Details of what those warnings look like can be found on pp.212-213;


*---------------------------------;

*Reference: Little SAS Chapter 7.5-7.7;
