/*------------------------------------------------------------------------*\
** Program : define_styles_listing.sas
** Purpose : Define listing style - close to ascii output
** Author  : Marc Andersen, mja@statgroup.dk
** Date    : 29-may-2012
\*------------------------------------------------------------------------*/
proc template;
   define style Styles.Listings / store=sassetup.tmpl;
   parent = styles.rtf; 

   /* inspired by styles.EGDefault*/
       
         style fonts                                                             
         "Fonts used in the default style" /                                  
         'TitleFont2' = ("<monospace>, Courier, monospace", 8pt, bold)
         'TitleFont' =  ("<monospace>, Courier, monospace", 8pt, bold)
         'StrongFont' = ("<monospace>, Courier, monospace", 8pt,bold)            
         'EmphasisFont' = ("<monospace>, Courier, monospace", 8pt,italic)        
         'FixedEmphasisFont' = ("<monospace>, Courier, monospace", 8pt,italic)   
         'FixedStrongFont' = ("<monospace>, Courier, monospace", 8pt,bold)       
         'FixedHeadingFont' = ("<monospace>, Courier, monospace", 8pt)           
         'BatchFixedFont' = ("<monospace>, SAS Monospace, Courier, monospace", 8pt)
         'FixedFont' = ("<monospace>, Courier, monospace", 8pt)                  
         'DataFont' = ("<monospace>, Courier, monospace", 8pt)                   
         'headingEmphasisFont' = ("<monospace>, Courier, monospace", 8pt)                  
         'headingFont' = ("<monospace>, Courier, monospace", 8pt)                  
         'docFont' =("<monospace>, Courier, monospace", 8pt)                  
             ;

   style Table from Output /
       rules = group
       frame= hsides
       cellpadding = 2pt 
       cellspacing = 0.25pt
       borderwidth = 0.75pt
       ;

   style HeadersAndFooters from HeadersAndFooters /
       background = none
       frame=hsides
       rules=group
       ;

   style TableFooterContainer from HeadersAndFooters /
       background = none
       frame=hsides
       rules=group
       ;

    
   style Continued from TitlesAndFooters
      "Controls continued flag" /
       rules = none
       frame=void
       BORDERLEFTSTYLE=hidden
       BORDERRIGHTSTYLE=hidden
       /* Want a line above the continued text - this can most likely be made more clever  */
       BORDERTOPSTYLE=solid
       BORDERBOTTOMSTYLE=hidden
       
      font = fonts('headingFont')
      padding = 0
      borderspacing = 0
      pretext = text('continued')
      textalign = left
      backgroundcolor=white
      width=100%
       ;

   style SystemFooter from TitlesAndFooters
       /
       /* This shown at the bottom of the output area, and contains the footnote */
       rules = all
       frame= box
       cellpadding = 2pt 
       cellspacing = 0.25pt
       borderwidth = 0.75pt 
       bordertopstyle=solid

      ;


style Body from Document                                                
         "Controls the Body file." /                                          
         margintop = 2.84cm                                                   
         marginbottom = 2.29cm  /* trick: use 1.51 to trace it in the .rtf file */
         marginleft = 1.5cm 
         marginright = 1.5cm 
       ;   
 
   style BodyDate from Date /
       font=fonts("strongFont")
       cellpadding = 0
       cellspacing = 0
       pretext = "Created on "
       posttext = " " just=r vjust=b ;
       
       ;
       

   Style PageNo from TitlesAndFooters /
       font = fonts("strongFont")
       cellpadding = 0
       cellspacing = 0
       pretext = "Page "
       posttext = " of (*ESC*){lastpage}" just=l /* r to right justify */ vjust=b ;
       
       ;
  
end;
run;

