*&---------------------------------------------------------------------*
*& Report ZMOVE_CORRESPONDING
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZMOVE_CORRESPONDING.

DATA:
  BEGIN OF struct1,
    col1 TYPE i VALUE 11,
    col2 TYPE i VALUE 12,
  END OF struct1.

DATA:
  BEGIN OF struct2,
    col2 TYPE i VALUE 22,
    col3 TYPE i VALUE 23,
  END OF struct2.

*This is not the same as
*MOVE-CORRESPONDING struct2 TO struct1.
*Since the RHS does not know anything of the LHS, component col3 of struct2 does not
*keep its former value but is initialized.

struct2 = CORRESPONDING #( struct1 ).

DATA itab TYPE TABLE OF i.
itab = VALUE #( ( 1 ) ( 2 ) ( 3 ) ).
itab = VALUE #( ( 4 ) ( 5 ) ( 6 ) ). " 4,5,6 wins

BREAK-POINT.