*&---------------------------------------------------------------------*
*& Report ZHELLOWORLD
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zhelloworld.

PARAMETERS: clear TYPE c as CHECKBOX DEFAULT abap_false.

TYPES: tt_table TYPE TABLE OF tadir WITH KEY pgmid object.
DATA: lt_result TYPE TABLE OF tadir,
      lt_total  TYPE TABLE OF tadir,
      lr_result TYPE REF TO tt_table.

DATA: c1 TYPE cursor.

OPEN CURSOR @c1 FOR SELECT * FROM tadir.

DO.
  WRITE: / |Round: { sy-index } | COLOR COL_NEGATIVE.
  CREATE DATA lr_result.
  FETCH NEXT CURSOR @c1 INTO TABLE @lr_result->* PACKAGE SIZE 800000.
  IF sy-subrc <> 0.
    EXIT.
  ENDIF.
  APPEND LINES OF lr_result->* TO lt_total.
  cl_abap_memory_utilities=>get_memory_size_of_object( EXPORTING object = lt_total
      IMPORTING
        bound_size_alloc = DATA(bound_alloc)
        bound_size_used = DATA(bound_used) ).

  WRITE: / 'bound alloc:' , bound_alloc.
  WRITE: / 'bound used:' , bound_used.

  cl_abap_memory_utilities=>get_total_used_size( IMPORTING size = DATA(lv_before_size) ).
  WRITE: / |Total size before GC: { lv_before_size }| COLOR COL_POSITIVE.
  IF clear = abap_true.
     CLEAR: lr_result->*, lt_result, lr_result.
  ENDIF.
  "cl_abap_memory_utilities=>do_garbage_collection( ).
  cl_abap_memory_utilities=>get_total_used_size( IMPORTING size = DATA(lv_after_size) ).
  WRITE: / |Total size after GC: { lv_after_size }| COLOR COL_GROUP.
  DATA(rate) = ( lv_before_size - lv_after_size ) * 100 / lv_before_size.
  WRITE: / |Freed rate: { rate }%| COLOR COL_TOTAL.
ENDDO.

WRITE: / lines( lt_total ).