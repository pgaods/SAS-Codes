
/*
Author: PGao 20170110

This program is designed to give analysts an idea about what perm datasets they have touched in their session.
To use this program, simply put it in your %include statement at the end of your job session.
In your job, you must have the following statement for time processing macros:

  %let timestart=%sysfunc(datetime());

Also, make sure you do NOT clear your libname statement before you want to run this program.
*/

/*%let timestart=%sysfunc(datetime());*/

proc sql;
create table V1 (rename=(lname=libname)) as
select distinct(libname) as lname, path, sysvalue
from sashelp.vlibnam
where /*sysname='Owner Name' and temp = 'no' and*/ calculated lname not in ('ANALYTIC' 'RT' 'GRIDWORK' 'MAPS' 'MAPSGFK' 'MAPSSAS' 'RMTSASHP' 'SASADMIN' 'SASCATCA' 'SASHELP' 'SASUSER' 'RMTWORK' 'WORK')
;
quit;
proc sql;
create table V2 as
select libname, memname, crdate, modate
from sashelp.vtable
where modate>=&timestart. and  libname in (
    select libname
    from sashelp.vlibnam
    where memtype='DATA' and temp = 'no' and libname not in ('ANALYTIC' 'GRIDWORK' 'MAPS' 'MAPSGFK' 'MAPSSAS' 'RMTSASHP' 'SASADMIN' 'SASCATCA' 'SASHELP' 'SASUSER' 'RMTWORK' 'WORK')
    );
quit; 
proc sql;
create table V3 as 
select lowcase(compress(a.libname)) as libname length=200, lowcase(compress(a.memname)) as dsname length=32, a.modate as last_modified, b.path as libname_path
from V2 as a inner join V1 as b
on a.libname=b.libname
order by libname_path, dsname, last_modified;
quit;

%macro Push;
%let permt= %sysfunc(putn(&timestart., datetime.));
data V5 (rename=(user_id=last_modified_by last_modified=last_modified_time) drop=dsname libname);
  length libname_path $200. dsname $32.;
  merge V3 (in=a) V4 (in=b);
  by libname_path dsname;
  if a;
  dataset=compress(libname||"."||dsname);
run;
proc sort data=V5 nodupkey;
by _all_;
run;
proc sort data=V5;
by last_modified_time;
run;
proc print data=V5;
title "Data Analysts: these are the perm datasets since the start of the job session at &permt. that are modified either by yourself or someone else";
var libname_path dataset /*last_modified_by*/ last_modified_time ;
footnote "Session start time: &permt.";
run;
%mend;

%macro Authorship;
proc sql noprint;
select count(distinct(compress(libname_path))) into :r
separated by ''
from V3;
quit;
proc sql noprint;
select distinct(compress(libname_path)) into :vec1-:vec&r.
from V3;
quit;

%if &r. ne 0 %then %do;
%do i=1 %to &r.;
/*getting the author who modified the file */
  %macro file_info(root=/);
    filename inf pipe "ls -l &root." Lrecl=200;

    data file_info&i. (drop=txt);
      infile inf lrecl=200 truncover  ;
      input txt $char200. ;
      if index(txt,'>') >=1 or index(txt,'<') >=1  then delete ;
      user_id=scan(txt,3,' ') ;
	  dsname=compress(upcase(scan(scan(txt,9, ''), 1, ".")));
	  if user_id = '' then delete;
	  libname_path="&&vec&i.";
    run;
    proc sort data=&syslast. nodupkey;
      by user_id dsname;
    run;
  %mend file_info;
  %file_info(root=&&vec&i.)
%end;
data V4;
  length libname_path $200. dsname $32.;
  set file_info1 - file_info&r.;
  dsname=lowcase(compress(dsname));
run;
proc sort data=&syslast.;
by libname_path dsname;
run;
%push;
%end;

%else %do;
data V0;
  line= "No permanent datasets were altered during your current running session";
run;
proc print data=V0 noobs;
title "No permanent datasets were altered during your current running session";
run;
%end;
%mend;
%Authorship 

title;
footnote;



