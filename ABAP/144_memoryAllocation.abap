REPORT z.

DATA: aa TYPE REF TO zcl_exception_test.

aa = NEW #( ).

DATA(lo_ref) = NEW cl_abap_weak_reference( oref = aa ).
DATA(result) = cl_abap_memory_utilities=>is_strongly_referenced( ref = lo_ref ).
WRITE: / result.

CLEAR: aa.

DATA(result2) = cl_abap_memory_utilities=>is_strongly_referenced( ref = lo_ref ).
WRITE: / result2.

DATA: lt_table TYPE string_table.

TYPES: tt_table TYPE TABLE OF tadir WITH KEY pgmid object.
DATA: lt_result TYPE TABLE OF tadir,
      lr_result TYPE REF TO tt_table.

SELECT * INTO TABLE lt_result FROM tadir UP TO 1000 ROWS.

DO 500 TIMES.
    CREATE DATA lr_result.
    lr_result->* = lt_result.

  cl_abap_memory_utilities=>get_memory_size_of_object( EXPORTING object = lt_result
      IMPORTING
        bound_size_alloc = DATA(bound_alloc)
        bound_size_used = DATA(bound_used) ).

  WRITE: / 'bound alloc:' , bound_alloc.
  WRITE: / 'bound used:' , bound_used.

  CL_ABAP_MEMORY_UTILITIES=>get_total_used_size( IMPORTING SIZE = data(size) ).
  WRITE: / 'total size before:' , size.
  "CLEAR: lr_result->*, lt_result, lr_result.
  CL_ABAP_MEMORY_UTILITIES=>do_garbage_collection( ).
  CL_ABAP_MEMORY_UTILITIES=>get_total_used_size( IMPORTING SIZE = size ).
  WRITE: / 'total size after:' , size.
ENDDO.