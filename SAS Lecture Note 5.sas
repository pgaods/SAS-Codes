*SAS Lecture Note 5-Data Summary;

*To give descriptive stats about the data, the MEANS procedure is the most useful one. The
 basic command is PROC MEANS options. If you do not specify any options, MEANS will print
 the number of no-missing values, the mean, the standard deviation, the minimum & the 
 maximum of the variables. There are over 30 different statistics you can request with the
 MEANS procedure. The following is a list of some of the simple stats (c.f. Section 8.2): 
 MAX, MIN, MEDIAN, N(number of non-missing values), NMISS(number of missing values), RANGE,
 SUM, STDDEV(standard deviation) etc.;

*If you use the PROC MEANS without other statements, then you will get stats for all 
 observations and all numeric variables in your dataset. Here are some of the optional 
 statements one can use: 1) BY variable_list, 2) CLASS variable_list, 3) VAR variable_list. 
 The BY statement performs separate analyses for each level of the variables in the
 list, but the data must be pre-sorted first in the same order as in the variable_list. 2)
 The CLASS statement is the same as BY except that the data do not need to be sorted first.
 VAR specifies which numeric variables to use in the analysis. If it is absent then SAS 
 uses all numeric variables;

DATA flower_sales;
  INFILE 'c:\Users\tgao4\Desktop\Flowers.dat';
  INPUT CustomerID $ @9 SaleDate MMDDYY10. Petunia SnapDragon Marigold;
  Month = MONTH(SaleDate); *We are creating a new variable by the MONTH() function;
PROC SORT DATA = flower_sales;
  BY Month; *Note that any statement with BY needs pre-sorting!;
PROC MEANS DATA = flower_sales MEAN MIN MAX MODE MEDIAN N NMISS RANGE STDDEV SUM;
  BY Month;
  VAR Petunia SnapDragon Marigold;
  TITLE 'Summary Stats for flower sales';
RUN;

*---------------------------------;

*Sometimes you want to save summary stats to a SAS dataset for further analysis, or to 
 merge with other data. The MEANS procedure can condense the data and save the summary
 stats in a newly-generated dataset. There are two methods in PROC MEANS to save summary 
 stats. You can either use ODS(see Section 5.3) or the following statement:
   OUTPUT OUT = new_data_set output_stats_list
 Here, the new_data_Set is the name of the dataset you want to create which will contain
 the results. The output_stats_list defines which statistics you want and the associated
 variable names. You can have more than one OUTPUT statement and multiple output_stats_list. 
 The following is one of the possible forms of output_stats_list:
   statistic_name(variable_list) = name_list
 Here, statistic_name can be any of the statistics available in PROC MEANS (say SUM, N, 
 MEDIAN) and variable_list denotes which of the variables in the VAR statement you want to 
 output.The name_list defines the new variable names for the statistics, c.f. pp.118-119;

DATA flower_sales;
  INFILE 'c:\Users\tgao4\Desktop\Flowers.dat';
  INPUT CustomerID $ @9 SaleDate MMDDYY10. Petunia SnapDragon Marigold;
  Month = MONTH(SaleDate);
PROC SORT DATA = flower_sales;
  BY Month; 
PROC MEANS DATA = flower_sales;
  BY Month;
  VAR Petunia SnapDragon Marigold;
  OUTPUT OUT = flower_sales_enhanced MEAN(Petunia SnapDragon Marigold) = Pmean Smean Mmean;
  *this command basically says within each month, take the mean of Petunia, and it equals 
   Pmean. Take the mean of SnapDragon, and it equals Smean. Take the mean of Marigold, and 
   it equals Mmean;
RUN;
PROC PRINT DATA = flower_sales_enhanced;
RUN;

*Here is another example;

DATA sales;
  INFILE 'c:\Users\tgao4\Desktop\Flowers.dat';
  INPUT CustomerID $ @9 SaleDate MMDDYY10. Petunia SnapDragon Marigold;
PROC SORT DATA = sales;
  BY CustomerID;
PROC PRINT DATA = sales;
  TITLE 'flower-sales';
PROC MEANS NOPRINT DATA = sales;
  BY CustomerID;
  VAR Petunia SnapDragon Marigold;
  OUTPUT OUT = totals MEAN(Petunia SnapDragon Marigold) = MPet MSnap Mgold
                      SUM(Petunia SnapDragon Marigold) = SP SS SM;
PROC PRINT DATA = totals;
  TITLE 'Sum and Average of Flower Data';
  FORMAT Mpet MSnap Mgold 3.;
RUN;

*Make sure to read the output window! The table is hard to understand! But it's correct!;

*---------------------------------;

*We now learn how to use PROC FREQ to count data. The basic structure of command is given 
 by TABLES variable_combinations followed by PROC FREQ. To produce a one-way frequency
 table, just list the variable name. To produce a cross-tabulation, list the variables 
 separated by an asterisk;

*Options, if any, appear after a slash in the TABLES statement (c.f.Section 8.3), such as 
 LIST(prints cross-tabulations in list format rather than grid), MISSING(includes missing
 values in frequency statistics), NOCOL(surpresses printing of column percentages in 
 cross-tabulations), NOROW(surpresses printing of row percentages in cross-tabulations), 
 OUT = dataset_name(writes a dataset containing frequencies) etc.;

DATA coffeeorders;
  INFILE 'c:\Users\tgao4\Desktop\Coffee.dat';
  INPUT Coffee $ Window $ @@;
PROC FREQ DATA = coffeeorders;
  TABLES Window Window*Coffee;
RUN; 

*If you look at the output window, the missing value is mentioned but not included in the 
 statistics. So one should use the MISSING option if one wants missing values to be included
 in the table. We highly recommend using one-way frequency table which is always easy to
 be interpreted;

*---------------------------------;

*Reference: Little SAS Chapter 4.9-4.11;

