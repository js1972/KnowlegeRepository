*&---------------------------------------------------------------------*
*& Report ZTABLE_COPY
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZTABLE_COPY.

data: lv_src_name type string value 'CRMC_OBJECT_ASSI',
      lv_target_name TYPE string VALUE 'ZCRMC_OBJECT_ASS',
      lr_source TYPE REF TO data,
      lr_target_line TYPE REF TO data,
      lr_target LIKE lr_source.

FIELD-SYMBOLS: <src_tab> TYPE STANDARD TABLE,
               <target_tab> LIKE <src_tab>,
               <target_line> TYPE any.

CREATE DATA lr_source TYPE TABLE OF (lv_src_name).
ASSIGN lr_source->* TO <src_tab>.

CREATE DATA lr_target TYPE TABLE OF (lv_target_name).
ASSIGN lr_target->* TO <target_tab>.

SELECT * INTO TABLE <src_tab> FROM (lv_src_name).

LOOP AT <src_tab> ASSIGNING FIELD-SYMBOL(<src_line>).
   create data lr_target_line type (lv_target_name).
   ASSIGN lr_target_line->* TO <target_line>.
   MOVE-CORRESPONDING <src_line> TO <target_line>.
   APPEND <target_line> TO <target_tab>.
ENDLOOP.

INSERT (lv_target_name) FROM TABLE <target_tab>.

WRITE: / sy-subrc.