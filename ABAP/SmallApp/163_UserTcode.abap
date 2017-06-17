REPORT zusertcode.
 
 
PARAMETER: month TYPE dats DEFAULT sy-datum OBLIGATORY,
 
           user type usr02-bname OBLIGATORY DEFAULT sy-uname.
 
 
TYPES: BEGIN OF zusertcode,
 
         operation type char30,
 
         type type char10,
 
         count  TYPE swncshcnt,
 
       END OF zusertcode.
 
 
TYPES: tt_zusertcode TYPE STANDARD TABLE OF zusertcode WITH KEY operation type.
 
 
DATA: lt_usertcode  TYPE swnc_t_aggusertcode,
 
      wa_usertcode TYPE swncaggusertcode,
 
      wa           TYPE zusertcode,
 
      t_ut         TYPE tt_zusertcode,
 
      ls_result    TYPE zusertcode,
 
      lt_result     TYPE tt_zusertcode.
 
 
CONSTANTS: cv_tcode TYPE char30 VALUE 'Tcode',
 
           cv_report TYPE char30 VALUE 'Report',
 
           cv_count TYPE char5 value 'Count'.
 
 
START-OF-SELECTION.
 
* Set date to the first day of the month
 
  "month+6(2) = '01'.
 
  CALL FUNCTION 'SWNC_COLLECTOR_GET_AGGREGATES'
 
    EXPORTING
 
      component     = 'TOTAL'
 
      periodtype    = 'M'
 
      periodstrt    = month
 
    TABLES
 
      usertcode     = lt_usertcode
 
    EXCEPTIONS
 
      no_data_found = 1
 
      OTHERS        = 2.
 
 
  DELETE lt_usertcode WHERE tasktype <> '01'.
 
 
  LOOP AT lt_usertcode ASSIGNING FIELD-SYMBOL(<user>) WHERE account = user.
 
     CLEAR: ls_result.
 
     ls_result-operation = <user>-entry_id.
 
     ls_result-type = <user>-entry_id+72.
 
     ls_result-count = <user>-count.
 
     COLLECT ls_result INTO lt_result.
 
  ENDLOOP.
 
 
  SORT lt_result BY count DESCENDING.
 
 
  WRITE:  10 cv_tcode, 20 cv_report, 60 cv_count COLOR COL_NEGATIVE.
 
  LOOP AT lt_result ASSIGNING FIELD-SYMBOL(<result>).
 
      IF <result>-type = 'T'.
 
        WRITE: / <result>-operation COLOR COL_TOTAL UNDER cv_tcode,
 
                 <result>-count COLOR COL_POSITIVE UNDER cv_count.
 
      ELSE.
 
        WRITE: / <result>-operation COLOR COL_GROUP UNDER cv_report,
 
                 <result>-count COLOR COL_POSITIVE UNDER cv_count.
 
      ENDIF.
 
  ENDLOOP.