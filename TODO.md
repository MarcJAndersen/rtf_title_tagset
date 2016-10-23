This file lists the know issues with rtf_title tagset.

The TOC entries are not shown in the navigation window in Word 2013.

The total number of pages is wrong when there is a table of contents.
Workaround: remove the first section break after the TOC.

The pages may overflow.
Workaround: a) change the SAS code to force pagebreaks, b) in Word increase margins, and following that delete empty pages occuring due to the resize of margins.

In some cases the width of table row is 0 and the text does not show.
Workaround: a) ensure ODS NOPROCTITLE is used, b) change the SAS program, c) in Word resize width

