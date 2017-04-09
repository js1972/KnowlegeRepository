*&---------------------------------------------------------------------*
*& Report  ZNEWABAP1
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT ZNEWABAP1.
 TYPES:
      BEGIN OF line1,
        col1 TYPE i,
        col2 TYPE i,
        col3 TYPE i,
        col4 TYPE i,
      END OF line1,
      itab1 TYPE TABLE OF line1 WITH EMPTY KEY
                                WITH UNIQUE SORTED KEY
                                     key COMPONENTS col1,
      BEGIN OF line2,
        col1 TYPE i,
        col2 TYPE i,
      END OF line2,
      itab2 TYPE TABLE OF line1 WITH EMPTY KEY,
      itab3 TYPE TABLE OF line2 WITH EMPTY KEY,
      itab4 TYPE TABLE OF i     WITH EMPTY KEY.

    DATA(out) = cl_demo_output=>new( ).

    DATA(itab1) = VALUE itab1(
      ( col1 = 41 col2 = 42 col3 = 43 col4 = 44 )
      ( col1 = 31 col2 = 32 col3 = 33 col4 = 34 )
      ( col1 = 21 col2 = 22 col3 = 23 col4 = 24 )
      ( col1 = 11 col2 = 12 col3 = 13 col4 = 14 ) ).
    "out->write( itab1 ).

    DATA(itab2) = VALUE itab2(
      FOR wa IN itab1 WHERE ( col1 < 30 )
        ( col1 = wa-col1
          col3 = wa-col3 + wa-col1
          ) ).
    BREAK-POINT.