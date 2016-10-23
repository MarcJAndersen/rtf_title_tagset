/*------------------------------------------------------------------------*\
** Program : template_source.sas
** Purpose : Stores source of PROC templates items in a text file
** Author  : Marc Andersen, mja@statgroup.dk
** Date    : 2016-10-23 
** Notes   : This software comes with NO WARRANTY - use at your own risk    
\*------------------------------------------------------------------------*/

ods path (prepend) sassetup.tmpl(update);

%macro sourceone(name);

   source &name /
       file="template_source-%sysfunc(translate(&name.-&sysver.,%str(-),%str(.))).txt"
       nofollow
       ;
%mend;


proc template;
/* == SAS provided styles == */
       %sourceone(  Styles.rtf );
       %sourceone(  Styles.journal );

/* == SAS provided tagsets  == */
       %sourceone( tagsets.graph_rtf );
       %sourceone(  Tagsets.rtf );
       %sourceone(  tagsets.csv );
       %sourceone(  tagsets.simplecsv );
       %sourceone( tagsets.meas_event_map );
       %sourceone( tagsets.event_map );
       %sourceone( tagsets.chtml );

/* == Tagset made  == */
       %sourceone(  tagsets.rtf_title );

/* == Tagset style  == */
       %sourceone(  tagsets.listings );

run;
 
