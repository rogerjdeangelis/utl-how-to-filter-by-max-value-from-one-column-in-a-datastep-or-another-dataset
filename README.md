# utl-how-to-filter-by-max-value-from-one-column-in-a-datastep-or-another-dataset
How to filter by max value from one column in a datastep or another dataset.
    How to filter by max value from one column in a datastep or another dataset

    Select * from have where surveyYear < max(surveyYear) using only a datastep

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

    data want;
      set have (where=(
           0=%sysfunc(dosubl('
          data _null_;
             retain maxYer 0;
             set have end=dne;
             if surveyYear > maxYer then maxYer=surveyYear;
             if dne then call symputx("maxYer",maxYer);
          run;quit;
          '))  and
          surveyYear = &maxYer
        ));
    run;quit;


    OUTPUT (see above)
    ==================


    MAKE DATA
    =========

    data internal sashelp.have



