/*------------------------------------------------------------------------*\
** Program : ex1_rtf_title.sas
** Purpose : Show usage of tagset RTF_title with typical SAS code
** Author  : Marc Andersen, mja@statgroup.dk
** Date    : 29-may-2012, update MJA 2016-10-23 
** Notes   : This software comes with NO WARRANTY - use at your own risk    
\*------------------------------------------------------------------------*/

options msglevel=I;
options nocenter;
options formchar= "|----|+|---+=|-/\<>*";
options mprint;
options source source2;
options linesize=200;

/* Begin: The next lines are only for convenience. */



/* Feel free to change the location of this directory */    
libname sassetup "SASsetup"; /* Templates are stored here */
ods path (prepend) sassetup.TMPL(read);
ods path show;
/* End */

/* This defines the rtf_title tagset for SAS 9.4 and the associated listing */
/* The tagset and style is stored in the library SASsetup, so the next two statements */
/* are only nescessary first time for creating the tagset and style in SASsetup. */
%include "rtf_title_tagset/define_styles_listing.sas";
%include "rtf_title_tagset/define_tagset_rtf_title94.sas";

/* === now for the actual program */

title "%scan(%sysfunc(getoption(sysin)),-1,%str(/\)) title";
footnote "%scan(%sysfunc(getoption(sysin)),-1,%str(/\)) footnote";

options  nocenter nodate;

options papersize=a4 orientation=landscape;

ods tagsets.rtf_title
    file="ex1_rtf_title.rtf" 
    style=listings
    nogtitle nogfootnot
    options(CONTENTS= 'YES' TOPHEADER='144' BOTTOMHEADER='1440' TOC="off"
    TOPHEADER_RTFTEXT='\pard{Company {\field{\fldinst{DOCPROPERTY MYCOMPANY \\* MERGEFORMAT}}}, document {\field{\fldinst{DOCPROPERTY MYTITLE \\* MERGEFORMAT}}}} \par'
    BOTTOMHEADER_TEXT='[BOTTOMHEADER]'
    TOC_DESCRIPTION_TEXT='[Enter Table of Contents Header]'
    USERPROPERTIES="start"
    MYCOMPANY="[CompanyName]"
    MYTITLE="[Example]"
    )
    ;

ods noproctitle;

proc report data=sashelp.class nofs headline headskip missing split="¤";
    title "Listing 1: Dataset sashelp.class";
    title2 "This is the title2 - not shown in TOC";
    footnote "Footnote to Listing 1";
    column Name Sex Age Height Weight;
    define Name / display;
    define Sex / display;
    define Age / display;
    define Height / display;
    define Weight / display;
    
    compute after / style={just=left};
    line @1 "Line made by compute after";
    endcomp;
run;
quit;

proc summary data=sashelp.class;
    class sex;
    output out=age_stat n(age)=N median(age)=median min(age)=min max(age)=max;
    output out=weight_stat N(weight)=N mean(weight)=mean std(weight)=std;
    output out=height_stat N(height)=N mean(height)=mean std(height)=std;
run;

data table1_sex;
    set age_stat(in=_age) weight_stat(in=_weight) height_stat(in=_height);
    by sex;
    length RowText $64;
    select;
    when (_age) do; RowText="Age (y)"; RowSeqno=1; end;
    when (_weight) do; RowText="Weight (pounds)"; RowSeqno=2; end;
    when (_height) do; RowText="Height (inches)"; RowSeqno=3; end;
    end;
    array stats(*) N median mean min max std;
    do StatSeqno=1 to dim(stats);
        if not missing(stats(StatSeqno)) then do;
            Stats1_value= stats(StatSeqno);
            Stats1_text= vname(stats(StatSeqno));
            output;
            end;
        end;
    keep sex RowSeqno RowText StatSeqno Stats1_value Stats1_text;
run;

proc sort data=table1_sex;
    by RowSeqno RowText StatSeqno Stats1_text;
run;

data table1;
    merge
        table1_sex(where=(sex_f="F") rename=(sex=sex_f Stats1_value=Stats1_value_f))
        table1_sex(where=(sex_M="M") rename=(sex=sex_M Stats1_value=Stats1_value_M))
        ;
    by RowSeqno RowText StatSeqno Stats1_text;
run;

proc format;
    value $stats_format
        other="Best8."
        "N"="f6.0"
        "median"="f3.0"
        "min"="f3.0"
        "max"="f3.0"
        "mean"="f5.1"
        "std"="f5.1"
;
run;


proc report data=table1 missing nofs headline headskip split="¤";
    title "Table 1: Descriptive statistics. Dataset sashelp.class";
    footnote "Footnote to Table 1";
    column RowSeqno RowText StatSeqno Stats1_text Stats1_value_F Stats1_value_M;
    define RowSeqno / order noprint;
    define RowText / " " order id;
    define StatSeqno / order noprint;
    define Stats1_text / " " order flow width=20;
    define Stats1_value_M / "Males" display;
    compute Stats1_value_M;
    call define(_col_,"format",put(Stats1_text,$stats_format.));
    endcomp;
    define Stats1_value_F / "Females" display;
    compute Stats1_value_F;
    call define(_col_,"format",put(Stats1_text,$stats_format.));
    endcomp;
    compute after / style={just=left};
    line "Endnote goes here";
    endcomp;
run;


proc sgplot data=sashelp.class;
    title "Figure 1: Weight versus Age. Dataset sashelp.class";
    footnote "Footnote to Figure 1";
    scatter x=age y=weight / group=sex;
run;

title "Listing 2: Output from PROC MIXED. Dataset sashelp.class";
proc mixed data=sashelp.class;
    class sex;    
    model weight=age*sex;
run;


proc sort data=sashelp.class out=class;
    by sex;
run;

options nobyline;

proc report data=class nofs headline headskip missing split="¤";
by sex;
title "Listing 3.#byval(SEX): Dataset sashelp.class for #byval(SEX) - with options nobyline";
title2 "This is the title2 - not shown in TOC";
footnote "Footnote to Listing 3";

column Name Sex Age Height Weight;
define Name / display;
define Sex / display;
define Age / display;
define Height / display;
define Weight / display;

compute after / style={just=left};
    line @1 "Line made by compute after";
    endcomp;
run;
quit;

options byline;

ods tagsets.rtf_title close;

