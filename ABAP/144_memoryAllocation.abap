REPORT z.

TYPES: tt_table TYPE TABLE OF tadir WITH KEY pgmid object.
DATA: lt_result TYPE TABLE OF tadir,
      lt_total TYPE TABLE OF tadir,
      lr_result TYPE REF TO tt_table.

DATA: c1 type cursor.

OPEN CURSOR @c1 FOR SELECT * FROM TADIR.

DO.
    CREATE DATA lr_result.
   FETCH NEXT CURSOR @c1 INTO TABLE @lr_result->* PACKAGE SIZE 1000000.
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

  CL_ABAP_MEMORY_UTILITIES=>get_total_used_size( IMPORTING SIZE = data(size) ).
  WRITE: / 'total size before:' , size.
  CLEAR: lr_result->*, lt_result, lr_result.
  CL_ABAP_MEMORY_UTILITIES=>do_garbage_collection( ).
  CL_ABAP_MEMORY_UTILITIES=>get_total_used_size( IMPORTING SIZE = size ).
  WRITE: / 'total size after:' , size.
ENDDO.