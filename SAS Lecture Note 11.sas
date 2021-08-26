*SAS Lecture Note 11-Advanced Topics in Dataset Modification;

*We now learn how to combine a grand total with the original dataset. To do so, note that the MERGE
 statements won't work anymore because we don't have any common variables from the BY statements.
 So instead, we use two SET statements to achive our goal:
   DATA new-dataset-name
     IF _N_ = 1 THEN SET summary-dataset-name
     SET original-dataset-name
 In this datastep above, the original datset is the one with more than one observation (the original 
 data) and summary dataset is the dataset with a single observation (which is the grand total). SAS 
 reads the original dataset in a normal SET statement, simply reading observations in a 
 straightforward way. SAS also reads the summary dataset with a SET statement but only in the first 
 iteration of the DATA step (when _N_ = 1). SAS then retains the values of variables from the 
 summary-dataset for all observations in a new dataset. This works because variables read with a SET 
 statement are automatically retained. This technique can be used any time you want to combime a 
 single observation with many observations without a common variable;

DATA shoes;
  INFILE 'c:\Users\tgao4\Desktop\shoesales.dat';
  INPUT Styles $ 1-15 ExerciseType $ Sales;
PROC MEANS NOPRINT DATA = shoes;
  VAR Sales;
  OUTPUT OUT = summarydata SUM(Sales) = GrandTotal;
PROC PRINT DATA = summarydata;
  TITLE 'Summary Dataset';
DATA shoesummary;
  IF _N_ = 1 THEN SET summarydata;
  SET shoes;
  Percent = Sales/GrandTotal*100;
PROC PRINT DATA = shoesummary;
  VAR Styles ExerciseType Sales GrandTotal Percent;
  TITLE 'Overall Sales Share';
RUN;

*---------------------------------;

*We now learn the UPDATE statement which is useful in many applications related to financial data. 
 For example, a bank account is a good example of this type of transaction-oriented data, since it is
 regularly updated with credits and debits. The UPDATE statement is similar to the MERGE statement 
 because both combines datasets by matching observations by common variables. However, there are some
 critical differences: First, with UPDATE the resulting master dataset always has just one 
 observation for each unique value of the common variables. That way, you don't get a new observation
 for your bank account every time you deposit a paycheck. Second, missing values in the transaction 
 dataset do not overwrite existing values in the master dataset. That way, you are not obliged to 
 enter your address and tax ID number every time you make a withdrawal. The basic form of the UPDATE 
 statement is:
   DATA master-dataset
     UPDATE master-dataset transaction-dataset
     BY variable-list
 Note that you can specify only 2 datasets--one master and one transation. Both datasets must be 
 pre-sorted by their common variables. Most importantly, the values of those BY variables must be 
 unique in the master-dataset. Using the bank example, you could have many transactions for a single 
 account, but only one observation per account in the master dataset;

*The following example illustrates our point. A hospital maintains a master database with info
 about patients. Each record contains the patient's account number, last name, address, date of
 birth, sex, insurance code, and the date that patient's info was last updated. Whenever a patient
 is admitted to the hospital, the admissions staff check the data for that patient. They create a 
 transaction record for every new patient and for any returning patients whose status has changed.
 Since the master datasets are usually updated frequently, they are usually saved as permanent SAS
 dataset. In this example, we set up a permanent dataset on the Desktop by using the command and 
 call it perm.patientmaster;
LIBNAME perm 'c:\Users\tgao4\Desktop';
DATA perm.patientmaster;
  INFILE 'c:\Users\tgao4\Desktop\Admit.dat';
  INPUT Account LastName $ 8-16 Address $ 17-34 Birthday MMDDYY10. 
        Sex $ InsCode $ 48-50 @52 LastUpdate MMDDYY10.;
RUN;

LIBNAME perm 'c:\Users\tgao4\Desktop';
DATA transactions;
  INFILE 'c:\Users\tgao4\Desktop\NewAdmit.dat';
  INPUT Account LastName $ 8-16 Address $ 17-34 Birthday MMDDYY10. 
        Sex $ InsCode $ 48-50 @52 LastUpdate MMDDYY10.;
PROC SORT DATA = transactions;
  BY Account; *Note that the master dataset has been sorted by Account, so there is no need to sort
              it again;
DATA perm.patientmaster;
  UPDATE perm.patientmaster transactions;
  BY Account;
PROC PRINT DATA = perm.patientmaster;
  FORMAT Birthday LastUpdate MMDDYY10.; 
  TITLE 'Updated Admissions Data';
RUN; *Pay close attention to the output and compare it with the original dataset and you shall see 
      how info is updated by using the UPDATE...BY...statement!;

*---------------------------------;

*The SAS language generally has 3 basic types of options: system options, statement options and
 dataset options. System options have the most global influence, followed by statement options, with
 dataset options having the most limited effect. System options are those that stay in effect for
 the duration of your job or session. These options affect how SAS operates and are generally issued
 when you invoke SAS or via an OPTIONS statement. System options include the CENTER option, which
 tells SAS to center all output, and the LINESIZE= option, which sets the maximum line length for 
 output. Statement options appear in individual statements and influece how SAS runs that particular
 DATA or PROC step. For example, the NOPRINT option is one of them;

*In contrast, dataset options affect only how SAS reads or writes an individual dataset. You can use
 dataset options in DATA steps(in DATA, SET, MERGE, or UPDATE statements) or in PROC steps (in 
 conjunction with a DATA= statement option). To use a dataset options, you can simply put it between 
 parentheses directly following the dataset name. These are the most frequently used dataset options
 below:
         Command                                           Functions of Options
   KEEP = variable-list                         -tells SAS which variables to keep
   DROP = variable-list                         -tells SAS which variables to drop
   RENAME = (old-variable = new-variable)       -tells SAS to rename certain variables
   FIRSTOBS = n                                 -tells SAS to start reading at observation n
   OBS = m                                      -tells SAS to stop reading at observation m
   IN = new-variable-name                       -creates a temporary variable for tracking whether
                                                 that dataset contributed to the current observation
                                                 (see the next few coming examples)
 Here are examples for the above commands:
   Example 1:
     DATA smallanimals
     SET animals (KEEP = Cat Mouse Rabbit)
   PROC PRINT DATA = smallanimals (DROP = Cat Elephant)
   Example 2:
   DATA animals (RENAME = (Cat=Feline Dog=Canine Bear=Ursine))
 Note that the dataset options can be used in DATA or PROC steps and can apply to input or output 
 datasets. Note also that these options do not change input datasets. They merely change what is 
 read from the input datasets;
   
*You can also use the FIRSTOBS= and OBS= to control which data points are to be read. For example,
 the following example shows how to use options to tell SAS to read only 20 observations:
   DATA animals
     SET animals (FIRSTOBS = 100 OBS = 120)
   PROC PRINT DATA = animals (FIRSTOBS = 101 OBS = 120)
 Note that these statement options only apply to raw data files being read with an INFILE statement
 whereas the dataset options apply only to existing SAS datasets that you read in a DATA or PROC 
 step. The system options apply to all files and datasets. If you use similar system and dataset 
 options, the dataset option will override the system option for that particular dataset;

*---------------------------------;

*We now learn how to use the IN= option to create tracking variables. The IN= option creates a new 
 variable which is temporary and has the name you specify in the option. For example, below SAS just
 created two temporary variables, one named InA and the other nameed InH:
   DATA animals
     MERGE animals (IN = InA) habitat (IN = InH)
     BY Species
 These variables exist only for the duration of the current DATA step and are not added to the 
 dataset being created. The nice thing is that SAS gives IN= variable a value of 0 if that dataset 
 did not contribute to the current observation and a value of 1 if it did. So a value of 0 means the 
 dataset does not contribute. So you can use the IN= variable to track, select, or eliminate 
 observations based on the data set of origin. This is the primary use of the IN= option. It is sort
 of like a tag or like an isotope in physics;

*The IN= option can be used any time you read a SAS dataset in a DATA step--with SET, MERGE, or 
 UPDATE--but is mostly used with MERGE. To do so, you simply put the option in parentheses directly 
 following the dataset you want to track, and specify a name for the IN= variable. For example, the
 DATA step below creates a datset named "both" by merging two datasets named "state" and "county". 
 Then the IN= option creates two variables named trackstate and trackcounty for tagging purposes:
   DATA both
     MERGE state (IN = trackstate) county (IN = trackcounty)
     BY Statename
 ;

DATA customer;
  INFILE 'c:\Users\tgao4\Desktop\CustAddress.dat' TRUNCOVER;
  INPUT Idno 1-4 Name $ 5-21 Address $ 23-42;
PROC SORT DATA = customer;
  BY Idno;
DATA orders;
  INFILE 'c:\Users\tgao4\Desktop\OrdersQ3.dat';
  INPUT Idno 1-4 Total 5-11;
PROC SORT DATA = orders;
  BY Idno;
DATA noorders;
  MERGE customer orders (IN = recent);
  BY Idno;
  IF recent = 0;
PROC PRINT DATA = noorders;
  TITLE 'Customers with No Orders in the 3rd Quarter';
RUN;

*---------------------------------;

*We now learn how to create multiple datasets using only a single DATA step. To do so, we should 
 first list the datasets in the DATA step, then use the OUTPUT statement to create multiple datasets.
 For example, you can create two datasets by stating DATA lions bears. However, if this is all you 
 do, then SAS will write all the observations to all the datasets, and you will have two identical 
 datasets. So now you need the OUTPUT statement equipped with IF-THEN statements to create 2 distinct
 datasets. This section basically teaches you how to split a big dataset into 2 separate smaller 
 datasets, both of which share some commonalities from the master dataset;

*Every DATA step has an implied OUTPUT statement at the end which tells SAS to write the current 
 observation to the output dataset before returning to the beginning of the DATA step to process the
 next observation. You can override this implicit OUTPUT statement with your own OUTPUT statement. 
 The basic form of the OUTPUT statement is OUTPUT dataset-name. For example:
   IF family = 'Ursine' THEN OUTPUT bears
 This statement basically says if family = 'Ursine', then we put this observation into the dataset
 called bears. You can have multiple IF...THEN OUTPUT = dataset-name statements;

DATA morning afternoon;
  INFILE 'c:\Users\tgao4\Desktop\zoo.dat';
  INPUT Animal $ 1-9 Class $ 1-18 Enclosure $ FeedTime $;
    IF FEEDTIME = 'am' THEN OUTPUT morning; *This says if FeedTime = 'am', then we will put the 
                                             observation in the dataset called morning;
      ELSE IF FeedTime = 'pm' THEN OUTPUT afternoon;
      ELSE IF FeedTime = 'both' THEN OUTPUT; *The final OUTPUT statement does not specify a dataset,
                                              so SAS will put add those observations to both of the
                                              datasets morning and afternoon;
PROC PRINT DATA = morning;
  TITLE 'Animals with morning feedings';
PROC PRINT DATA = afternoon;
  TITLE 'Animals with afternoon feedings';
RUN;

*---------------------------------;

*We now learn a hard topic--how to make several observations from one using the OUTPUT statement.
 Usually SAS writes an observation to a dataset at the end of the DATA step, you can put an OUTPUT 
 statement in a DO loop or just use use several OUTPUT statements. The OUTPUT statement gives you  
 control over when an observation is written to a SAS dataset. If your DATA step doesn't have an   
 OUTPUT statement, then it is implied at the end of the step. Once you put an OUTPUT statement in 
 your DATA step, SAS will write an observation only when it encounters an OUTPUT statement;

*The following program demonstrates how you can use an OUTPUT statement in a DO loop to generate
 data. Here we have a mathematical equation y=x^2 and we want to generate data points for later  
 plotting. So we create data for variables x and y in the following program;
DATA generate;
  DO x=1 TO 6;
     y=x**2; *Note that in SAS to raise the power of a number, the notation is ** instead of ^;
     OUTPUT;
  END;
PROC PRINT DATA = generate;
RUN;

*Compare the above program with the following program. The only difference between them is that in 
 the following program we omit the OUTPUT statement in the DO loop. The consequence is that SAS only
 spits out one pair of observations (check the output! c.f. pp.192-193);
DATA generate;
  DO x=1 TO 6;
     y=x**2;
  END;
PROC PRINT DATA = generate;
RUN;

*Here is another example that shows how you can use OUTPUT statements to create several observations 
 from a single pass through the DATA step. The following data are for ticket sales at three movie 
 theaters. After the month are the theaters' names and sales for all three theaters:
    Jan Varsity 56723 Downtown 69831 Super-6 70025
    Feb Varsity 62137 Downtown 43901 Super-6 81534
    Mar Varsity 49982 Downtown 55783 Super-6 69800
 Note that the dataset is very weird: the first variable is month, second is theater name and the
 third is tickets sales. However, the fourth variable goes back to theater name (instead of month),
 followed by ticket sales again. So the dataset is not ideal in the sense that we don't have a month
 variable which would make our data-reading process extremely easy. If our dataset is ideal in the
 sense that it looked like the following, then we can use tricks we learned from the second lecture 
 to read the data using @@:
    Jan Varsity 56723 Jan Downtown 69831 Jan Super-6 70025
    Feb Varsity 62137 Feb Downtown 43901 Mar Super-6 81534
    Mar Varsity 49982 Feb Downtown 55783 Mar Super-6 69800
 ;
DATA theaters;
  INFILE 'c:\Users\tgao4\Desktop\Idealmovies.txt';
  INPUT Month $ Location $ Tickets @@;
PROC PRINT DATA = theaters;
RUN;

*Going back to the hard case, for the analysis you want to have the theater name as one variable and 
 the ticket sales as another variable. The month should be repeated three times, once for each 
 theater. The following program has three INPUT statements all reading the same raw data file. The 
 first INPUT statement reads values for Month, Location, and Tickets, and then holds dataline using 
 the trailing sign @. The OUTPUT statement that follows writes an observation. The next INPUT 
 statement reads the second set of data for Location and Tickets and again holds the dataline. 
 Another OUTPUT statement writes another observation. The last INPUT statement reads the last values 
 for Location and Tickets, this time releasing the dataline for the next iteration through the DATA 
 step. The program thus has 3 OUTPUT statements for the three observations created in each iteration 
 of the DATA step;
DATA theaters;
  INFILE 'c:\Users\tgao4\Desktop\Movies.dat';
    INPUT Month $ Location $ Tickets @;
    OUTPUT;
    INPUT Location $ Tickets @;
    OUTPUT;
    INPUT Location $ Tickets;
    OUTPUT;
PROC PRINT DATA = theaters;
RUN;
*The output looks like the following:
    Obs Month Location Tickets 
      1 Jan Varsity 56723 
      2 Jan Downtown 69831 
      3 Jan Super-6 70025 
      4 Feb Varsity 62137 
      5 Feb Downtown 43901 
      6 Feb Super-6 81534 
      7 Mar Varsity 49982 
      8 Mar Downtown 55783 
      9 Mar Super-6 69800 
 ;

*Compare the above code with the following codes, for more details of this section, c.f. pp.192-193;
DATA theaters;
  INFILE 'c:\Users\tgao4\Desktop\Movies.dat';
    INPUT Month $ Location $ Tickets @;
    OUTPUT;
    INPUT Location $ Tickets @;
    OUTPUT;
PROC PRINT DATA = theaters;
RUN;

DATA theaters;
  INFILE 'c:\Users\tgao4\Desktop\Movies.dat';
    INPUT Month $ Location $ Tickets @;
    OUTPUT;
PROC PRINT DATA = theaters;
RUN;

*---------------------------------;

*We now learn how to use PROC TRANSPOSE to change observations to variables, that is to say, to flip
 the data. In general, the PROC TRANSPOSE procedure turns observations into variables or variables 
 into observations. This procedure is rarely used, but for most of the time, it is easy to use when 
 you want to convert observations into variables. The general form of the PROC TRANPOSE commands are:
   PROC TRANSPOSE DATA = old-dataset OUT = new-dataset
     BY variable-list
     ID variable
     VAR variable-list
 1) The old-dataset refers to the SAS dataset you want to transpose, and the new-dataset is the name
    of the newly transposed dataset.
 2) BY: you can use the BY statement if you have any grouping variables that you want to keep as 
    variables. These variables are included in the transposed dataset, but they are not themselves 
    transposed. In other words, these variables are kept as they are supposed to be in the old
    dataset. Of course, as usual, you need to presort these variables!
 3) ID: The ID statement names the unique variable whose formatted values will become the new
    variable names. The ID values must occur only once in the dataset, or if a BY statement is
    present, then the values must be unique within BY-groups. Usually the ID variable will be     
    categorical in nature, but it could be numeric. If you don't use an ID statement then the new  
    variables will be named COL1, and COL2 etc. 
 4) VAR: The VAR statement names the variables whose values you want to transpose. Usually, SAS 
    creates a new variable called _Name_ which has values the names of the variables in the VAR
    statement. If you have more than one VAR variable, then the _Name_ will have more than one value.
 The description of this procedure will not suffice. We will demonstrate its usage by examples;

*Suppose you have the following data about players for minor league baseball teams. Below are the 
 INPUT variables: 1) Team 2) Player 3) Type (categorical, there are two categories called salary and
 batavg) 4) Entry (numerical). My goal is to sort Team and Player and 'flip' between Type and Entry,
 that is to say, I want to create two variables called salary and batavg, each identified by the 
 numerical value specified in Entry. Here is how we should do it;
DATA baseball;
  INFILE 'c:\Users\tgao4\Desktop\transpos.dat';
  INPUT Team $ Player Type $ Entry;
PROC SORT DATA = baseball;
  BY Team Player;
PROC PRINT DATA = baseball;
  TITLE 'Data before Transposing';
PROC TRANSPOSE DATA = baseball OUT = flipped;
  BY Team Player;
  ID Type;
  VAR Entry;
PROC PRINT DATA = flipped;
  TITLE 'Data after Transposing';
RUN;

*The next program is another example--this time we put two variables in the VAR command, and there 
 are 3 categories in the Type variable now. Pay attention to the final output! Note that there are
 missing values in certain columns;
DATA baseball2;
  INFILE 'c:\Users\tgao4\Desktop\transpos2.txt';
  INPUT Team $ Player Type $ Entry Fees;
PROC SORT DATA = baseball2;
  BY Team Player;
PROC PRINT DATA = baseball2;
  TITLE 'Data before Transposing';
PROC TRANSPOSE DATA = baseball2 OUT = flipped2;
  BY Team Player;
  ID Type;
  VAR Entry Fees;
PROC PRINT DATA = flipped2;
  TITLE 'Data after Transposing';
RUN;
 
*---------------------------------;

*The last topic is about automatic variables. In addition to variables you create in your SAS 
 datasets, SAS actually creates a few more called automatic variables. You don't usually see them 
 because they are temporary and are not saved with your data. But they are available in the DATA 
 step, and you can use them just like you use any variable that you create yourself:
 1) _N_ and _ERROR_: these two variables are always avaialble. _N_ indicates the number of times SAS
   has looped thru the DATA step. This is not necessarily equal to the observation number, since a
   simple subsetting IF statement can change the relationship between observation number and the
   number of iterations of the DATA step. The _ERROR_ variable has a value of 1 if there is a data
   error for the observation and 0 if there is no problem. Things that can cause data errors include 
   invalid data(say, characters in numerical fields), conversion error (like division by 0), and 
   illegal arguments in functions (like log(0) etc.).
 2) FIRST.variable and LAST.variable: these two variables are only available when you use a BY
    statement in a DATA step. The FIRST.variable = 1 if SAS is processing an observation with the 
    first occurence of a new value for that variable and FIRST.variable = 0 for other observations.
    The LAST.variable = 1 for an observation with the last occurence of a value for that particular
    variable and = 0 for the other observations.
 Now we look at an example. This technique is useful but rarely used in practice;

DATA walkers; 
  INFILE 'c:\Users\tgao4\Desktop\Walk.dat';
  INPUT Entry AgeGroup $ Time @@;
PROC SORT DATA = walkers;
  BY Time;
DATA order; *We now create a new variable called 'place';
  SET walkers;
  Place = _N_;
PROC PRINT DATA = order;
  TITLE 'Walk Competition Results';
PROC SORT DATA = order;
  BY AgeGroup Time;
DATA winners;
  SET order;
  BY AgeGroup;
  IF FIRST.Agegroup = 1; *this keeps only the first observation in the BY group. Since the winners'
                          dataset is sorted by AgeGroup and Time, the first observation in each BY
                          group is the top finisher of that group;
PROC PRINT DATA = winners;
  TITLE 'Winners in Each Age-group';
RUN;

*Here is what the commands say: your hometown is having a walk around the town to raise money for the
 library. You have data on entry number, age group, and finishing time. The first thing you want to
 do is to create a new variable for overall finishing place and print the result. The first part of
 the program reads the raw data and sorts it by finishing time. Then another DATA step creates the 
 new variable called Place, and gives it the current value of _N_. The second part of this prorgram
 produces a list of the top finishers in each category. The dataset called order containing the new 
 Place variable is sorted first. In the DATA step, the BY statement generates the FIRST.AgeGroup 
 temporary variables. Then we do a subsetting IF statement. Notice that in the result the temporary 
 variable _N_ does not appear in the printout;

*---------------------------------;

*Reference: Little SAS Chapter 6.7-6.14;



