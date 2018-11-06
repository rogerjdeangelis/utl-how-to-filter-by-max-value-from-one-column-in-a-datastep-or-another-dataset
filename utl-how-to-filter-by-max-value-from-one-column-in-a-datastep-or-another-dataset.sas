StackOverflow: How to filter by max value from one column in a datastep or another dataset

Select * from have where surveyYear < max(surveyYear) using only a datastep

Two Solutions
   1. DOSUBL
   2. set have(keep=surveyYear) have
      Paul Dorfman <sashole@bellsouth.net>

see comments on end,

github
https://tinyurl.com/y9rft3mz
https://github.com/rogerjdeangelis/utl-how-to-filter-by-max-value-from-one-column-in-a-datastep-or-another-dataset

StackOverflow
https://tinyurl.com/y9nacttb
https://stackoverflow.com/questions/53122442/sas-how-to-filter-by-max-value-from-one-column-in-a-datastep


INPUT
=====

WORK.HAVE total obs=16

 SURVEYYEAR    ID    SCORE    VARCHAR

    2016        1      10      Yes
    2016        2       6      Yes
    2016        3       8      Yes
    2016        4       .      No
    2017        5       6      No
    2017        6       5      No
    2017        7      12      IU
    2017        8       3      IU
    2017        9       2      IU
    2017       10      15      99999
    2018       11       0
    2018       12       .      No
    2018       13      10      Yes
    2018       14       8      No
    2018       15      11      No
    2018       16       3      IU

EXAMPLE OUTPUT ( where surveyYear < max(surveyYear)
====================================================

WORK.WANT total obs=6

  SURVEYYEAR    ID    SCORE    VARCHAR

    2018       11       0
    2018       12       .       No
    2018       13      10       Yes
    2018       14       8       No
    2018       15      11       No
    2018       16       3       IU


PROCESS
=======

1. DOSUBL

   %symdel maxYer / nowarn;
   data want;
     set have (where=(
         0=%sysfunc(dosubl('
         data _null_;
            retain maxYer;
            set have(keep=surveyYear) end=dne;
            maxYer = maxYer max surveyYear;
            if dne then call symputx("maxYer",maxYer);
         run;quit;
         '))  and
         surveyYear = &maxYer
       ));
   run;quit;

2. set have(keep=surveyYear) have

   data want (drop = _:) ;
     set have (in = _1 keep = surveyyear) have ;
     retain _m ;
     if _1 then _m = _m max surveyyear ;
     else if surveyyear => _m then output ;
   run ; quit ;


OUTPUT (see above)
==================


MAKE DATA
=========

data have;
   input surveyYear id score varChar$10. ;
cards4;
2016 1 10 Yes
2016 2 6 Yes
2016 3 8 Yes
2016 4 . No
2018 11 0 .
2018 12 . No
2018 13 10 Yes
2018 14 8 No
2018 15 11 No
2018 16 3 IU
2017 5 6 No
2017 6 5 No
2017 7 12 IU
2017 8 3 IU
2017 9 2 IU
2017 10 15 99999
;;;;
run;quit;


*                                         _
  ___ ___  _ __ ___  _ __ ___   ___ _ __ | |_ ___
 / __/ _ \| '_ ` _ \| '_ ` _ \ / _ \ '_ \| __/ __|
| (_| (_) | | | | | | | | | | |  __/ | | | |_\__ \
 \___\___/|_| |_| |_|_| |_| |_|\___|_| |_|\__|___/

;

Your method like mine will even work when the subsetting table is
a different table.

I do have '>' and since I start with 0 I don't think I need the '='.
I added the 'keep=surveyYear' and 'maxYer = maxYer max surveyYear'  to my dosubl.
Thanks!!

I believe my method will do much less I/O, especially if
the resulting table is small.

Your I/O
NOTE: There were 16 observations read from the data set WORK.HAVE.
NOTE: There were 16 observations read from the data set WORK.HAVE.

My I/O

NOTE: There were 16 observations read from the data set WORK.HAVE.
NOTE: There were 6 observations read from the data set WORK.HAVE.


SOAPBOX ON

Robert Frost said

   Two roads diverged in a wood, and
   I took the one less traveled by,
   And that has made all the difference.

Unless the SAS-L braintrust does not explore
DOSUBL we may never see DOSUBL reash it's
full potential.

StackOverflow and the commercial list will not help.

It makes sense that finding the max should be a
subroutine.

DOSUBL desparately needs robust arguments, common and equivalence
statements.

Sharing parent arrays would also be nice.

SOAPBOX OFF


