*&---------------------------------------------------------------------*
*& Report ZFOR
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZFOR.
* 2015-09-14 21:36PM this program will print generate a 3 * 3 matrix
* 11 12 13
* 21 22 23
* 31 32 33

TYPES:
  BEGIN OF line,
    col1 TYPE i,
    col2 TYPE i,
    col3 TYPE i,
  END OF line,
  itab TYPE STANDARD TABLE OF line WITH EMPTY KEY.

DATA(itab) = VALUE itab(
     FOR j = 11 THEN j + 10 UNTIL j > 40
     ( col1 = j col2 = j + 1 col3 = j + 2  ) ).

BREAK-POINT.