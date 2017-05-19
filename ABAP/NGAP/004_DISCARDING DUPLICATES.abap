REPORT demo_corresponding_duplicates.

CLASS demo DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS main.
ENDCLASS.

CLASS demo IMPLEMENTATION.
  METHOD main.
    TYPES:
      BEGIN OF line,
        a1 TYPE i,
        a2 TYPE i,
      END OF line,
      ntab1 TYPE STANDARD TABLE OF line WITH EMPTY KEY,
      ntab2 TYPE SORTED   TABLE OF  line WITH UNIQUE KEY a1,
      BEGIN OF line1,
        x1 TYPE i,
        x2 TYPE ntab1,
      END OF line1,
      BEGIN OF line2,
        y1 TYPE i,
        y2 TYPE ntab2,
      END OF line2,
      itab1 TYPE STANDARD TABLE OF line1 WITH EMPTY KEY,
      itab2 TYPE SORTED   TABLE OF line2 WITH UNIQUE KEY y1.

    DATA(itab1) =
      VALUE itab1( ( x1 = 1 x2 = VALUE #( ( a1 = 1 a2 = 2 )
                                          ( a1 = 3 a2 = 4 ) ) )
                   ( x1 = 2 x2 = VALUE #( ( a1 = 1 a2 = 2 )
                                          ( a1 = 1 a2 = 4 ) ) )
                   ( x1 = 1 x2 = VALUE #( ( a1 = 1 a2 = 2 )
                                          ( a1 = 3 a2 = 4 ) ) ) ).

    DATA(itab2) =
      CORRESPONDING itab2( itab1 DISCARDING DUPLICATES
                           MAPPING y1 = x1
                                   y2 = x2 DISCARDING DUPLICATES ).

    DATA(out) = cl_demo_output=>new( ).
    LOOP AT itab2 INTO DATA(wa).
      out->write( wa-y1
        )->write( wa-y2
        )->line( ).
    ENDLOOP.
    out->display( ).

  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  demo=>main( ).