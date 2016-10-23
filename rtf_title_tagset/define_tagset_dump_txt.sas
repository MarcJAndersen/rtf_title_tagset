/*------------------------------------------------------------------------*\
** Program : define_tagset_dump_txt.sas
** Purpose : Define tagset txt_dump for dumping text contents in a file
** Author  : Marc Andersen, mja@statgroup.dk
** Date    : 29-may-2012
** Notes   : This software comes with NO WARRANTY - use at your own risk    
\*------------------------------------------------------------------------*/

proc template;
    define tagset Tagsets.dump_txt / store=sassetup.tmpl;
    notes "This is the dump_txt tagset which inherits from tagsets.simplecsv";            
define event table;
   start:
       put "Table " NL;
   end;
define event colspecs;
   set $ThisColCount COLCOUNT;
   end;
define event row;
   put strip($ThisColCount) NL;
   end;
define event header;
   start:
      put strip(VALUE) NL;
   end;
define event data;
   start:
      put strip(VALUE) NL;
   end;
   parent = tagsets.simplecsv;                                                   
   end;                                                                       
run;
