*SAS Lecture Note 9-Dataset Modification Using SET;

*The SET statement in the DATA step allows you to read a SAS dataset so you can add new variables,
 create a subset, or otherwise modify the dataset. To save processing time, sometimes you might 
 want to create a subset of a SAS dataset when you only want to look at a small portion of a large
 dataset. The SET statement brings a SAS dataset, one observation at a time, into the DATA step 
 for processing. To read a SAS dataset, start with the DATA statement specifying the name of the 
 new dataset. Then follow with the SET statement specifying the name of the old dataset you want 
 to read. If you don't want to create a new dataset, you can specify the same name in the DATA and
 SET statements. Then the results of the DATA step will overwrite the old dataset named in the SET
 statement. The following shows the genreal form of the SET statements:
   DATA new-dataset
     SET old-dataset
 Any assignment, subsetting IF, or other DATA step statements usually follow the SET statement. 
 For example, the following creates a new dataset, called Friday, which is a replica of the 
 old dataset, called Oldsales, except Friday has only the observations for Fridays, and it has an
 additional variable, called Total:
   DATA friday
     SET oldsales
       IF Day = 'F'
       Total = Popcorn + Peanuts
   RUN
 Here is an illustrative example below;

DATA train;
  INFILE 'c:\Users\tgao4\Desktop\train.dat';
  INPUT Time TIME5. Cars People;
RUN;

DATA modifiedtrains;
  SET train;
  PeoplePerCar = People/Cars;
PROC PRINT DATA = modifiedtrains STYLE(DATA) = {BACKGROUND = GREEN};
  TITLE 'Average Number of People per Train Car';
  FORMAT Time TIME5.;
RUN; 

*---------------------------------;

*The SET statement with one SAS dataset allows you to read and modify the data. With two or more 
 datasets, in addition to reading and modifying the data, the SET statement concatenates or stacks 
 the datasets one on top of the other. This is useful when you want to combine datasets with all or 
 most of the same variables but different observations. You might, for example, have data from two 
 different locations or data taken at two separate times, but you need the data combined for final
 analysis. To do so, first specify the name of the new SAS dataset in the DATA statement, then list 
 the names of the old datasets you want to combine in the SET statement:
   DATA new-dataset
     SET dataset-1 dataset-2 dataset-n
 The number of observations in the new dataset will equal the sum of the number of observations in 
 the old datasets. The order of observations is determined by the order of the list of the old 
 datasets. If one of the datasets has a variable not contained in the other datasets, then the 
 observations from the other datasets will have missing values for that particular variable;

DATA southentrance;
  INFILE 'c:\Users\tgao4\Desktop\south.dat';
  INPUT Entrance $ PassNumber PartySize Age;
PROC PRINT DATA = southentrance;
  TITLE 'South Entrance Data';

DATA northentrance;
  INFILE 'c:\Users\tgao4\Desktop\north.dat';
  INPUT Entrance $ PassNumber PartySize Age Lot;
PROC PRINT DATA = northentrance;
  TITLE 'North Entrance Data';

DATA Entrance;
  SET southentrance northentrance;
    IF Age = . THEN AmountPaid = .;
	  ELSE IF Age < 3 THEN AmountPaid = 0;
	  ELSE IF 3 <= Age < 65 THEN AmountPaid = 35;
	  ELSE AmountPaid = 27;
PROC PRINT DATA = Entrance;
  TITLE 'Both Entrances';
RUN;

*---------------------------------;

*If you have a dataset that are already sorted by some important variable, then simply stacking the
 datasets may unsort the dataset. You could for sure stack the two datasets and then re-sort them 
 using PROC SORT, but if you have your datasets already sorted, then it is more efficient to 
 preserve that order than to stack and resort. All you need to do is to use a BY statement with 
 your SET statement. Other than that, everything else is th same. Here is the general form:
   DATA new-dataset
     SET dataset-1 dataset-2 dataset-n
     BY variable-list
 Below is an example;

DATA southentrance;
  INFILE 'c:\Users\tgao4\Desktop\south.dat';
  INPUT Entrance $ PassNumber PartySize Age;
PROC PRINT DATA = southentrance;
  TITLE 'South Entrance Data';

DATA northentrance;
  INFILE 'c:\Users\tgao4\Desktop\north.dat';
  INPUT Entrance $ PassNumber PartySize Age Lot;
PROC SORT DATA = northentrance;
  BY PassNumber;
PROC PRINT DATA = northentrance;
  TITLE 'North Entrance Data';

DATA Interweave;
  SET southentrance northentrance;
  BY PassNumber; *This guarantees that ascending order of the sorted PassNumber is preserved in the
                  new dataset created, called Interweave;
PROC PRINT DATA = Interweave;
  TITLE 'Both Entrances, By PassNumber';
RUN;


*---------------------------------;

*Reference: Little SAS Chapter 6.1-6.3;
