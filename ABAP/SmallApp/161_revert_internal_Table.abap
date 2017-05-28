report z.
CLASS demo DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS main.
ENDCLASS.

CLASS demo IMPLEMENTATION.
  METHOD main.
    DATA
      itab TYPE STANDARD TABLE OF i
           WITH EMPTY KEY
           WITH NON-UNIQUE SORTED KEY sort_key COMPONENTS table_line.

    itab = VALUE #( ( 2 ) ( 5 ) ( 1 ) ( 3 ) ( 4 ) ).

    DATA(output) =
      REDUCE string(
        INIT o = ``
        FOR  i = lines( itab ) THEN i - 1 WHILE i > 0
        NEXT o = o && COND #( LET r = itab[ KEY sort_key INDEX i ] IN
                              WHEN r > 2 THEN r && ` ` ELSE r ) ).

    cl_demo_output=>display( output ).
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  demo=>main( ).