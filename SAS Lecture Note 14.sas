*SAS Lecture Note 14-Statistical Procedures For Idiots;

*We will first learn PROC UNIVARIATE and PROC MEANS to summarize data. Certaintly, PROC UNIVARIATE
 produces statistics describing the distribution of a single variable. The basic form is given by:
   PROC UNIVARIATE
     VAR variable-list
 Note that without a VAR statement, SAS will calculate statistics for all numeric variables in the
 dataset. One can also specify other options in the PROC statement, such as PLOT or NORMAL, e.g.:
   PROC UNIVARIATE PLOT NORMAL
 The NORMAL option produces tests of normality while the PLOT option produces three plots of the 
 data (stemm-leaf, blox, and normal probability plot). One can use a BY statement to obtain separate
 analyses for BY groups as long as we use PROC SORT first;

DATA class;
  INFILE '\\sscwin\dfsroot\users\tgao4\Desktop\scores.txt';
  INPUT Score @@;
PROC UNIVARIATE DATA = class PLOT NORMAL;
  VAR Score;
RUN;

*---------------------------------;

*We now learn PROC MEANS. It's very similar to PROC UNIVARIATE which gives you all the important
 summary stats such as mean, variance, skewness, quantiles, extremes, t-tests, standard error etc.
 For PROC MEANS, you can ask for these selectively instead of making them printed out all at once. 
 The basic format for PROC MEANS is PROC MEANS stats-keywards, followed by a semicolon. Here are the 
 key words you can specify for request:
   Keywords               Description
   CLM                    2-sided confidence limits (default is 95%)
   CSS                    corrected sum of squares
   KURTOSIS
   LCLM                   lower confidence limit
   UCLM                   upper confidence limit
   MAX
   MEAN
   MIN
   N                      number of non-missing values
   NMISS                  number of missing values
   Q1                     1st quartile
   P1                     1ST percentile
   P10
   P95
   Range
   SKEWNESS
   STDDEV
   STDERR                 standard error of means
   SUM
   VAR
   Q3
   P90
   P95
  Here are some examples:
     e.g. PROC MEANS ALPHA=0.1 CLM
     e.g. PROC MEANS options      
            VAR variable-list
  ;

DATA book;
  INFILE '\\sscwin\dfsroot\users\tgao4\Desktop\Picbooks.dat'; 
  INPUT NumberOfPages @@;
PROC MEANS DATA = book N MEAN MEDIAN CLM ALPHA=0.1;
RUN;

*---------------------------------;

*PROC FREQ helps us test categorical data. The general format is given by:
   PROC FREQ
     TABLES variable-combinations/ options
 The options are listed below:
   Options             Descriptions
   CHISQ               chi-squared test of homogeneity and measures of association
   CL                  confidence limit for measures of association
   CMH                 Cochran-Mantel-Haenszel statistic
   EXACT               Fisher's exact test for tables larger than 2 by 2
   TREND               Cochrane-Armitage test for trend
   PLCORR              polychoric correlation coefficient
 ;

DATA bus;
  INFILE '\\sscwin\dfsroot\users\tgao4\Desktop\bus.dat'; 
  INPUT BusType $ OnTimeOrLate $ @@;
PROC FREQ DATA = bus;
  TABLES BusType*OnTimeOrLate /CHISQ CMH EXACT;
RUN;

*---------------------------------;

*Now we learn PROC CORR. To use this, people often combine with the main statement with VAR var-list
 followed by WITH variable-list. The variables listed in the VAR statement appear across the top of 
 the table correlations, wihle variables listed in the WITH statement appear down the side of the 
 table. If you use a VAR statement but no WITH statement, then the variables appear both across the 
 top and down the side. For this procedure by default, PROC CORR computes Pearson product-moment 
 correlation coefficients. You can add options to the PROC statement to request some nonparametric 
 correlation coefficients such as SPEARMAN;

DATA class;
  INFILE '\\sscwin\dfsroot\users\tgao4\Desktop\exercise.dat'; 
  INPUT Score TV Exercise @@;
PROC CORR DATA = class;
  VAR TV Exercise;
  WITH Score;
RUN;



*---------------------------------;

*Reference: Little SAS Chapter 8.1-8.9;
