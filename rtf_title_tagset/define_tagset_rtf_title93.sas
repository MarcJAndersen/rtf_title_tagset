/*------------------------------------------------------------------------*\
** Program : define_tagset_rtf_title93.sas
** Purpose : Define ODS templates
** Notes   : The style is defined so that it gives the desired result with
             SAS 9.3 TS Level 1M0. The definitions may be made more compact.
** Author  : Marc Andersen, mja@statgroup.dk
** Date    : 2016-10-23 (last update)
\*------------------------------------------------------------------------*/


proc template;

/* SAS 9.3 needs the keyword measured - ref http://support.sas.com/kb/45/138.html */
%sysfunc(ifc(&sysver=9.3,measured;,))  
        
    define tagset Tagsets.Rtf_title / store=sassetup.tmpl;
      notes "This is the RTF_title tagset inheriting from tagsets.rtf";          

   define event rtf_title_options_set;
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

     set $toc_tbl_entry "0";


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
          
/* begin: no action for these events */

block proc_branch; 
block branch;
block leaf;
/* end: no action for these events */  
      
end;

/* Start: copy of event from tagsets.rtf added handling of more options below */
   define event options_set;
      set $temp lowcase($options["CONTENTS"]);

      do /if cmp( "yes", $temp) or cmp ( "on", $temp );
         set $contents_page "yes";
         unset $options["CONTENTS" ];
      done;

      unset $temp;
      set $continue_tag lowcase($options["CONTINUE_TAG"]);
      unset $continue_tag /if cmp( "off", $continue_tag) or cmp ( "no", $continue_tag );
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

      do /if $options["WATERMARK"];
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

      trigger rtf_title_options_set; /* rtf_title added */
      
      trigger documentation;
   end;
/* End: copy */

define event rtf_title_doc_start_body_tbl;
         put "{\s1 Heading 1}"; /* added to mark \s1 as formatted with Heading 1 style */
end;

define event rtf_title_user_properties;
      do /if $$userprops;
             put "{\*\userprops ";
             put $$userprops;
             put "}";
             done;
end;
    

         
/* Start: copy of tagsets.rtf */
   define event doc_start;
      start:

         open body_tbl;
      put "{\stylesheet{\widctlpar\adjustright\fs20\cgrid\snext0 Normal;}" NL;
      trigger rtf_title_doc_start_body_tbl;
      put "{\*\cs10\additive Default Paragraph Font;}}" NL;
      set $generic getoption("generic");

      do /if cmp( $generic, "NOGENERIC");
         put "{\info";

         do /if ^cmp( $lcid, "1033");

            do /if TITLE;
               eval $newvalue RTFENCODE(TITLE);
               put "{\title " $newvalue "}";

            else;
               put "{\title V9.3 SAS System Output}";
            done;


            do /if AUTHOR;
               eval $newvalue RTFENCODE(AUTHOR);
               put "{\author " $newvalue "}";

            else;
               put "{\author SAS Version 9.3}";
            done;


            do /if OPERATOR;
               eval $newvalue RTFENCODE(OPERATOR);
               put "{\operator " $newvalue "}";

            else;
               put "{\operator SAS Version 9.3}";
            done;


         else;

            do /if TITLE;
               put "{\title " TITLE "}";

            else;
               put "{\title V9.3 SAS System Output}";
            done;


            do /if AUTHOR;
               put "{\author " AUTHOR "}";

            else;
               put "{\author SAS Version 9.3}";
            done;


            do /if OPERATOR;
               put "{\operator " OPERATOR "}";

            else;
               put "{\operator SAS Version 9.3}";
            done;

         done;

         put "{\version1}}" NL;

         trigger rtf_title_user_properties; /* rtf title - added */

         done;

      put "\widowctrl\ftnbj\aenddoc\formshade\viewkind1\viewscale100\pgbrdrhead\pgbrdrfoot\fet0" NL;
      put "\paperw" OUTPUTWIDTH "\paperh" OUTPUTHEIGHT;
      put "\margl" LEFTMARGIN "\margr" RIGHTMARGIN;
      put "\margt" TOPMARGIN "\margb" BOTTOMMARGIN;
      put "\pgnstart" VALUE;
      put NL;
      close;
   end;
    

define event rtf_title_table_1;
         /* begin added */
         unset $toc_tbl_entry;
         set $toc_tbl_entry "0";
/* XX
putlog "rtf_title_table_1: " "$toc_tbl_entry=" $toc_tbl_entry;
*/
         /* end added */
end;

   define event table;
      start:

      open body_tbl;
         put $$toc_tbl;
         close;
         unset $$toc_tbl;
         trigger rtf_title_table_1; /* added */           
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

         trigger publish start;

   end;

   define event make_titles;
      start:
         unset $$titles_tbl;
         unset $$titles_tbl_part1;
         set $current_tbl "titles_tbl";
      finish:
         unset $current_tbl;

   end;

/* Start: This is a real change ... */
   define event titles;
      start:
         open body_tbl;
      put $$titles_tbl_part1;
      put "\s1";
      put $$titles_tbl;
      close;
    end;
/* End: This is a real change ... */

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
         unset $$footnotes_tbl;
         unset $$contents_title_tbl;
         unset $$table_head;
         unset $$table_body;
         unset $$table_foot;
         unset $$byline_tbl;

         /* rtf_title begin: added */
         unset $$titles_tbl_part1;
         /* rtf_title end: added */
   end;
    

/* This defines the headers position in twips -  twips: 1440 on one inch */
define event rtf_title_top_bottomheader;
                   do /if $topheader;
        put "\headery" $topheader;
        else;
        put "\headery" TOPMARGIN;
        done;

    do /if $bottomheader;
        put "\footery" $bottomheader;
        else;
        put "\footery" TOPMARGIN;
        done;
end;

/* rtf_title start: copy of tagsets.rtf with some changes */
define event pagebreak;
      start:

         open body_tbl;

         do /if $contents_page and $first_page;
            /* rtf_title begin: customized header */
            put $toc_description_rtftext;  
            /* rtf_tile end: customized header  */
            put "\sectd\linex0\endnhere" NL;
/* rtf_title start: do not use the $$contents_title_tbl as it is defined from toc_Description */
/*                put $$contents_title_tbl; */
/* This may changed later, as it may be more relevant to have the TOC defined the style */
/* rtf_title end */
            /* begin: change */
            put '\pard\par\par\plain{\field\fldedit{\*\fldinst { TOC \o "1-3" }}}' NL;
            /* put "\pard\par\par\plain{\field\fldedit{\*\fldinst { TOC \tcf67 \\h }}}" NL;*/ 
            /* end: removed \h \z \u - why that work beats me */
            unset $$contents_title_tbl;
            put "\sect";
/* Maybe replace with 
               put "{\pard\par\page}" NL; *added a \par - this is to get the heading placed on next page;
 */    

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
            trigger rtf_title_top_bottomheader;
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


         do /if ^$date_location or  ^ $pageno_location;
            put "{\header\pard\plain\qr\pvmrg\phmrg\posxr\posy0{" NL;
            put " " /if exists( PAGE_COLUMNS);
            put $$bodydate_tbl /if ^$date_location;
            put $$pageno_tbl /if ^$pageno_location;
            put $$watertext_tbl;
            put "}}" NL;
         done;


         do /if $date_location or $pageno_location;
            put "{\footer\pard\plain\qr\pvmrg\phmrg\posxr\posy0{" NL;
            put $$bodydate_tbl /if $date_location;
            put $$pageno_tbl /if $pageno_location;
            put "}}" NL;
         done;

         close;

      finish:

         do /if ^$pagecols and  ^ exists( $watertext);

            open body_tbl;
/* rtf_title begin: code disabled - donot want to skip a line */
/*                   put "{\pard\par}" NL /if $first_page;                          */
/* rtf_title end: code disabled */    

            close;
         done;

         unset $first_page;
         set $startpage $previous_startpage /if cmp( "NOW", $startpage);
   end;

/* end rtf_title: copy of tagsets.rtf with some changes */


define event rtf_title_data_1;
                do /if not cmp( $toc_tbl_entry, "1" );
                     close;
/** XX
putlog "rtf_title_data_1: " "value=" value ;      
*/
                     open titles_tbl_part1;
                     put $$row_tbl;
                     close;
                     set $toc_tbl_entry "1";
                     delstream row_tbl;
                     open row_tbl;
                     done;         
end;

/* delete this */
   define event panel_end;
      start:
         unset $last_row_border;
      unset $last_row_border_data;
/* XX
      do /if $tables_off  or cmp( $current_tbl, "titles_tbl");
putlog "value=" value ;      
done;
*/
      trigger publish start;
   end;
/* delete this */

/* rtf_title start: copy of tagsets.rtf with some changes */
   define event data;
      start:

         trigger redirect;

         /* change: added  cmp( $current_tbl, "titles_tbl") - so titles_tbl is not put in a table */

      do /if $tables_off  or cmp( $current_tbl, "titles_tbl");
         put "\pard\plain";
/* XX
putlog "value=" value ;      
*/
         trigger rtf_title_data_1;
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

/* rtf_title begin: replace \fi with \linN	Left indent for left-to-right paragraphs */
/* http://msdn.microsoft.com/en-us/library/aa140283#rtfspec_20
    
\linN	Left indent for left-to-right paragraphs; right indent for right-to-left paragraphs (the default is 0).
        It defines space before the paragraph.

    Rich Text Format (RTF) Specification, version 1.6
    http://msdn.microsoft.com/en-us/library/aa140277%28office.10%29.aspx


*/
             
/*     put "\fi" INDENT /if INDENT;  */
         put "\lin" INDENT /if INDENT; /* left indent for left-to-right paragraphs */
/* rtf_title end */
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
            eval $newurl RTFENCODE(URL);
            put $newurl;

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
         eval $newvalue RTFENCODE(VALUE);
         put $newvalue;

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


/* rtf_title change, added: or (cmp( $current_tbl, "titles_tbl")) */
      do /if $tables_off or (cmp( $current_tbl, "titles_tbl"));
         put "}" NL;

      else;
         put "\cell}" NL;
      done;

      close;

/* rtf_title change, added: or (cmp( $current_tbl, "titles_tbl")) */
      trigger cell_shape start /if not ($tables_off or (cmp( $current_tbl, "titles_tbl")));
      set $saved_row_border_width OUTPUTWIDTH;
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

      do /if $last_row_border;
         put $last_row_border NL;
         unset $last_row_border;
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

      /* rtf_title start: added */
      put $$titles_tbl_part1;
      /* rtf_title end: added */
      put $$titles_tbl NL;
      close;
      set $just_broke_page "on" /if $order_repeat;
   end;
    
/* rtf_title start: copy from tagsets.rtf with changes */
   define event row;
      start:
         set $section_tbl "table_head" /if cmp( "head", SECTION);
         set $section_tbl "table_body" /if cmp( "body", SECTION);
         set $section_tbl "table_foot" /if cmp( "foot", SECTION);

         /* rtf title: added  or cmp( $current_tbl, "titles_tbl") */
         do /if $no_tables or $tables_off or cmp( $current_tbl, "titles_tbl");
            set $temp upcase(style_element);
/*
            putlog "Style_element: " $temp /if contains( $no_tables, "STYLE_ELEMENTS");
*/

         /* rtf title: added  or cmp( $current_tbl, "titles_tbl") */
            do /if contains( $no_tables, $temp) or cmp( $current_tbl, "titles_tbl");
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


         /* rtf title: added  or cmp( $current_tbl, "titles_tbl") */
         do /if $tables_off or cmp( $current_tbl, "titles_tbl");

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
/* rtf_title end: copy from tagsets.rtf with changes */

      

      default_style = "styles.rtf";                                           
      parent = tagsets.rtf;                                                   
/* rtf_title start: options taken from text in tagsets.rtf */
      registered_tm = "\'ae";
trademark = "\'99";
copyright = "\'a9";
split = "{\line}";
nobreakspace = "\~";
mapsub = "/\{/\}/\\/";
map = "{}\";
/* parent = tagsets.graph_rtf; */

image_formats = "png,emf,jpg";
fontpad = 2;
upi = 1440;
output_type = "rtf";
pure_style;
measurement;
no_byte_order_mark;
/* rtf_title end: options taken from text in tagsets.rtf */

      uniform;                                                                
   end;                                                                       


run;

