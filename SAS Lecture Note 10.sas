*SAS Lecture Note 10-Dataset Combination Using Merge;

*When you want to match observations from one dataset with observations from another, use the MERGE
 statement in the DATA step. If you know the two datasets are in exactly the same order, you don't 
 have to have any common variables between the datasets. However, for most of the times, you will 
 need at least one variable for matching purposes, or several variables which, taken together, 
 uniquely identify each observation. We first learn how to do a one-to-one matching. For example, 
 to merge patient data with billing data, you would use the patient ID as a matching variable. 
 Otherwise, you risk getting Mary Smith's visit to the obstetrician mixed up with Matthew Smith's 
 visit to the optometrist. To merge datasets, first, sort the data by the common variable(s). Then, 
 in the DATA statement, name the new SAS dataset to hold the results and follow with a MERGE 
 statement listing the two datasets to be combined. Finally, use a BY statement to indicate the 
 common variable(s):
   DATA new-dataset-name
     MERGE dataset-1 dataset-2
     BY common-variable-list
 If you merge two datasets, and they happen to have variables with the same names--besides the BY 
 variables--then variables from the second dataset will overwrite any variables having the same 
 name in the first datset. So you gotta be careful when you use the MERGE statement;

*Here is an example. A Belgian chocolatier keeps track of the number of each type of chocolate sold
 each day. The code number for each chocolate and the number of pieces sold that day are kept in 
 one file. In another separate file she keeps the names and descriptions of each chocolate as well 
 as the code number. In order to print the day's sales along with the descriptions of the 
 chocolates, the two files must be merged together using the code number as the common variable. 
 Here comes the set of commands below;
DATA chocodescript;
  INFILE 'c:\Users\tgao4\Desktop\chocolate.dat' TRUNCOVER;
  INPUT CodeNum $ 1-4 Name $ 6-14 Description $ 15-60;
DATA sales;
  INFILE 'c:\Users\tgao4\Desktop\chocsales.dat';
  INPUT CodeNum $ 1-4 PiecesSold 6-7;
PROC SORT DATA = sales;
  BY CodeNum;
DATA chocolates;
  MERGE sales chocodescript;
  BY CodeNum;
PROC PRINT DATA = chocolates;
  TITLE 'Chocolate Sales';
RUN; *Note that if you look at the output window, the final datast has a missing value for the 
      variable PiecesSold in the seventh observation. This is because there were no sales for the 
      Pyramide chocolate. All observations from both datasets were included in the final dataset 
      whether they had a match or not;

*In Lecture 2 we covered the INFILE optional statement MISSOVER, but we did not cover TRUNCOVER. 
 Here we will cover both. A good reference is the online tutorial. Simply put, the MISSOVER
 prevents the DATA step from going to the next line if it does not find values in the current 
 record for all of the variables in the INPUT statement. Instead, the DATA step assigns a missing 
 value for all variables that do not have complete values. In contrast, the TRUNCOVER causes the 
 DATA step to assign the raw data value to the variable even if the value is shorter than expected 
 by the INPUT statement. If, when the DATA step encounters the end of an input record, there are 
 variables without values, the variables are assigned missing values for that observation;

*When a DATA step reads raw data from an external file, problems can occur when SAS encounters the 
 end of an input line before reading in data for all variables specified in the input statement. 
 This problem can occur when reading variable-length records and/or records containing missing 
 values. The following is an example of an external file that contains variable-length records:
 
 ----+----1----+----2

 22
 333
 4444
 55555 

 The following DATA step uses the numeric informat 5. to read a single field in each record of raw 
 data and to assign values to the variable TestNumber. The semicolon signs are omitted for
 illustrative purposes:
 
 DATA numbers
   INFILE 'your-external-file'
   INPUT TestNumber 5.
 RUN
 PROC PRINT DATA = numbers
 RUN

 The DATA step reads the first value (22). Because the value is shorter than the 5 characters 
 expected by the informat, the DATA step attempts to finish filling the value with the next record 
 (333). This value is entered into the PDV and becomes the value of the TestNumber variable for the
 first observation. The DATA step then goes to the next record, but encounters the same problem 
 because the value (4444) is shorter than the value that is expected by the informat. Again, the 
 DATA step goes to the next record, reads the value (55555), and assigns that value to the 
 TestNumber variable for the second observation. The following output shows the results. After this
 program runs, the SAS log contains a note to indicate the places where SAS went to the next record
 to search for data values:

                                 Obs    Test Number
                                  1        333
                                  2      55555

 To avoid this, two options are available, depending on specific circumstances: MISSOVER and 
 TRUNCOVER. The MISSOVER option prevents the DATA step from going to the next line if it does not 
 find values in the current record for all of the variables in the INPUT statement. Instead, the
 DATA step assigns a missing value for all variables that do not have complete values according to 
 any specified informats. If we use MISSOVER in the INFILE statement, we will have an output like
 the following:

                                 Obs    Test Number

                                  1          .
                                  2          .
                                  3          .
                                  4      55555
 
 Because the fourth record is the only one whose value matches the informat, it is the only record 
 whose value is assigned to the TestNumber variable. The other observations receive missing values.
 
 The TRUNCOVER option causes the DATA step to assign the raw data value to the variable even if the
 value is shorter than the length that is expected by the INPUT statement. If, when the DATA step 
 encounters the end of an input record, there are variables without values, the variables are 
 assigned missing values for that observation. If we used TRUNCOVER, we get output like this:
 
                                 Obs    Test Number

                                  1         22
                                  2        333
                                  3       4444
                                  4      55555
 This result shows that all of the values were assigned to the TestNumber variable, despite the 
 fact that three of them did not match the informat;

*---------------------------------;

*Sometimes you need to combine two datasets by matching one observation from one dataset with more 
 than one observation in another. For example, you had data for every state in the US and wanted to
 combine it with data for every county. This would be a one-to-many match merge because each state 
 observation matches with many county observations. Luckily, the statements for a one-to-many match
 merge are identical to the statements for a one-to-one match discussed above:
   DATA new-dataset
     MERGE dataset-1 dataset-2
     BY common-variable-list
 The order of the datasets in the MERGE statement does not matter to SAS. Note also that before you
 merge two datasets, make sure to sort them by one or more common variables. You cannot do a 
 one-to-many merge withtout a BY statement. And if you merge, remember that all datasets must be 
 pre-sorted! Lastly, if you merge two datasets, and moreover, they have variables with the same 
 names besides the BY variables, then variables from the second dataset will overwrite any 
 variables having the same name in the first dataset. For example, if you merge two datasets both 
 containing a variable named Score, then the final dataset will contain only one variable named 
 Score. The values for Score will come from the second dataset. You can fix this by renaming the 
 variables so that they will not overwrite each other. This is very important! Remember: rename the
 variables if you can!;
 
DATA regular;
  INFILE 'c:\Users\tgao4\Desktop\shoe.dat';
  INPUT Style $ 1-15 ExerciseType $ RegularPrice;
PROC SORT DATA = regular;
  BY ExerciseType;
DATA discount;
  INFILE 'c:\Users\tgao4\Desktop\disc.dat';
  INPUT ExerciseType $ Adjustment;
PROC SORT DATA = discount;
  BY ExerciseType;
DATA prices;
  MERGE regular discount;
  BY ExerciseType;
  NewPrice = ROUND(RegularPrice - (RegularPrice*Adjustment), .01);
PROC PRINT DATA = prices;
RUN;

*We now learn how to merge summary statistics with original data. To do this, first, summarize your
 data using PROC MEANS and then put the results in a new dataset, such as using the most common
 OUTPUT OUT command. Lastly, merge the summarized data back with the orginal data using a 
 one-to-many match merge;

DATA shoes; *This program says the following: it starts by reading the raw data and sort them. Then
             it summarizes the data. The OUTPUT OUT statement tells SAS to create a new dataset 
             named summarydata containing a variable named Total, which equals the sum of the
             variable Sales. The NOPRINT option tells SAS to hold printing for PROC MEANS report. 
             Instead, the summary dataset is printed by PROC PRINT;
  INFILE 'c:\Users\tgao4\Desktop\shoesales.dat';
  INPUT Style $ 1-15 ExerciseType $ Sales;
PROC SORT DATA = shoes;
  BY ExerciseType;
PROC MEANS NOPRINT DATA = shoes;
  VAR Sales;
  BY ExerciseType;
  OUTPUT OUT = summarydata SUM(Sales) = Total;
PROC PRINT DATA = summarydata;
  TITLE 'Summary Dataset';
DATA shoesummary;
  MERGE shoes summarydata;
  BY ExerciseType;
  Percent = Sales/Total*100;
PROC PRINT DATA = shoesummary;
  BY ExerciseType;
  ID ExerciseType;
  VAR Style Sales Total Percent;
  TITLE 'Final Result';
RUN;

*---------------------------------;

*Reference: Little SAS Chapter 6.4-6.6;
