/*------------------------------------------------------------------------*\
** Program : define_tagset_rtf_title_v94.sas
** Purpose : Define ODS templates
** Notes   : The style is defined so that it gives the desired result with
             SAS 9.4.
** Author  : Marc Andersen, mja@statgroup.dk
** Date    : 2016-10-23 (last change)
** Notes   : This software comes with NO WARRANTY - use at your own risk    
\*------------------------------------------------------------------------*/


proc template;

measured;
        
    define tagset Tagsets.RTF_title / store=sassetup.tmpl;
      notes "This is the RTF_title tagset inheriting from tagsets.rtf";          

   define event changes;
      start:
         set $log_note "NOTE: This is the RTF_title tagset based on the code for tagsets.rtf.";
         set $changelog[] "-";

      finish:
         unset $log_note;
         unset $changelog;
   end;

   define event changelog;

      trigger changes start;
      putlog "============================================================================================";
      putlog "History of changes for this tagset";
      putlog $log_note;
      putlog "============================================================================================";
      iterate $changelog;

      do /while _value_;
         set $ctrl substr(_value_,1,1);

         do /if cmp( _value_, "-");
            putlog "--------------------------------------------------------------------------------------------";

         else /if cmp( $ctrl, ".");
            putlog substr(_value_,2);

         else /if cmp( $ctrl, " ");
            putlog "       " strip(_value_);

         else;
            putlog " * " _value_;
         done;

         next $changelog;
         unset $ctrl;
      done;

      putlog "============================================================================================";

      trigger changes finish;
   end;

   define event initialize;

      trigger grand_init;
      set $bestfam["WUGFTMRM" ] "\froman\fprq2";
      set $bestfam["WUGFBOKI" ] "\froman\fprq2";
      set $bestfam["WUGFCNTS" ] "\froman\fprq2";
      set $bestfam["WUGFPALA" ] "\froman\fprq2";
      set $bestfam["WUGFHELV" ] "\fswiss\fprq2";
      set $bestfam["WUGFAVGG" ] "\fswiss\fprq2";
      set $bestfam["WUGFCOUR" ] "\fmodern\fprq1";
      set $bestfam["WUGFSYMB" ] "\ftech\fprq2";
      set $bestfam["WUGFZAPD" ] "\ftech\fprq2";
      set $bestfam["WUGFZAPC" ] "\fdecor\fprq2";
      set $bestfam["FNILFONT" ] "\fnil\fprq0";
      set $borderstyle["DOTTED" ] "\brdrdot";
      set $borderstyle["DASHED" ] "\brdrdash";
      set $borderstyle["SOLID" ] "\brdrs";
      set $borderstyle["DOUBLE" ] "\brdrdb";
      set $borderstyle["GROOVE" ] "\brdrtnthsg";
      set $borderstyle["RIDGE" ] "\brdrthtnsg";
      set $borderstyle["INSET" ] "\brdrinset";
      set $borderstyle["OUTSET" ] "\brdroutset";
      set $borderstyle["HIDDEN" ] "\brdrnone";
      set $spec["line_through" ] "\strike";
      set $spec["underline" ] "\ul";
      set $spec["blink" ] "\animtext2";
      set $spec["overline" ] "\overline";
      set $spec["nounderline" ] "\ul0";
      set $spec["none" ] "\strike0\ul0\animtext0";
      set $fontweight[] "\b0 ";
      set $fontweight[] "\b0 ";
      set $fontweight[] "\b0 ";
      set $fontweight[] "\b";
      set $fontweight[] "\b";
      set $fontweight[] "\b";
      set $fontweight[] "\b";
      set $fontweight[] "\b0";
      set $fontstyle[] "\i";
      set $fontstyle[] "\i";
      set $fontstyle[] "\i0";
      set $continue_tag "on";

      trigger options_set /if $options;
   end;

   define event options_set;
      set $temp lowcase($options["CONTENTS"]);

      do /if cmp( "yes", $temp) or cmp ( "on", $temp );
         set $contents_page "yes";
         unset $options["CONTENTS" ];
      done;

      unset $temp;
      set $temp lowcase($options["CONTINUE_TAG"]);

      do /if cmp( "on", $temp) or cmp ( "yes", $temp );
         set $continue_tag "on";

      else;
         unset $continue_tag /if cmp( "off", $temp) or cmp ( "no", $temp );
      done;

      unset $temp;
      set $temp lowcase($options["ORDER_REPEAT"]);

      do /if cmp( "on", $temp) or cmp ( "yes", $temp );
         set $order_repeat "on";

      else;
         unset $order_repeat /if cmp( "off", $temp) or cmp ( "no", $temp );
      done;

      unset $temp;
      set $temp lowcase($options["RESTRICT_HEIGHT"]);

      do /if cmp( "on", $temp) or cmp ( "yes", $temp );
         set $constrain_height "TRUE";

      else;
         unset $constrain_height /if cmp( "off", $temp) or cmp ( "no", $temp );
      done;

      unset $temp;
      set $temp lowcase($options["TOC_DATA"]);

      do /if cmp( "on", $temp) or cmp ( "yes", $temp );
         set $toc_data "on";

      else;
         unset $toc_data /if cmp( "off", $temp) or cmp ( "no", $temp );
      done;

      unset $temp;
      set $temp lowcase($options["TOC_LEVEL"]);

      do /if $options["TOC_LEVEL"];

         do /if cmp( "off", $temp) or cmp ( "no", $temp );
            unset $toc_level;

         else;
            eval $toc_level inputn($temp,"BEST");
         done;

      done;

      unset $temp;
      set $trowd lowcase($options["TROWD"]);
      unset $trowd /if cmp( "off", $trowd) or cmp ( "no", $trowd );
      set $trhdr lowcase($options["TRHDR"]);
      unset $trhdr /if cmp( "off", $trhdr) or cmp ( "no", $trhdr );
      set $trowhdrcell lowcase($options["TROWHDRCELL"]);
      unset $trowhdrcell /if cmp( "off", $trowhdrcell) or cmp ( "no", $trowhdrcell );
      set $sect_data lowcase($options["SECT"]);
      unset $sect_data /if cmp( "off", $sect_data) or cmp ( "no", $sect_data );

      do /if cmp( "none", $sect_data);
         set $no_section_data $sect_data;

      else;
         unset $no_section_data;
      done;

      set $no_tables upcase($options["TABLES_OFF"]);
      unset $no_tables /if cmp( "off", $no_tables) or cmp ( "no", $no_tables );

      do /if $options["WATERMARK"]);
         set $watertext $options["WATERMARK" ];

         trigger make_watertext;
      done;


      do /if $options["DEBUG_LEVEL"];
         set $debug_level $options["DEBUG_LEVEL" ];
         eval $debug_level inputn($debug_level,"BEST");
         putlog "DEBUG" ": " $debug_level;

      else;
         eval $debug_level 0;
      done;

     set $toc_tbl_entry "0"; /* xx */

     trigger rtf_title_options;

      trigger documentation;
   end;

define event rtf_title_options;
/* Handling of TOPHEADER */
      do /if $options["TOPHEADER"];
         set $topheader $options["TOPHEADER" ];
         eval $topheader inputn($topheader,"BEST");
      else;
         unset  $topheader;
      done;

/* Handling of BOTTOMHEADER */
      do /if $options["BOTTOMHEADER"];
         set $bottomheader $options["BOTTOMHEADER" ];
         eval $bottomheader inputn($bottomheader,"BEST");
      else;
         unset $bottomheader;
      done;


      do /if $options["TOPHEADER_TEXT"];
         do /if $options["TOPHEADER_RTFTEXT"];
             putlog "Both TOPHEADER_RTF and TOPHEADER_RTFTEXT is defined. Using TOPHEADER_RTFTEXT";
             set $topheader_rtftext "{";
             set $topheader_rtftext  $topheader_rtftext $options["TOPHEADER_RTFTEXT"];
             set $topheader_rtftext $topheader_rtftext  "}";
         else;
             set $topheader_rtftext "{\pard ";
             set $topheader_rtftext $topheader_rtftext RTFENCODE($options["TOPHEADER_TEXT"]);
             set $topheader_rtftext $topheader_rtftext  " \par}";
         done;
      else;
         do /if $options["TOPHEADER_RTFTEXT"];
             set $topheader_rtftext "{";
             set $topheader_rtftext  $topheader_rtftext $options["TOPHEADER_RTFTEXT"];
             set $topheader_rtftext $topheader_rtftext  "}";
         done;      
      done;

      do /if $options["BOTTOMHEADER_TEXT"];
         do /if $options["BOTTOMHEADER_RTFTEXT"];
             putlog "Both BOTTOMHEADER_RTF and BOTTOMHEADER_RTFTEXT is defined. Using BOTTOMHEADER_RTFTEXT";
             set $bottomheader_rtftext "{";
             set $bottomheader_rtftext $bottomheader_rtftext $options["BOTTOMHEADER_RTFTEXT"];
             set $bottomheader_rtftext $bottomheader_rtftext "}";
         else;
             set $bottomheader_rtftext "{\pard ";
             set $bottomheader_rtftext $bottomheader_rtftext RTFENCODE($options["BOTTOMHEADER_TEXT"]);         
             set $bottomheader_rtftext $bottomheader_rtftext" \par}";         
         done;
      else;
         do /if $options["BOTTOMHEADER_RTFTEXT"];
             set $bottomheader_rtftext "{";
             set $bottomheader_rtftext $bottomheader_rtftext $options["BOTTOMHEADER_RTFTEXT"];
             set $bottomheader_rtftext $bottomheader_rtftext "}";
         done;
      done;

          
      do /if $options["TOC_DESCRIPTION_TEXT"];
          do /if $options["TOC_DESCRIPTION_RTFTEXT"];
             putlog "Both TOC_DESCRIPTION_RTF and TOC_DESCRIPTION_RTFTEXT is defined. Using TOC_DESCRIPTION_RTFTEXT";
             set $raw_rtf $options["TOC_DESCRIPTION_RTFTEXT"];
          else;
             set $txt_rtf RTFENCODE($options["TOC_DESCRIPTION_TEXT"]);
          done;
      else;
          do /if $options["TOC_DESCRIPTION_RTFTEXT"];
             set $raw_rtf $options["TOC_DESCRIPTION_RTFTEXT"];
          else;
             set $txt_rtf "Table of contents"; 
          done;
      done;
      
      do /if $raw_rtf;
          set $toc_description_rtftext "{";
          set $toc_description_rtftext $toc_description_rtftext $options["TOC_DESCRIPTION_RTFTEXT"];
          set $toc_description_rtftext $toc_description_rtftext "}";
      else;
          set $toc_description_rtftext "\trowd\trkeep\trql\trgaph0";
          set $toc_description_rtftext $toc_description_rtftext "\pard\plain\intbl\sb402\sa536\sl-181\fs16\cf1\qc\f1\b{";
          set $toc_description_rtftext $toc_description_rtftext $txt_rtf;
          set $toc_description_rtftext $toc_description_rtftext "\cell}";
          set $toc_description_rtftext $toc_description_rtftext "\cltxlrtb\clvertalt\clpadt96\clpadft3\clpadr96\clpadfr3\cellx13455";
          set $toc_description_rtftext $toc_description_rtftext "{\row}";
          
      done;

      unset $raw_rtf;
      unset $txt_rtf;
          
      /* Define user properties  */
      iterate $options;
      set $before_userprop "Y";
      open userprops;
      do /while _value_;
         set $ctrl substr(_value_,1,1);

         do /if $before_userprop;
             do /if cmp(upcase(_name_),"USERPROPERTIES");
                 unset $before_userprop;
             done;
             else;
             put "{\propname " _name_ "}";
             put "\proptype30";
             put "{\staticval " _value_ "}";
             done;
             
         next $options;
      done;
      close;
      unset $before_userprop;
      /* End Define user properties */

end;
   define event open;
      start:
         set $cpid VALUE;
      set $lcid TEXT;
      set $constrain_height "true";
      set $temp lowcase($options["RESTRICT_HEIGHT"]);

      do /if cmp( "on", $temp) or cmp ( "yes", $temp );
         set $constrain_height "TRUE";

      else;
         unset $constrain_height /if cmp( "off", $temp) or cmp ( "no", $temp );
      done;

      unset $temp;
   end;

   define event doc;
      start:
         set $first_page "1";
         put "{\rtf1\ansi\ansicpg" $cpid;
         put "\uc1\deff0\deflang" $lcid "\deflangfe" $lcid;
         put NL;

      finish:
         put $$doc_tbl;
         put "{\fonttbl" NL $$font_tbl "}" NL;
         put "{\colortbl;" NL $$color_tbl "}" NL;
         put $$body_tbl;
         put "}" NL;
         flush;
         unset $$doc_tbl;
         unset $$body_tbl;
         unset $$font_tbl;
         unset $$color_tbl;
         unset $$row_tbl;
         unset $$titles_tbl;
         /* begin: added */
         unset $$titles_tbl_part1;
         /* end: added */
         unset $$footnotes_tbl;
         unset $$contents_title_tbl;
         unset $$table_head;
         unset $$table_body;
         unset $$table_foot;
         unset $$byline_tbl;
   end;

   define event doc_start;
      start:

         open body_tbl;
      put "{\stylesheet{\widctlpar\adjustright\fs20\cgrid\snext0 Normal;}" NL;
     put "{\s1 Heading 1}"; /* added to mark \s1 as formatted with Heading 1 style */
      put "{\*\cs10\additive Default Paragraph Font;}}" NL;
      set $generic getoption("generic");

      do /if cmp( $generic, "NOGENERIC");
         put "{\info";

         do /if ^cmp( $lcid, "1033");

            do /if TITLE;
               put "{\title " RTFENCODE(TITLE) "}";

            else;
               put "{\title V9.4 SAS System Output}";
            done;


            do /if AUTHOR;
               put "{\author " RTFENCODE(AUTHOR) "}";

            else;
               put "{\author SAS Version 9.4}";
            done;


            do /if OPERATOR;
               put "{\operator " RTFENCODE(OPERATOR) "}";

            else;
               put "{\operator SAS Version 9.4}";
            done;


         else;

            do /if TITLE;
               put "{\title " TITLE "}";

            else;
               put "{\title V9.4 SAS System Output}";
            done;


            do /if AUTHOR;
               put "{\author " AUTHOR "}";

            else;
               put "{\author SAS Version 9.4}";
            done;


            do /if OPERATOR;
               put "{\operator " OPERATOR "}";

            else;
               put "{\operator SAS Version 9.4}";
            done;

         done;

         put "{\version1}}" NL;
      done;

      /* Begin: Add user properties   */
      do /if $$userprops;
             put "{\*\userprops ";
             put $$userprops;
             put "}";
             done;
      /* end: Add user properties   */
    

      put "\widowctrl\ftnbj\aenddoc\formshade\viewkind1\viewscale100\pgbrdrhead\pgbrdrfoot\fet0" NL;
      put "\paperw" OUTPUTWIDTH "\paperh" OUTPUTHEIGHT;
      put "\margl" LEFTMARGIN "\margr" RIGHTMARGIN;
      put "\margt" TOPMARGIN "\margb" BOTTOMMARGIN;
      put "\pgnstart" VALUE;
      put NL;
      close;
   end;

   define event addfont;
      start:

         open font_tbl;

      do /if ^cmp( $lcid, "1033");
         put "{\f" LIST_INDEX RTFENCODE($bestfam[LABEL]) "\fcharset" RTFENCODE(CODE) "\cpg" RTFENCODE(CODEBASE);
         set $encoded RTFENCODE(VALUE);

         do /if TEXT;
            put "{\*\panose " RTFENCODE(TEXT) "}" $encoded ";}" NL;

         else;
            put " " $encoded ";}" NL;
         done;

         unset $encoded;

      else;

         do /if CODEBASE;
            put "{\f" LIST_INDEX $bestfam[LABEL ] "\fcharset" CODE "\cpg" CODEBASE;

         else;
            put "{\f" LIST_INDEX $bestfam[LABEL ] "\fcharset0";
         done;


         do /if TEXT;
            put "{\*\panose " TEXT "}" VALUE ";}" NL;

         else;
            put " " VALUE ";}" NL;
         done;

      done;

      close;
   end;

   define event addcolor;
      start:

         open color_tbl;
      put "\red" RED "\green" GREEN "\blue" BLUE ";" NL;
      close;
   end;

   define event startpage;
      start:

         do /if cmp( "ON", TEXT);

         trigger footnotes;
         unset $startpage;
      done;

      set $startpage "OFF" /if cmp( "OFF", TEXT);

      do /if cmp( "NOW", TEXT);
         set $previous_startpage $startpage;
         set $startpage "NOW";
      done;

   end;

   define event pagebreak;
      start:

         open body_tbl;

         do /if $contents_page and $first_page;
            put "\sectd\linex0\endnhere" NL;
/* removed            put $$contents_title_tbl; */
/* begin: customized header */
put $toc_description_rtftext;  
/* end: customized header  */
/* begin: change */
               put '\pard\par\par\plain{\field\fldedit{\*\fldinst { TOC \o "1-3" }}}' NL;
               /* end: removed \h \z \u - why that work beats me */
/* begin: change */
/*            put "\pard\par\par\plain{\field\fldedit{\*\fldinst { TOC \tcf67 \\h }}}" NL; */
            unset $$contents_title_tbl;
            put "\sect";
            set $sbreak "ON";
         done;


         do /if cmp( "OFF", $startpage) and  ^ $first_page;
            unset $first_page;
            break /if ^$first_page;
         done;


         do /if ^$no_section_data;

            do /if value or exists( $watertext);
               put "{\pard\par}" NL /if ^$first_page and  ^ exists( $watertext);
               put "\sectd\linex0\endnhere" /if $first_page;
               put "\pard\sect\sectd\linex0\endnhere" /if ^$first_page;

               do /if contains( VALUE, "LANDSCAPE");
                  put "\pgwsxn" WIDTH "\pghsxn" HEIGHT "\lndscpsxn";
                  set $orientation "LANDSCAPE" /if $first_page;

               else /if contains( VALUE, "PORTRAIT");
                  put "\pgwsxn" WIDTH "\pghsxn" HEIGHT;
               done;

               put "\pgnrestart\pgnstarts" LIST_INDEX /if contains( VALUE, "PAGENO");
               put "\sbkcol\cols" PAGE_COLUMNS /if exists( PAGE_COLUMNS);

            else;

               do /if ^$first_page;

                  do /if ^exists( $watertext);
                     put "{\pard\page\par}" NL;
                  done;

               done;

               put "\pard\sect" /if ^$first_page;

               do /if $sbreak;
                  put "\sectd\linex0\endnhere";
                  unset $sbreak;

               else;

                  do /if ^exists( $watertext);
                     put "\sectd\linex0\endnhere\sbknone";

                  else;
                     put "\sectd\linex0\endnhere";
                  done;

               done;

               put "\pgwsxn" WIDTH "\pghsxn" HEIGHT /if contains( $orientation, "LANDSCAPE");
            done;


            do /if $contents_page;
               unset $contents_page;
               put "\pgnrestart\pgnstarts1";
            done;

            put $sect_data;
            put NL;
            put "\headery" TOPMARGIN "\footery" BOTTOMMARGIN;
            put "\marglsxn" LEFTMARGIN "\margrsxn" RIGHTMARGIN;
            put "\margtsxn" TOPMARGIN "\margbsxn" BOTTOMMARGIN;
            set $pagecols PAGE_COLUMNS /if exists( PAGE_COLUMNS);
            put NL;

         else;

            do /if ^$first_page;

               do /if exists( PAGE_COLUMNS);
                  put "{\pard\column\par}" NL;

               else;
                  put "{\pard\page\par}" NL /if ^$first_page;
               done;

            done;

         done;


         do /if ^$date_location or  ^ $pageno_location or $topheader_rtftext; /* changed mja */
            put "{\header\pard\plain\qr\pvmrg\phmrg\posxr\posy0{" NL;
            put " " /if exists( PAGE_COLUMNS);
            put $$bodydate_tbl /if ^$date_location;
            put $$pageno_tbl /if ^$pageno_location;
               /* begin: added */
               put $topheader_rtftext /if $topheader_rtftext;
               /* end: added  */

            do /if $watertext;
               put $$watertext_tbl;

            else;
               put $$watermark_tbl;
            done;

            put "}}" NL;
         done;


         do /if $date_location or $pageno_location or $bottomheader_rtftext; /* changed mja */
            put "{\footer\pard\plain\qr\pvmrg\phmrg\posxr\posy0{" NL;
            put $$bodydate_tbl /if $date_location;
            put $$pageno_tbl /if $pageno_location;
               /* begin: added */
               put $bottomheader_rtftext /if $bottomheader_rtftext;
               /* end: added */
                     
            put "}}" NL;
         done;

         close;

      finish:

         do /if ^$pagecols and  ^ exists( $watertext);

            open body_tbl;
            put "{\pard\par}" NL /if $first_page;
            close;
         done;

         unset $first_page;
         set $startpage $previous_startpage /if cmp( "NOW", $startpage);
   end;

   define event implicit_pagebreak;
      start:

         do /if cmp( "table_body", $section_tbl) and  ^ VALUE;

         trigger publish start;

      else /if cmp( "table_head", $section_tbl) and cmp ( "PARTIAL", VALUE);

         trigger publish start;

      else;
         unset $$table_head;
         unset $$table_body;
         unset $$table_foot;
      done;


      open body_tbl;

      do /if $table_rows;

         do /if $last_row_border_tr;
            put $last_row_border_tr NL;
            unset $last_row_border_tr;
         done;


      else;

         do /if $last_row_border;
            put $last_row_border NL;
            unset $last_row_border;
         done;

      done;

      put $$continue_tbl /if ^cmp( "FLUSH", VALUE) and $continue_tag;
      put $$footnotes_tbl;

      do /if $pagecols;
         put "\pard\sect\sbkcol\cols" $pagecols;
         put $sect_data;
         put NL;

      else;
         put "{\pard\page\par}" NL /if ^PAGE_COLUMNS;
      done;

    put $$titles_tbl_part1; /* mja */
      put $$titles_tbl NL;
      close;
      set $just_broke_page "on" /if $order_repeat;
   end;

   define event proc_branch;

      do /if $toc_level;
         eval $temp_toc inputn(TOC_LEVEL,"BEST");
         break /if $toc_level lt $temp_toc;
      done;

      break /if ^$toc_data;

      open toc_tbl;
      put "{\plain\f1\b0\i0\tc\v " LABEL "  \tcf67 \tcl" TOC_LEVEL " }" NL;
      close;
   end;

   define event branch;

      do /if $toc_level;
         eval $temp_toc inputn(TOC_LEVEL,"BEST");
         break /if $toc_level lt $temp_toc;
      done;

      break /if ^$toc_data;

      open toc_tbl;
      put "{\plain\f1\b0\i0\tc\v " VALUE "  \tcf67 \tcl" TOC_LEVEL " }" NL;
      close;
   end;

   define event leaf;

      do /if $toc_level;
         eval $temp_toc inputn(TOC_LEVEL,"BEST");
         break /if $toc_level lt $temp_toc;
      done;

      break /if ^$toc_data;

      open toc_tbl;
      put "{\plain\f1\b0\i0\tc\v " VALUE "  \tcf67 \tcl" TOC_LEVEL " }" NL;
      close;
   end;

   define event populate;
      start:

         do /if $current_tbl;

         open $current_tbl;

      else;

         open $section_tbl;
      done;

      put $$row_tbl;
      put $$data_tbl;
      close;
   end;

   define event redirect;

      open row_tbl;
   end;

   define event make_byline;
      start:
         unset $$byline_tbl;
         set $current_tbl "byline_tbl";

      finish:
         unset $current_tbl;
   end;

   define event make_footnotes;
      start:
         unset $$footnotes_tbl;
         set $current_tbl "footnotes_tbl";
         close;

      finish:
         unset $current_tbl;
   end;

   define event make_contents_title;
      start:
         unset $$make_contents_title_tbl;
         set $current_tbl "contents_title_tbl";

      finish:
         unset $current_tbl;
   end;

   define event make_parskip;
      start:
         unset $$parskip_tbl;
         set $current_tbl "parskip_tbl";

      finish:
         unset $current_tbl;
   end;

   define event continue;
      start:
         unset $$continue_tbl;
         set $current_tbl "continue_tbl";

      finish:
         unset $current_tbl;
   end;

   define event make_pageno;
      start:
         unset $$pageno_tbl;
         set $current_tbl "pageno_tbl";

         do /if cmp( VJUST, "b");
            set $pageno_location VJUST;

         else;
            unset $pageno_location;
         done;


      finish:
         unset $current_tbl;
   end;

   define event make_bodydate;
      start:
         unset $$bodydate_tbl;
         set $current_tbl "bodydate_tbl";

         do /if cmp( VJUST, "b");
            set $date_location VJUST;

         else;
            unset $date_location;
         done;


      finish:
         unset $current_tbl;
   end;

   define event make_titles;
      start:
         unset $$titles_tbl;
         unset $$titles_tbl_part1;
         set $current_tbl "titles_tbl";

      finish:
         unset $current_tbl;
   end;

   define event footnotes;
      start:

         open body_tbl;
      put $$footnotes_tbl;
      close;
   end;

   define event titles;
      start:

         open body_tbl;
      put $$titles_tbl_part1;
      put "\s1";
      put $$titles_tbl;
      close;
   end;

   define event purge_titles_footnotes;
      start:
         unset $$titles_tbl;
      unset $$footnotes_tbl;
   end;

   define event anchor;

      open body_tbl;

      do /if ^cmp( $lcid, "1033");
         set $encoded RTFENCODE(NAME);
         put "{\*\bkmkstart " $encoded "}{\*\bkmkend " $encoded "}" NL;
         unset $encoded;

      else;
         put "{\*\bkmkstart " NAME "}{\*\bkmkend " NAME "}" NL;
      done;

      close;
   end;

   define event table;
      start:

         do /if contains( VALUE, "TABLE_ROWS");
            set $table_rows "TABLE_ROWS";

         else;
            unset $table_rows;
         done;


         open body_tbl;
         put $$toc_tbl;
         close;
         unset $$toc_tbl;
         /* begin added */
         unset $toc_tbl_entry;
         set $toc_tbl_entry "0";
         /* end added */
             
         unset $column_text;
         unset $last_row_border_data;
         unset $last_row_border;

         do /if ^cmp( "ALL", RULES) AND  ^ cmp ( "ROWS", RULES);

            do /if cmp( "BOX", FRAME) OR cmp ( "BELOW", FRAME) OR cmp ( "HSIDES", FRAME);
               set $last_row_border_data $last_row_border_data "\trgaph0\pard\plain\intbl\sl-5{\cell}\clbrdrt";

               do /if BORDERBOTTOMSTYLE;
                  set $last_row_border_data $last_row_border_data $borderstyle[BORDERBOTTOMSTYLE ];

               else /if BORDERSTYLE;
                  set $last_row_border_data $last_row_border_data $borderstyle[BORDERSTYLE ];

               else;
                  set $last_row_border_data $last_row_border_data $borderstyle["SOLID" ];
               done;


               do /if BORDERBOTTOMWIDTH;
                  set $last_row_border_data $last_row_border_data "\brdrw" BORDERBOTTOMWIDTH;

               else /if BORDERWIDTH;
                  set $last_row_border_data $last_row_border_data "\brdrw" BORDERWIDTH;

               else;
                  set $last_row_border_data $last_row_border_data "\brdrw0";
               done;


               do /if BORDERBOTTOMCOLOR;
                  set $last_row_border_data $last_row_border_data "\brdrcf" BORDERBOTTOMCOLOR;

               else /if BORDERCOLOR;
                  set $last_row_border_data $last_row_border_data "\brdrcf" BORDERCOLOR;

               else;
                  set $last_row_border_data $last_row_border_data "\brdrcf0";
               done;

               set $last_row_border_data $last_row_border_data "\cellx";
            done;

         done;


      finish:
         unset $last_row_border_data;
         unset $last_row_border;
         unset $table_rows;

         trigger publish start;
   end;

   define event publish;
      start:
         break /if cmp( $current_tbl, "byline_tbl");

      open body_tbl;
      put $$byline_tbl /if ^$current_tbl;
      put $$table_head;
      put $$table_body;
      put $$table_foot;
      unset $$byline_tbl;
      unset $$table_head;
      unset $$table_body;
      unset $$table_foot;
      close;
   end;

   define event panel_end;
      start:
         unset $last_row_border;
      unset $last_row_border_data;

      trigger publish start;
   end;

   define event row;
      start:
         set $section_tbl "table_head" /if cmp( "head", SECTION);
         set $section_tbl "table_body" /if cmp( "body", SECTION);
         set $section_tbl "table_foot" /if cmp( "foot", SECTION);

         do /if $no_tables or $tables_off;
            set $temp upcase(style_element);
            putlog "Style_element: " $temp /if contains( $no_tables, "STYLE_ELEMENTS");

            do /if contains( $no_tables, $temp);
               set $tables_off $temp;
               break;

            else;
               unset $tables_off;
            done;

            unset $temp;
         done;


         do /if cmp( "fake", SECTION);
            set $section_tbl "table_head";

            open row_tbl;
            put "\trowd\trkeep\trhdr";

            trigger trow_just;
            put "\trrh-1";
            put NL;
            close;

         else;

            open row_tbl;
            put "\trowd\trkeep";

            do /if cmp( "head", SECTION);
               put "\trhdr";
               put $trhdr;
               set $trowcell "1";
               set $first_row_after_break "on" /if $order_repeat;

            else;
               unset $trowcell;
            done;


            do /if $regwidth and  ^ $current_tbl;
               put "\tabsnoovrlp\tpvpg\tphpg\tposx" $regx "\tposy" $regy;

            else;

               trigger trow_just;
            done;

            put "\trrh-" OUTPUTHEIGHT /if OUTPUTHEIGHT;
            put "\trgaph0";
            put $trowd /if ^$current_tbl;
            put NL;
            close;

            do /if exists( NOCENTER);
               set $tr_just "\trowd\trkeep\trleft" NOCENTER;

            else;
               set $tr_just "\trowd\trkeep\trq" JUST;
            done;

         done;


      finish:

         do /if $table_rows;

            do /if $last_row_border_data;

               do /if cmp( $section_tbl, "table_body");
                  set $last_row_border_tr $tr_just $last_row_border_data $saved_row_border_width "{\row}";

               else;
                  unset $last_row_border_tr;
               done;

            done;

         done;


         do /if VALUE;

            do /if $last_row_border_data;

               do /if cmp( $section_tbl, "table_body");
                  set $last_row_border $tr_just $last_row_border_data $saved_row_border_width "{\row}";

               else;
                  unset $last_row_border;
               done;

            done;

            unset $$row_tbl;
            unset $$data_tbl;
            break;
         done;


         do /if $tables_off;

            open row_tbl;
            put "{\par}" NL;
            close;

         else;

            trigger redirect;
            put "{\row}" NL;
            close;
         done;


         trigger populate start;
         unset $$row_tbl;
         unset $$data_tbl;

         do /if cmp( "body", SECTION);

            do /if ^$compute_line;
               unset $first_row_after_break;
               unset $just_broke_page;

            else;
               unset $compute_line;
            done;

         done;

   end;

   define event trow_just;
      put "\trleft" NOCENTER /breakif exists( NOCENTER);
      put "\trq" JUST;
   end;

   define event proc;
      start:

         do /if $order_repeat;
            set $proc_name "Report" /if cmp( proc_name, "Report");
         done;


      finish:
         unset $proc_name;
   end;

   define event data;
      start:

         trigger redirect;

             /* change: added  cmp( $current_tbl, "titles_tbl") - so titles_tbl is not put in a table */
             do /if $tables_off or cmp( $current_tbl, "titles_tbl");
                put "\pard\plain";                                                  

                do /if not cmp( $toc_tbl_entry, "1" );
                     close;
                     open titles_tbl_part1;
                     put $$row_tbl;
                     close;
                     set $toc_tbl_entry "1";
                     delstream row_tbl;
                     open row_tbl;
                     done;         

      else;
         put "\pard\plain\intbl";
         put "\keepn" /if KEEPN;
         put "\sb" TOPMARGIN;
         put "\sa" BOTTOMMARGIN;

         do /if $constrain_height and  ^ GRSEG;

            do /if ^$inline_fontsize;

               do /if OUTPUTHEIGHT GT 0;
                  put "\sl-" OUTPUTHEIGHT;

               else;
                  eval $thissize OUTPUTHEIGHT * -1;
                  put "\sl" $thissize;
               done;

            done;

         done;

      done;

      unset $inline_fontsize /if $inline_fontsize;
      put "\fs" FONT_SIZE;
      put "\cf" FOREGROUND;

      do /if cmp( JUST, "j");

         do /if cmp( TEXTJUSTIFY, "inter_character");
            put "\qd";

         else;
            put "\qj";
         done;


      else;
         put "\q" JUST;
      done;


      do /if $just_broke_page;

         do /if ^VALUE and $first_row_after_break and cmp( $section_tbl, "table_body");
            put "\q" $column_just[colstart ] /if $column_just[colstart];
         done;

      done;

      put "\fi" INDENT /if INDENT;
      put $fontstyle[FONT_STYLE ] /if FONT_STYLE;
      put "\f" LIST_INDEX;
      put $fontweight[FONT_WEIGHT ] /if FONT_WEIGHT;
      put "\tqdec\tx" COLWIDTH /if COLWIDTH;
      put $spec[text_decoration ] / exists( text_decoration);
      put "{";

      do /if PREIMAGE;
         set $stream_name PREIMAGE;
         putstream $stream_name;
      done;


      do /if $preimage_name;
         set $stream_name $preimage_name;
         putstream $stream_name;
         unset $preimage_name;
      done;


      do /if URL;
         set $url_flag "1";
         put "{\field{\*\fldinst { HYPERLINK """;

         do /if ^cmp( $lcid, "1033");
            put RTFENCODE(URL);

         else;
            put URL;
         done;

         put """}}{\fldrslt {";
         put "\cf" LINKCOLOR " " /if LINKCOLOR;
      done;


      do /if GRSEG;
         set $stream_name GRSEG;
         putstream $stream_name;
      done;


      do /if ^cmp( $lcid, "1033");
         put RTFENCODE(VALUE);

      else;
         put VALUE;
      done;


      do /if $order_repeat and $proc_name;

         do /if VALUE and cmp( $section_tbl, "table_body");

            do /if ^cmp( ROWSPAN, "1");
               unset $column_text /if cmp( colstart, "1");
               unset $column_just /if cmp( colstart, "1");
               set $column_text[colstart ] VALUE;
               set $column_just[colstart ] JUST;
            done;

         done;


         do /if cmp( $section_tbl, "table_body");

            do /if cmp( ROWSPAN, "1") and cmp ( colstart, "1");
               set $compute_line "on";
            done;

         done;


         do /if $just_broke_page;

            do /if ^VALUE and $first_row_after_break and cmp( $section_tbl, "table_body");

               do /if ^cmp( ROWSPAN, "1");
                  put $column_text[colstart ] /if $column_text[colstart];
               done;

            done;

         done;

      done;


      do /if URL;
         put "}}}";
         unset $url_flag;
      done;


      do /if $postimage_name;
         set $stream_name $postimage_name;
         putstream $stream_name;
         unset $postimage_name;
      done;


      do /if POSTIMAGE;
         set $stream_name POSTIMAGE;
         putstream $stream_name;
      done;


      do /if $tables_off;
         put "}" NL;

      else;
         put "\cell}" NL;
      done;

      close;

      trigger cell_shape start /if ^$tables_off;
      set $saved_row_border_width OUTPUTWIDTH;
   end;

   define event span;
      start:
         put "{";
         put "\fs" FONT_SIZE /if FONT_SIZE;
         set $inline_fontsize "true" /if FONT_SIZE;
         put "\cf" FOREGROUND /if FOREGROUND;
         put "\chcbpat" BACKGROUND /if BACKGROUND;
         put "\fi" INDENT /if INDENT;
         put "\f" FONTINDEX /if FONTINDEX;
         put $fontstyle[FONT_STYLE ] /if FONT_STYLE;
         put $fontweight[FONT_WEIGHT ] /if FONT_WEIGHT;
         put $spec[text_decoration ] /if TEXT_DECORATION;
         put " " /if any( FONT_SIZE, FOREGROUND, BACKGROUND, INDENT, FONTINDEX, FONT_STYLE, FONT_WEIGHT, text_decoration);

         do /if URL and  ^ $url_flag;
            set $inline_url "1";
            put "{\field{\*\fldinst { HYPERLINK """;

            do /if ^cmp( $lcid, "1033");
               put RTFENCODE(URL);

            else;
               put URL;
            done;

            put """}}{\fldrslt {";
            put "\cf" LINKCOLOR " " /if LINKCOLOR;
         done;

         set $preimage_name PREIMAGE /if PREIMAGE;
         put PRETEXT /if PRETEXT;

         do /if ASIS;
            put value;

         else;
            unset $tempval;
            set $tempval strip(value);
            put $tempval;
         done;

         put POSTTEXT /if POSTTEXT;
         set $postimage_name POSTIMAGE /if POSTIMAGE;

         trigger border_overrides start;

      finish:
         put "}}}" /if $inline_url;
         unset $inline_url;
         put "}";
   end;

   define event border_overrides;
      start:

         do /if BORDERTOPWIDTH;
         unset $topborder;

         do /if BORDERTOPSTYLE;
            set $topborder "\clbrdrt" $borderstyle[BORDERTOPSTYLE ] "\brdrw" BORDERTOPWIDTH "\brdrcf" BORDERTOPCOLOR;

         else;
            set $topborder "\clbrdrt" $borderstyle["SOLID" ] "\brdrw" BORDERTOPWIDTH "\brdrcf" BORDERTOPCOLOR;
         done;

      done;


      do /if BORDERBOTTOMWIDTH;
         unset $bottomborder;

         do /if BORDERBOTTOMSTYLE;
            set $bottomborder "\clbrdrb" $borderstyle[BORDERBOTTOMSTYLE ] "\brdrw" BORDERBOTTOMWIDTH "\brdrcf" BORDERBOTTOMCOLOR;

         else;
            set $bottomborder "\clbrdrb" $borderstyle["SOLID" ] "\brdrw" BORDERBOTTOMWIDTH "\brdrcf" BORDERBOTTOMCOLOR;
         done;

      done;


      do /if BORDERRIGHTWIDTH;
         unset $rightborder;

         do /if BORDERRIGHTSTYLE;
            set $rightborder "\clbrdrr" $borderstyle[BORDERRIGHTSTYLE ] "\brdrw" BORDERRIGHTWIDTH "\brdrcf" BORDERRIGHTCOLOR;

         else;
            set $rightborder "\clbrdrr" $borderstyle["SOLID" ] "\brdrw" BORDERRIGHTWIDTH "\brdrcf" BORDERRIGHTCOLOR;
         done;

      done;


      do /if BORDERLEFTWIDTH;
         unset $leftborder;

         do /if BORDERLEFTSTYLE;
            set $leftborder "\clbrdrl" $borderstyle[BORDERLEFTSTYLE ] "\brdrw" BORDERLEFTWIDTH "\brdrcf" BORDERLEFTCOLOR;

         else;
            set $leftborder "\clbrdrl" $borderstyle["SOLID" ] "\brdrw" BORDERLEFTWIDTH "\brdrcf" BORDERLEFTCOLOR;
         done;

      done;

   end;

   define event fake_render;
      start:

         open row_tbl;
      put "\pard\plain\intbl";
      put "\keepn" /if KEEPN;
      put "{\cell}" NL;
      close;

      trigger cell_shape;
   end;

   define event cell_shape;
      start:

         trigger borders;

      open row_tbl;

      do /if cmp( VJUST, "m");
         put "\cltxlrtb\clvertalc";

      else;
         put "\cltxlrtb\clvertal" VJUST;
      done;

      put "\clcbpat" BACKGROUND /if BACKGROUND;

      do /if VMERGE;
         put "\clvmgf" /if cmp( "1", VMERGE);
         put "\clvmrg" /if cmp( "2", VMERGE);
      done;


      do /if leftmargin;
         put "\clpadt" leftmargin "\clpadft3";
      done;


      do /if rightmargin;
         put "\clpadr" rightmargin "\clpadfr3";
      done;

      put $trowhdrcell /if $trowcell;
      put "\cellx" OUTPUTWIDTH NL;
      close;
   end;

   define event borders;
      start:

         open row_tbl;

      do /if $topborder;
         put $topborder;
         unset $topborder;

      else;
         put "\clbrdrt" $borderstyle[BORDERTOPSTYLE ] "\brdrw" BORDERTOPWIDTH "\brdrcf" BORDERTOPCOLOR /if BORDERTOPWIDTH;
      done;


      do /if $bottomborder;
         put $bottomborder;
         unset $bottomborder;

      else;
         put "\clbrdrb" $borderstyle[BORDERBOTTOMSTYLE ] "\brdrw" BORDERBOTTOMWIDTH "\brdrcf" BORDERBOTTOMCOLOR /if BORDERBOTTOMWIDTH;
      done;


      do /if $rightborder;
         put $rightborder;
         unset $rightborder;

      else;
         put "\clbrdrr" $borderstyle[BORDERRIGHTSTYLE ] "\brdrw" BORDERRIGHTWIDTH "\brdrcf" BORDERRIGHTCOLOR /if BORDERRIGHTWIDTH;
      done;


      do /if $leftborder;
         put $leftborder;
         unset $leftborder;

      else;
         put "\clbrdrl" $borderstyle[BORDERLEFTSTYLE ] "\brdrw" BORDERLEFTWIDTH "\brdrcf" BORDERLEFTCOLOR /if BORDERLEFTWIDTH;
      done;

      close;
   end;

   define event new_image_start;
      start:
         set $stream_name VALUE;

         open $stream_name;
         put "{\*\shppict{\pict\pngblip" /when cmp( LABEL, "PNG");
         put "{\*\shppict{\pict\jpegblip" /when cmp( LABEL, "JPEG");
         put "{\*\shppict{\pict\emfblip" /when cmp( LABEL, "EMF");
         put "{\*\shppict{\pict\jpegblip" /when cmp( LABEL, "JFIF");
         put "{\*\shppict{\pict\jpegblip" /when cmp( LABEL, "JPG");
         put "\picwgoal" OUTPUTWIDTH "\pichgoal" OUTPUTHEIGHT " " NL;

      finish:
         put "}} " NL;
         close;
   end;

   define event watermark;
      start:
         unset $$watermark_tbl;

         open watermark_tbl;
         put "{";
         put "{\shp{\*\shpinst\shpleft0\shptop0\shpright" OUTPUTWIDTH "\shpbottom" OUTPUTHEIGHT NL;
         put "\shpfhdr1\shpbxcolumn\shpbxignore\shpwr3\shpwrk0" NL;
         put "{\sp{\sn pib}{\sv " NL;
         put "{\pict";
         put "\pngblip " /when cmp( LABEL, "PNG");
         put "\jpegblip " /when cmp( LABEL, "JPEG");
         put "\emfblip " /when cmp( LABEL, "EMF");
         put "\jpegblip " /when cmp( LABEL, "JFIF");
         put "\jpegblip " /when cmp( LABEL, "JPG");
         put NL;

      finish:
         put "}}}" NL;
         put "{\sp{\sn pibFlags}{\sv 2}}" NL;
         put "{\sp{\sn pictureContrast}{\sv 65536}}" NL;
         put "{\sp{\sn pictureBrightness}{\sv 0}}" NL;
         put "{\sp{\sn fLine}{\sv 0}}" NL;
         put "{\sp{\sn wzName}{\sv WordPictureWatermark1210759796}}" NL;
         put "{\sp{\sn posh}{\sv 2}}" NL;
         put "{\sp{\sn posrelh}{\sv 0}}" NL;
         put "{\sp{\sn posv}{\sv 2}}" NL;
         put "{\sp{\sn posrelv}{\sv 0}}" NL;
         put "{\sp{\sn fBehindDocument}{\sv 1}}" NL;
         put "{\sp{\sn fLayoutInCell}{\sv 0}}" NL;
         put "}}} " NL;
         close;
   end;

   define event make_watertext;
      unset $$watertext_tbl;

      open watertext_tbl;
      put "{{\shp{\*\shpinst\shpleft0\shptop0\shpright13921\shpbottom2320\shpfhdr0\shpbxcolumn\shpbxignore\shpbypara\shpbyignore\shpwr3" NL;
      put "{\sp{\sn shapeType}{\sv 136}}" NL;
      put "{\sp{\sn rotation}{\sv 20643840}}" NL;
      put "{\sp{\sn gtextUNICODE}{\sv ";

      do /if ^cmp( $lcid, "1033");
         put RTFENCODE($watertext) "}}" NL;

      else;
         put $watertext "}}" NL;
      done;

      put "{\sp{\sn fillColor}{\sv 12632256}}" NL;
      put "{\sp{\sn fillOpacity}{\sv 32768}}" NL;
      put "{\sp{\sn gtextFont}{\sv Times New Roman}}" NL;
      put "{\sp{\sn fLine}{\sv 0}}" NL;
      put "{\sp{\sn wzName}{\sv PowerPlusWaterMarkObject344428188}}" NL;
      put "{\sp{\sn posh}{\sv 2}}" NL;
      put "{\sp{\sn posrelh}{\sv 0}}" NL;
      put "{\sp{\sn posv}{\sv 2}}" NL;
      put "{\sp{\sn posrelv}{\sv 0}}" NL;
      put "{\sp{\sn fLayoutInCell}{\sv 0}}" NL;
      put "{\sp{\sn fBehindDocument}{\sv 1}}" NL;
      put "}}}" NL;
   end;

   define event image_write;
      start:
         put LABEL NL;
   end;

   define event graph;
      start:

         open body_tbl;

      do /if contains( VALUE, "PAGEBREAK");
         put $$footnotes_tbl;

         do /if ^contains( VALUE, "NOGFOOT");
            unset $$footnotes_tbl;
         done;


         do /if $pagecols;
            put "\pard\sect\sbkcol\cols" $pagecols;
            put $sect_data;
            put NL;

         else;
            put "{\pard\page\par}" NL;
         done;

         put $$titles_tbl NL;
      done;

   done;


   do /if contains( VALUE, "NOGTITLE");
      put $$byline_tbl;
      unset $$byline_tbl;
   done;


   do /if $regwidth;
      put "\pard\plain\phpg\pvpg\posx" $regx "\posy" $regy;
      put "\absw" $regwidth "\absh-" $regheight;

   else;
      put "\pard\plain\q" JUST;
   done;


   do /if GRSEG;
      set $stream_name GRSEG;
      putstream $stream_name;
      delstream $stream_name;

      open body_tbl;
      put $$toc_tbl;
      unset $$toc_tbl;
   done;

   put "{\par}" NL;
   close;
end;

define event parskip;
   start:

      do /if $current_tbl;

      open $current_tbl;

   else;

      open body_tbl;
   done;

   unset $last_row_border;
   unset $last_row_border_data;
   put $$parskip_tbl NL;
   close;
end;

define event pargraph;
   start:

      do /if $current_tbl;

      open $current_tbl;

   else;

      open body_tbl;
   done;

   put $$parskip_tbl NL;
   close;
end;

define event page;
   start:

      open body_tbl;
   put "{\pard\page\par}" NL;
   close;
end;

define event bodytbl;
   start:

      open body_tbl;

   do /if ^cmp( $lcid, "1033");
      put RTFENCODE(VALUE);

   else;
      put VALUE;
   done;

   close;
end;

define event dagger;
   start:
      put "{\field{\fldinst SYMBOL 134 \\f ""Courier"" }} ";
end;

define event date;
   start:
      put "\field{\*\fldinst { DATE \\@ ""hh:mm  dddd, MMMM dd, yyyy  ""}}";
end;

define event lastpage;
   start:
      put "{\field{\*\fldinst { NUMPAGES }}}";
end;

define event nbspace;
   start:
      eval $times 0;

   do /if value;
      eval $times inputn(value,"3.0");
      break /if missing($times);
      break /if $times lt 1;

      do /while $times ne 0;
         put "\~";
         eval $times $times -1;
      done;


   else;
      put "\~";
   done;

end;

define event newline;
   start:
      eval $times 0;

   do /if value;
      eval $times inputn(value,"3.0");
      break /if missing($times);
      break /if $times lt 1;

      do /while $times ne 0;
         put "{\line}";
         eval $times $times -1;
      done;


   else;
      put "{\line}";
   done;

end;

define event pageof;
   start:
      put "{\field{\*\fldinst { PAGE }}}{ of }{\field{\*\fldinst { NUMPAGES }}}";
end;

define event raw;
   start:
      put "{" value "}" /if value;
end;

define event dest;
   start:
      set $dests scan(VALUE,1,"]");
   set $argments scan(VALUE,2,"]");
   set $dests lowcase($dests);
   put $argments /if contains( $dests, "rtf");
end;

define event sectionpages;
   start:
      put "{\field{\*\fldinst { SECTIONPAGES }}}";
end;

define event sigma;
   start:
      put "{\field{\fldinst SYMBOL 115 \\f ""Symbol"" }} ";
end;

define event style;
   start:

      trigger span start;

   trigger span finish;
end;

define event sub;
   start:
      put "{\sub ";

   do /if ^cmp( $lcid, "1033");
      put RTFENCODE(value);

   else;
      put value;
   done;

   put "}";
end;

define event super;
   start:
      put "{\super ";

   do /if ^cmp( $lcid, "1033");
      put RTFENCODE(value);

   else;
      put value;
   done;

   put "}";
end;

define event thispage;
   start:
      put "{\field{\*\fldinst { PAGE }}}";
end;

define event unicode;
   start:

      do /if value;
      set $squote "'";
      eval $temp value;
      set $temp strip($temp);
      set $temp upcase($temp);

      do /if $unicodeMap[$temp];
         eval $newvalue $unicodeMap[$temp ];

      else;

         do /if (index($temp, $squote) > 0);
            set $newvalue scan($temp,1,$squote);

         else /if (index($temp, """") > 0);
            set $newvalue scan($temp,1,"""");

         else;
            set $newvalue $temp;
         done;

      done;

      eval $unicode RTFENUNI($newvalue);
      put "{\uc0\u" $unicode " }" /if $unicode;
   done;

end;

define event documentation;
   break /if ^$options;

   do /if cmp( $options["DOC"], "all");

      trigger help;

      trigger changelog;

      trigger reference;

      trigger settings;
   done;


   trigger quick_reference /if cmp( $options["DOC"], "quick");

   trigger help /if cmp( $options["DOC"], "help");

   trigger settings /if cmp( $options["DOC"], "settings");

   trigger changelog /if cmp( $options["DOC"], "changelog");
end;

define event settings;
   putlog "CONTENTS:       " $contents;
   putlog "CONTINUE_TAG:   " $continue_tag;
   putlog "ORDER_REPEAT:   " $oder_repeat;
   putlog "RESTRICT_HEIGHT " $constrain_height;
   putlog "TOC_DATA:       " $options["TOC_DATA" ];
   putlog "TOC_LEVEL:      " $options["TOC_LEVEL" ];
   putlog "TRHDD:          " $trowd;
   putlog "TRHDR:          " $trhdr;
   putlog "TROWHDRCELL:    " $trowhdrcell;
   putlog "SECT:           " $sect_data;
   putlog "TABLES_OFF:     " $no_tables;
   putlog "WATERMARK:      " $watertext;
   putlog "Debug Level:    " $debug_level;
end;

define event help;
   putlog "==============================================================================";
   putlog "The RTF_title Tagset Help Text.";
   putlog " ";
   putlog "Please refer to the RTF tagset.";
   putlog " ";

   trigger quick_reference;
end;

define event quick_reference;
   putlog "==============================================================================";
   putlog " ";
   putlog "==============================================================================";
end;
registered_tm = "\'ae";
trademark = "\'99";
copyright = "\'a9";
split = "{\line}";
nobreakspace = "\~";
mapsub = "/\{/\}/\\/";
map = "{}\";
parent = tagsets.graph_rtf;
image_formats = "emf,png,jpg";
fontpad = 2;
upi = 1440;
output_type = "rtf";
pure_style;
measurement;
no_byte_order_mark;
has_rwi_support = OFF;
end;

run;

