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

DO 10 TIMES.
  DO 1000 TIMES.
    APPEND '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ' TO lt_table.
  ENDDO.
  cl_abap_memory_utilities=>get_memory_size_of_object( EXPORTING object = lt_table
      IMPORTING
        bound_size_alloc = DATA(bound_alloc)
        bound_size_used = DATA(bound_used) ).

  WRITE: / 'bound alloc:' , bound_alloc.
  WRITE: / 'bound used:' , bound_used.
ENDDO.