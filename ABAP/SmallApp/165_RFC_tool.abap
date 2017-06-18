REPORT zrfc.
PARAMETERS: user TYPE sy-uname DEFAULT sy-uname OBLIGATORY.
TYPES: BEGIN OF ty_data,
         rfcdest TYPE rfcdes-rfcdest,
         rfctype TYPE rfcdes-rfctype,
         rfcdoc1 TYPE rfcdoc-rfcdoc1,
       END OF ty_data.
DATA: lt_rfc_attr TYPE STANDARD TABLE OF rfcattrib-rfcdest,
      lt_rfc      TYPE STANDARD TABLE OF ty_data.
START-OF-SELECTION.
  SELECT rfcdest INTO TABLE lt_rfc_attr FROM rfcattrib WHERE cuname = user OR muname = user.
  IF sy-subrc <> 0.
    WRITE: / 'No RFC found for user: ' , user COLOR COL_POSITIVE.
    RETURN.
  ENDIF.
  SELECT * INTO CORRESPONDING FIELDS OF TABLE lt_rfc FROM rfcdes AS a INNER JOIN rfcdoc AS b
    ON a~rfcdest = b~rfcdest FOR ALL ENTRIES IN lt_rfc_attr
     WHERE a~rfcdest = lt_rfc_attr-table_line.
  LOOP AT lt_rfc ASSIGNING FIELD-SYMBOL(<item>).
    WRITE: / <item>-rfcdest COLOR COL_NEGATIVE, 'Type: ', <item>-rfctype COLOR COL_TOTAL,
         <item>-rfcdoc1 COLOR COL_GROUP.
  ENDLOOP.