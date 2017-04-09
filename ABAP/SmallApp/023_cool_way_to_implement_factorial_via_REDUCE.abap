*&---------------------------------------------------------------------*
*& Report ZAPPEND
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*


REPORT zcd_functional_factorial.

CLASS lcl_factorial DEFINITION.
  PUBLIC SECTION.
  METHODS factorial
    IMPORTING
      !n TYPE i
    RETURNING
      VALUE(result) TYPE i.
ENDCLASS.

CLASS lcl_factorial IMPLEMENTATION.
  METHOD factorial.
    result = COND i( WHEN n = 0
                       THEN 1
                     ELSE
                       REDUCE i( INIT r = 1
                                    FOR  i = 1 THEN i + 1 WHILE i <= n
                                    NEXT r = r * i ) ).
   ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  cl_demo_output=>display( NEW lcl_factorial( )->factorial( 9 ) ).