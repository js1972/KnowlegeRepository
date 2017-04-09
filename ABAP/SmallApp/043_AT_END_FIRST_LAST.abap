REPORT demo_int_tables_at.

CLASS demo DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS main.
  PRIVATE SECTION.
    TYPES: BEGIN OF line,
             col1 TYPE c LENGTH 1,
             col2 TYPE i,
             col3 TYPE i,
           END OF line.
ENDCLASS.

CLASS demo IMPLEMENTATION.
  METHOD main.

    DATA itab TYPE HASHED TABLE OF line
              WITH UNIQUE KEY col1 col2.

    DATA(out) = cl_demo_output=>new( ).

    itab = VALUE #(
      FOR j = 1 UNTIL j > 3
       ( col1 = 'A'
         col2 = j
         col3 = j ** 2 )
       ( col1 = 'B'
         col2 = 2 * j
         col3 = ( 2 * j ) ** 2 ) ).

    SORT itab.

    DATA group LIKE itab.
    LOOP AT itab INTO DATA(line).
      AT NEW col1.
        CLEAR group.
      ENDAT.
      group = VALUE #( BASE group ( line ) ).
      AT END OF col1.
        out->write( group ).
        SUM.
        out->line( )->write( line )->line( ).
      ENDAT.
      AT LAST.
        SUM.
        out->line( )->write( line ).
      ENDAT.
    ENDLOOP.
    out->display( ).
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  demo=>main( ).